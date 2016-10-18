// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file

// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library serializer.api;

import 'dart:convert';

import 'package:serializer/codecs/type_codec.dart';
import '../core.dart';

import 'annotations.dart';

final _serializerJson = new CodegenSerializer.json();
final _serializerTypedJson = new CodegenSerializer.typedJson();

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
class CodegenSerializer implements Serializer {
  ///////////////////
  // Public
  /////////////////////////////////////////////////////////////////////////////

  /// Dump serializable classes
  //static dumpSerializables() => printAndDumpSerializables();

  final Codec _codec;
  final String _typeInfoKey;
  final bool _useTypeInfo;
  final Map<String, TypeCodec> _typeCodecs = <String, TypeCodec>{};

  CodegenSerializer(
      {Map<String, TypeCodec> typesCodecs, Codec codec: JSON, String typeInfoKey: "@type", useTypeInfo: false})
      : _codec = codec,
        _typeInfoKey = typeInfoKey,
        _useTypeInfo = useTypeInfo {
    addAllTypeCodecs(typesCodecs);
  }

  factory CodegenSerializer.json({Map<String, TypeCodec> typesCodecs}) {
    return new CodegenSerializer(typesCodecs: typesCodecs, codec: JSON);
  }

  factory CodegenSerializer.typedJson({Map<String, TypeCodec> typesCodecs}) {
    return new CodegenSerializer(typesCodecs: typesCodecs, codec: JSON, useTypeInfo: true);
  }

  addTypeCodec(Type type, TypeCodec typeCodec) => _typeCodecs[type.toString()] = typeCodec;

  @override
  addAllTypeCodecs(Map<String, TypeCodec> typesCodecs) {
    _typeCodecs.addAll(typesCodecs ?? {});
  }

  bool hasTypeCodec(Type type) => _typeCodecs.values?.any((TypeCodec tc) => tc.type == type);

  TypeCodec typeCodec(Type type) =>
      _typeCodecs.values.firstWhere((TypeCodec tc) => tc.type == type, orElse: () => null);

  TypeCodec typeCodecFromString(String type) =>
      _typeCodecs.values.firstWhere((TypeCodec tc) => tc.typeInfo == type, orElse: () => null);

  bool isSerializable(Type type) => hasTypeCodec(type);

  Map<String, dynamic> toMap(Object input, {bool useTypeInfo, bool withTypeInfo}) => _encodeValue(input,
      type: input.runtimeType,
      withReferenceable: true,
      useTypeInfo: useTypeInfo,
      withTypeInfo: withTypeInfo) as Map<String, dynamic>;

  /// Convert to a Map or a List recursively
  Object toPrimaryObject(Object input, {bool useTypeInfo, bool withTypeInfo}) =>
      _encodeValue(input, withReferenceable: true, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);

  /// Encode the object to serialized string
  String encode(Object input, {bool useTypeInfo, bool withTypeInfo}) =>
      _encode(input, withReferenceable: true, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);

  /// Decode the object from a seriablized string
  Object decode(String encoded, {Type type, bool useTypeInfo, bool withTypeInfo}) =>
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
  bool _enableTypeInfo(bool useTypeInfo, bool withTypeInfo) =>
      useTypeInfo != null ? useTypeInfo || (withTypeInfo ?? false) : _useTypeInfo || (withTypeInfo ?? false);

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
    /*   String type = correspondingMinifiedTypes[name]; //todo: check minified
    if (type != null && _classes.containsKey(type)) {
      return type;
    }*/
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
        }
        return null;
    }
  }

  Object _decode(String encoded, {Type type, bool useTypeInfo, bool withTypeInfo}) {
    if (encoded == null || encoded.isEmpty) {
      return null;
    }
    dynamic value;
    if ((encoded.startsWith("{") && encoded.endsWith("}")) || (encoded.startsWith("[") && encoded.endsWith("]"))) {
      value = _codec.decode(encoded);
    } else {
      value = num.parse(encoded, (_) => null) ?? encoded;
    }
    if (value is Map) {
      return _fromMap(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (value is List) {
      return _fromList(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    }
    return _decodeValue(value, type, useTypeInfo: useTypeInfo);
  }

  Object _fromMap(Map map, {Type type, List<Type> mapOf, bool useTypeInfo, bool withTypeInfo}) {
    if (map == null || map.isEmpty) {
      return null;
    }

    if ((_enableTypeInfo(useTypeInfo, withTypeInfo) || type == dynamic) && map.containsKey(_typeInfoKey)) {
      type = _decodeType(map.remove(_typeInfoKey));
    } else {
      type ??= Map;
    }

    print(map);
    print(type);

    // Only Map
    if (type == Map) {
      Type embedType = mapOf != null ? mapOf[1] : null;
      Map data = new Map();
      map.forEach((key, value) => data[key] = _decodeValue(value, embedType, useTypeInfo: useTypeInfo));
      return data;
    }
    return _decodeValue(map, type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
  }

  List<dynamic> _fromList(List list, {Type type, bool useTypeInfo, bool withTypeInfo}) {
    List<dynamic> data = new List<dynamic>();
    list.forEach((value) => data.add(_decodeValue(value, type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo)));
    return data;
  }

  Object _decodeValue(Object value, Type type, {bool useTypeInfo, bool withTypeInfo}) {
    if (value == null) {
      return null;
    }
    type ??= _decodeType(value.runtimeType.toString());
    if (hasTypeCodec(type) == true) {
      return typeCodec(type).decode(value, serializer: this);
    } else if ((isSerializable(type) || type == dynamic) && value is Map) {
      return _fromMap(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if ((isSerializable(type) || type == dynamic) && value is List) {
      return _fromList(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (type.toString().startsWith("Map")) {
      return _fromMap(value,
          type: Map, mapOf: _findGenericOfMap(type), useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (type.toString().startsWith("List")) {
      return _fromList(value, type: _findGenericOfList(type), useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (type == null || isPrimaryType(type) || isSerializable(type) || type == dynamic) {
      return value;
    }
    return null;
  }

  Object _encodeValue(value, {bool withReferenceable: false, Type type, bool useTypeInfo, bool withTypeInfo}) {
    useTypeInfo ??= _useTypeInfo;
    if (hasTypeCodec(value.runtimeType) == true) {
      return typeCodec(value.runtimeType)
          .encode(value, serializer: this, typeInfoKey: useTypeInfo == true ? _typeInfoKey : null);
    } else if (value is Map) {
      return _encodeMap(value,
          withReferenceable: withReferenceable, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (value is List) {
      return _encodeList(value,
          withReferenceable: withReferenceable, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (isPrimaryType(value.runtimeType)) {
      return value;
    }
    return null;
  }

  Object _encodeMap(Map value, {bool withReferenceable: false, Type type, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();

    value.forEach((dynamic key, dynamic val) {
      map[key.toString()] =
          _encode(val, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo, withReferenceable: withReferenceable);
    });

    return map;
  }

  List _encodeList(List list, {bool withReferenceable: false, Type type, bool useTypeInfo, bool withTypeInfo}) {
    return list
        .map((elem) => _encodeValue(elem,
            withReferenceable: withReferenceable, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo))
        .toList(growable: false);
  }

  String _encode(Object obj, {bool withReferenceable: false, bool useTypeInfo, bool withTypeInfo: false}) {
    if (obj == null) {
      return null;
    }
    if (obj is List) {
      return _codec.encode(
          _encodeList(obj, withReferenceable: withReferenceable, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo));
    }
    return _codec.encode(_encodeValue(obj,
        type: obj.runtimeType,
        withReferenceable: withReferenceable,
        useTypeInfo: useTypeInfo,
        withTypeInfo: withTypeInfo));
  }
}
