// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file

// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:reflectable/reflectable.dart';
import 'package:serializer/codecs/type_codec.dart';

import 'annotations.dart';
import "convert.dart";

final _SerializerJson = new Serializer.Json();
final _SerializerTypedJson = new Serializer.TypedJson();

/// Utility class for a Serializable object
@serializable
abstract class Serialize {
  /// Get the serializer instance
  @ignore
  Serializer get serializer;

  /// Convert the object to a map
  Map toMap() => serializer?.toPrimaryObject(this) as Map;

  /// Override the toString method to show a stringify map of the object
  String toString() => toMap().toString();

  String encode() => serializer?.encode(this);
}

/// Utility class for a JSON object
@serializable
abstract class JsonObject extends Serialize {
  /// Get the JSON serializer instance
  @ignore
  Serializer get serializer => _SerializerJson;

  /// Convert the object to JSON string
  String toJson() => encode();

  /// Convert the object to a map
  Map toMap() => serializer.toPrimaryObject(this) as Map;

  String encode() => serializer.encode(this);
}

/// Utility class for a typed JSON object
@serializable
abstract class TypedJsonObject extends Serialize {
  /// Get the typed JSON serializer instance
  @ignore
  Serializer get serializer => _SerializerTypedJson;

  /// Convert the object to a map
  Map toMap() => serializer.toMap(this);

  /// Convert the object to JSON string
  String toJson() => serializer.encode(this);
}

/// Utility class to access to the serializer api
class Serializer {
  static final Map<String, ClassSerialiazerInfo> _classes = singletonClasses;

  ///////////////////
  // Public
  /////////////////////////////////////////////////////////////////////////////

  /// Dump serializable classes
  static dumpSerializables() => printAndDumpSerializables();

  final String _typeInfoKey;
  final Codec _codec;
  final Map<String, TypeCodec> _typeCodecs = <String, TypeCodec>{};

  /// Create a Serializer with a optional codec and type info key.
  /// The type info key is an added field (i.e. "@type") during the serialization,
  /// storing the type of the Dart Object
  Serializer([this._codec = JSON, this._typeInfoKey]) {
    initSingletonClasses();
  }

  /// Create a default JSON serializer
  factory Serializer.Json() {
    return new Serializer(JSON);
  }

  /// Create a default JSON serializer
  /// with '@type' added field
  factory Serializer.TypedJson() {
    return new Serializer(JSON, "@type");
  }

  /// Registers a [typeCodec] for the specific [type]
  addTypeCodec(Type type, TypeCodec typeCodec) => _typeCodecs[type.toString()] = typeCodec;

  /// Checks if a TypeCodec is registered for the [type].
  bool hasTypeCodec(Type type) => _typeCodecs.containsKey(type.toString());

  /// Get the TypeCodec for the specific [type]
  TypeCodec typeCodec(Type type) => _typeCodecs[type.toString()];

  /// Checks if a class is registered as a Serializable class.
  bool isSerializable(Type type) => _classes.containsKey(type.toString());

  /// Convert the object to a Map
  Map toMap(Object input) => _toMap(input, true);

  /// Convert to a Map or a List recursively
  Object toPrimaryObject(Object input) => _encodeValue(input, true);

  /// Encode the object to serialized string
  String encode(Object input) => _encode(input, true);

  /// Decode the object from a seriablized string
  Object decode(String encoded, [Type type]) => _decode(encoded, type);

  /// Convert a serialized object to map
  Object fromMap(Map map, [Type type, List<Type> mapOf]) => _fromMap(map, type, mapOf);

  /// Convert a serialized object's [list] to a list of the given [type]
  List fromList(List list, [Type type]) => _fromList(list, type);

  ///////////////////
  // Private
  /////////////////////////////////////////////////////////////////////////////
  List<Type> _findGenericOfMap(Type type) {
    String str = type.toString();
    RegExp reg = new RegExp(r"^Map<(.*)\ *,\ *(.*)>$");
    Iterable<Match> matches = reg.allMatches(str);
    if (matches == null || matches.isEmpty) {
      return null;
    }
    return [_decodeType(matches.first.group(1)), _decodeType(matches.first.group(2))];
  }

  Type _findGenericOfList(Type type) {
    String str = type.toString();
    RegExp reg = new RegExp(r"^List<(.*)>$");
    Iterable<Match> matches = reg.allMatches(str);
    if (matches == null || matches.isEmpty) {
      return null;
    }
    return _decodeType(matches.first.group(1));
  }

  Type _decodeType(String name) {
    switch (name) {
      case "num":
        return num;
      case "String":
        return String;
      case "bool":
        return bool;
      case "int":
        return int;
      case "double":
        return double;
      case "Map":
      case "_JsonMap":
        return Map;
      case "List":
        return List;
      default:
        if (name == MapTypeString) {
          return Map;
        } else if (name == ListTypeString) {
          return List;
        } else if (_typeCodecs.containsKey(name)) {
          return _typeCodecs[name].type;
        } else {
          ClassMirror classMirror = _classes[name]?.classMirror;
          return classMirror?.dynamicReflectedType;
        }
    }
  }

  Object _decode(String encoded, [Type type]) {
    if (encoded == null || encoded.isEmpty) {
      return null;
    }
    var value = _codec.decode(encoded);
    if (value is Map) {
      return _fromMap(value, type);
    } else if (value is List) {
      return _fromList(value, type);
    }
    return _decodeValue(value, type);
  }

  //fixme: dirty
  Type _getMethodMirrorReturnType(MethodMirror m) {
    try {
      return m.reflectedReturnType;
    } catch (e) {
      if (m.hasDynamicReflectedReturnType) {
        return m.dynamicReflectedReturnType;
      }
    }
    return m.returnType.reflectedType;
  }

  Object _fromMap(Map map, [Type type, List<Type> mapOf]) {
    if (map == null || map.isEmpty) {
      return null;
    }

    if (_typeInfoKey != null && map.containsKey(_typeInfoKey)) {
      type = _decodeType(map.remove(_typeInfoKey));
    } else {
      type ??= Map;
    }

    // Only Map
    if (type == Map) {
      Type embedType = mapOf != null ? mapOf[1] : null;
      Map data = new Map();
      map.forEach((key, value) => data[key] = _decodeValue(value, embedType));
      return data;
    }

    // Class from Map
    ClassMirror cm;
    Object obj;
    InstanceMirror instance;
    try {
      cm = serializable.reflectType(type);
      obj = cm.newInstance('', []);
      instance = serializable.reflect(obj);
    } catch (e) {
      throw e.toString();
    }

    var visitedNames = [];
    while (cm != null && cm.superclass != null && isSerializableClassMirror(_classes, cm)) {
      cm.declarations.forEach((String originalName, DeclarationMirror dec) {
        var name = serializedName(dec);
        if (map.containsKey(name) &&
            !visitedNames.contains(name) &&
            !ignoreMetadataManager.hasMetadata(dec) &&
            ((dec is VariableMirror && isSerializableVariable(dec)) || (dec is MethodMirror))) {
          Type internalType = _getMethodMirrorReturnType(cm.instanceMembers[originalName]);
          var value = _decodeValue(map[name], internalType);
          if (value != null) {
            instance.invokeSetter(originalName, value);
            visitedNames.add(name);
          }
        }
      });
      cm = cm?.superclass;
    }

    return instance.reflectee;
  }

  List _fromList(List list, [Type type]) {
    List data = new List();
    list.forEach((value) => data.add(_decodeValue(value, type)));
    return data;
  }

  Object _decodeValue(Object value, Type type) {
    if (value == null) {
      return null;
    }
    type ??= _decodeType(value.runtimeType.toString());
    if (hasTypeCodec(type)) {
      return typeCodec(type).decode(value);
    } else if (isSerializable(type) && value is Map) {
      return _fromMap(value, type);
    } else if (isSerializable(type) && value is List) {
      return _fromList(value, type);
    } else if (type.toString().startsWith("Map")) {
      return _fromMap(value, Map, _findGenericOfMap(type));
    } else if (type.toString().startsWith("List")) {
      return _fromList(value, _findGenericOfList(type));
    } else if (type == null || isPrimaryType(type) || isSerializable(type)) {
      return value;
    }
    return null;
  }

  Object _encodeValue(value, [bool withReferenceable = false]) {
    if (hasTypeCodec(value.runtimeType)) {
      return typeCodec(value.runtimeType).encode(value);
    } else if (value is Map || isSerializable(value.runtimeType)) {
      return _toMap(value, withReferenceable);
    } else if (value is List) {
      return _encodeList(value, withReferenceable);
    } else if (isPrimaryType(value.runtimeType)) {
      return value;
    }
    return null;
  }

  List _encodeList(List list, [bool withReferenceable = false]) {
    return list.map((elem) => _encodeValue(elem, withReferenceable)).toList(growable: false);
  }

  _encodeMap(Map data, key, value) {
    value = _encodeValue(value);
    if (value != null) {
      data[key] = value;
    }
  }

  Map _toMap(Object obj, [bool withReferenceable = false]) {
    if (obj == null || obj is List) {
      return null;
    }
    if (obj is Map) {
      Map data = new Map();
      obj.forEach((key, value) => _encodeMap(data, key, value));
      return data;
    }
    InstanceMirror mir = serializable.reflect(obj);
    ClassMirror cm = mir.type;
    Map data = new Map();

    if (_typeInfoKey != null) {
      data[_typeInfoKey] = obj.runtimeType.toString();
    }

    while (cm != null && cm.superclass != null && isSerializableClassMirror(_classes, cm)) {
      cm.declarations.forEach((String originalName, DeclarationMirror dec) {
        var name = serializedName(dec);

        if (!data.containsKey(name) &&
            !ignoreMetadataManager.hasMetadata(dec) &&
            ((dec is VariableMirror && isSerializableVariable(dec)) || (dec is MethodMirror && dec.isGetter)) &&
            isEncodeableField(_classes, cm, dec, withReferenceable)) {
          _encodeMap(data, name, mir.invokeGetter(originalName));
        }
      });
      cm = cm?.superclass;
    }
    return data;
  }

  String _encode(Object obj, [bool withReferenceable = false]) {
    if (obj == null) {
      return null;
    }
    if (obj is List) {
      return _codec.encode(_encodeList(obj, withReferenceable));
    }
    return _codec.encode(_toMap(obj, withReferenceable));
  }
}
