// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file

// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library serializer.reflectable.api;

import 'dart:convert';

import 'package:reflectable/reflectable.dart';
import 'package:serializer/codecs/type_codec.dart';

import '../core.dart';
import 'annotations.dart';
import "convert.dart";

final _serializerJson = new ReflectableSerializer.json();
final _serializerTypedJson = new ReflectableSerializer.typedJson();

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
  Serializer get serializer => _serializerJson;

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
  Serializer get serializer => _serializerTypedJson;

  /// Convert the object to a map
  Map toMap() => serializer.toMap(this);

  /// Convert the object to JSON string
  String toJson() => serializer.encode(this);
}


/// Utility class to access to the serializer api
class ReflectableSerializer extends Serializer {
  static final Map<String, ClassSerialiazerInfo> _classes = singletonClasses;

  ///////////////////
  // Public
  /////////////////////////////////////////////////////////////////////////////

  /// Dump serializable classes
  static dumpSerializables() => printAndDumpSerializables();

  final Codec _codec;
  final String _typeInfoKey;
  final bool _useTypeInfo;
  final Map<String, TypeCodec> _typeCodecs = <String, TypeCodec>{};

  String get typeInfoKey => _typeInfoKey;
  bool get useTypeInfo => _useTypeInfo;

  /// Create a Serializer with a optional codec and type info key.
  /// The type info key is an added field (i.e. "@type") during the serialization,
  /// storing the type of the Dart Object
  ReflectableSerializer(
      {Map<String, TypeCodec> typesCodecs, Codec codec: JSON, String typeInfoKey: "@type", useTypeInfo: false})
      :
        _codec = codec,
        _typeInfoKey = typeInfoKey,
        _useTypeInfo = useTypeInfo {
    initSingletonClasses();
  }

  /// Create a default JSON serializer
  factory ReflectableSerializer.json() {
    return new ReflectableSerializer(codec: JSON);
  }

  /// Create a default JSON serializer
  /// with '@type' added field
  factory ReflectableSerializer.typedJson() {
    return new ReflectableSerializer(codec: JSON, useTypeInfo: true);
  }


  @override
  addAllTypeCodecs(Map<String, TypeCodec> typesCodecs) {
    _typeCodecs.addAll(typesCodecs ?? {});
  }

  /// Registers a [typeCodec] for the specific [type]
  addTypeCodec(Type type, TypeCodec typeCodec) => _typeCodecs[type.toString()] = typeCodec;

  /// Checks if a TypeCodec is registered for the [type].
  bool hasTypeCodec(Type type) => _typeCodecs.containsKey(type.toString());

  /// Get the TypeCodec for the specific [type]
  TypeCodec typeCodec(Type type) => _typeCodecs[type.toString()];

  /// Checks if a class is registered as a Serializable class.
  bool isSerializable(Type type) => _classes.containsKey(_getCorrectType(type.toString()));

  /// Convert the object to a Map
  Map<String, dynamic> toMap(Object input, {bool useTypeInfo, bool withTypeInfo}) =>
      _toMap(input, withReferenceable: true, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo) as Map<String, dynamic>;

  /// Convert to a Map or a List recursively
  Object toPrimaryObject(Object input, {bool useTypeInfo, bool withTypeInfo}) =>
      _encodeValue(input, withReferenceable: true, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);

  /// Encode the object to serialized string
  String encode(Object input, {bool useTypeInfo, bool withTypeInfo}) =>
      _encode(input, withReferenceable: true, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);

  /// Decode the object from a seriablized string
  Object decode(dynamic encoded, {Type type, List<Type> mapOf, bool useTypeInfo, bool withTypeInfo}) =>
      _decode(encoded, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);

  /// Convert a serialized object to map
  Object fromMap(Map map, {Type type, List<Type> mapOf, bool useTypeInfo, bool withTypeInfo}) =>
      _fromMap(map, type: type, mapOf: mapOf, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);

  /// Convert a serialized object's [list] to a list of the given [type]
  List<dynamic> fromList(List list, {Type type, bool useTypeInfo, bool withTypeInfo}) =>
      _fromList(list, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);

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

  String _getCorrectType(String name) {
    String type = correspondingMinifiedTypes[name];
    if (type != null && _classes.containsKey(type)) {
      return type;
    }
    return name;
  }

  Type _decodeType(String name) {
    name = _getCorrectType(name);
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

  Object _decode(dynamic encoded, {Type type, bool useTypeInfo, bool withTypeInfo}) {
    if (encoded == null) {
      return null;
    }
    dynamic value = encoded;
    if (value is String) {
      if (value.isEmpty) {
        return null;
      }
      if ((value.startsWith("{") && value.endsWith("}")) || (value.startsWith("[") && value.endsWith("]"))) {
        value = _codec.decode(encoded);
      } else {
        value = num.parse(encoded, (_) => null) ?? encoded;
      }
    }
    if (value is Map) {
      return _fromMap(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (value is List) {
      return _fromList(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    }
    return _decodeValue(value, type, useTypeInfo: useTypeInfo);
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

  Object _fromMap(Map map, {Type type, List<Type> mapOf, bool useTypeInfo, bool withTypeInfo}) {
    if (map == null || map.isEmpty) {
      return null;
    }

    if ((enableTypeInfo(useTypeInfo, withTypeInfo) || type == dynamic) && map.containsKey(_typeInfoKey)) {
      type = _decodeType(map.remove(_typeInfoKey));
    } else {
      type ??= Map;
    }

    // Only Map
    if (type == Map) {
      Type embedType = mapOf != null ? mapOf[1] : null;
      Map data = new Map();
      map.forEach((key, value) => data[key] = _decodeValue(value, embedType, useTypeInfo: useTypeInfo));
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
          var value = _decodeValue(map[name], internalType,
              useTypeInfo: useTypeInfo, withTypeInfo: serializedWithTypeInfoMetadataManager.hasMetadata(dec));
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

  List _fromList(List list, {Type type, bool useTypeInfo, bool withTypeInfo}) {
    List data = new List();
    list.forEach((value) => data.add(_decodeValue(value, type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo)));
    return data;
  }

  Object _decodeValue(Object value, Type type, {bool useTypeInfo, bool withTypeInfo}) {
    if (value == null) {
      return null;
    }
    type ??= _decodeType(value.runtimeType.toString());
    if (hasTypeCodec(type)) {
      return typeCodec(type).decode(value, serializer: this);
    } else if ((isSerializable(type) || type == dynamic) && value is Map) {
      return _fromMap(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if ((isSerializable(type) || type == dynamic) && value is List) {
      return _fromList(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (type.toString().startsWith("Map")) {
      return _fromMap(
          value, type: Map, mapOf: _findGenericOfMap(type), useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (type.toString().startsWith("List")) {
      return _fromList(value, type: _findGenericOfList(type), useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (type == null || isPrimaryType(type) || isSerializable(type) || type == dynamic) {
      return value;
    }
    return null;
  }

  Object _encodeValue(value, {bool withReferenceable: false, Type type, bool useTypeInfo, bool withTypeInfo}) {
    if (hasTypeCodec(value.runtimeType)) {
      return typeCodec(value.runtimeType).encode(value, serializer: this);
    } else if (value is Map || isSerializable(value.runtimeType)) {
      return _toMap(value, withReferenceable: withReferenceable,
          type: type,
          useTypeInfo: useTypeInfo,
          withTypeInfo: withTypeInfo);
    } else if (value is List) {
      return _encodeList(
          value, withReferenceable: withReferenceable, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (isPrimaryType(value.runtimeType)) {
      return value;
    }
    return null;
  }

  List _encodeList(List list, {bool withReferenceable: false, Type type, bool useTypeInfo, bool withTypeInfo}) {
    return list.map((elem) =>
        _encodeValue(elem, withReferenceable: withReferenceable, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo))
        .toList(growable: false);
  }

  _encodeMap(Map data, key, value, {Type type, bool useTypeInfo, bool withTypeInfo}) {
    value = _encodeValue(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    if (value != null) {
      data[key] = value;
    }
  }

  Map _toMap(Object obj, {bool withReferenceable: false, Type type, bool useTypeInfo, bool withTypeInfo}) {
    if (obj == null || obj is List) {
      return null;
    }
    if (obj is Map) {
      Map data = new Map();
      obj.forEach((key, value) => _encodeMap(data, key, value, useTypeInfo: useTypeInfo));
      return data;
    }
    InstanceMirror mir = serializable.reflect(obj);
    ClassMirror cm = mir.type;
    Map data = new Map();

    if (enableTypeInfo(useTypeInfo, withTypeInfo) || type == dynamic) {
      data[_typeInfoKey] = _getCorrectType(obj.runtimeType.toString());
    }

    while (cm != null && cm.superclass != null && isSerializableClassMirror(_classes, cm)) {
      cm.declarations.forEach((String originalName, DeclarationMirror dec) {
        var name = serializedName(dec);

        if (!data.containsKey(name) &&
            !ignoreMetadataManager.hasMetadata(dec) &&
            ((dec is VariableMirror && isSerializableVariable(dec)) || (dec is MethodMirror && dec.isGetter)) &&
            isEncodeableField(_classes, cm, dec, withReferenceable)) {
          Type internalType = _getMethodMirrorReturnType(cm.instanceMembers[originalName]);
          _encodeMap(data, name, mir.invokeGetter(originalName), type: internalType,
              useTypeInfo: useTypeInfo, withTypeInfo: serializedWithTypeInfoMetadataManager.hasMetadata(dec));
        }
      });
      cm = cm?.superclass;
    }
    return data;
  }

  String _encode(Object obj, {bool withReferenceable: false, bool useTypeInfo, bool withTypeInfo}) {
    if (obj == null) {
      return null;
    }
    if (obj is List) {
      return _codec.encode(
          _encodeList(obj, withReferenceable: withReferenceable, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo));
    }
    return _codec.encode(
        _toMap(obj, withReferenceable: withReferenceable, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo));
  }
}
