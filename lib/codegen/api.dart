// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file

// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library serializer.api;

import 'dart:convert';

import 'package:serializer/codecs/type_codec.dart';
import '../core.dart';

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

  Map<String, dynamic> toMap(Object input, {bool useTypeInfo, bool withTypeInfo}) => toPrimaryObject(input,
      useTypeInfo: useTypeInfo,
      withTypeInfo: withTypeInfo) as Map<String, dynamic>;

  /// Convert to a Map or a List recursively
  Object toPrimaryObject(Object input, {bool useTypeInfo, bool withTypeInfo}) =>
      _encodeValue(input, withReferenceable: true, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);

  /// Encode the object to serialized string
  String encode(Object input, {bool useTypeInfo, bool withTypeInfo}) =>
      _encode(input, withReferenceable: true, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);

  /// Decode the object from a seriablized string
  Object decode(dynamic encoded, {Type type, List<Type> mapOf, bool useTypeInfo, bool withTypeInfo}) =>
      _decode(encoded, type: type, mapOf: mapOf, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);

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
        }
        return typeCodecFromString(name)?.type;
    }
  }

  Object _decode(dynamic encoded, {Type type, List<Type> mapOf, bool useTypeInfo, bool withTypeInfo}) {
    if (encoded == null) {
      return null;
    }
    dynamic value = encoded;
    if (value is String) {
      if ((value.startsWith("{") && value.endsWith("}")) || (value.startsWith("[") && value.endsWith("]"))) {
        value = _codec.decode(encoded);
      } else {
        value = num.parse(encoded, (_) => null) ?? value;
      }
    }
    if (value is Map) {
      return _fromMap(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo, mapOf: mapOf);
    } else if (value is List) {
      return _fromList(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    }
    return _decodeValue(value, type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
  }

  Object _fromMap(Map map, {Type type, List<Type> mapOf, bool useTypeInfo, bool withTypeInfo}) {
    if (map == null || map.isEmpty) {
      return null;
    }

    if ((_enableTypeInfo(useTypeInfo, withTypeInfo) || type == dynamic) && map.containsKey(_typeInfoKey)) {
      type = _decodeType(map[_typeInfoKey]);
    } else {
      type ??= Map;
    }

    // Only Map
    if (type == Map) {
      Type embedType = mapOf != null && mapOf.length >= 2 ? mapOf[1] : null;
      Map data = new Map();
      map.forEach((key, value) => data[key.toString()] = _decodeValue(value, embedType, useTypeInfo: useTypeInfo));
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
    if (isPrimaryType(type) ||
        value.runtimeType == type ||
        (isPrimaryType(value.runtimeType) && hasTypeCodec(type) == false)) {
      return value;
    } else if (hasTypeCodec(type) == true) {
      TypeCodec codec = typeCodec(type);
      dynamic val = codec.decode(value, serializer: this);
      return val;
    } else if (type.toString().startsWith("Map") || type.toString().startsWith("List")) {
      if (value is Map) {
        if (type.toString().startsWith("Map")) {
          return _fromMap(value,
              type: Map, mapOf: _findGenericOfMap(type), useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
        }
        return _fromMap(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
      } else if (value is List) {
        if (type.toString().startsWith("List") && value is List) {
          return _fromList(value, type: _findGenericOfList(type), useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
        }
        return _fromList(value, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
      }
    }

    return null;
  }

  Object _encodeValue(Object value, {bool withReferenceable: false, Type type, bool useTypeInfo, bool withTypeInfo}) {
    useTypeInfo ??= _useTypeInfo;
    if (isPrimaryType(value.runtimeType) == true) {
      return value;
    } else if (hasTypeCodec(value.runtimeType) == true) {
      TypeCodec codec = typeCodec(value.runtimeType);
      return codec.encode(value, serializer: this, typeInfoKey: useTypeInfo == true ? _typeInfoKey : null);
    } else if (value is Map) {
      return _encodeMap(value,
          withReferenceable: withReferenceable, type: type, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    } else if (value is List) {
      return _encodeList(value,
          withReferenceable: withReferenceable, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    }
    return null;
  }

  Object _encodeMap(Map value, {bool withReferenceable: false, Type type, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();

    value.forEach((dynamic key, dynamic val) {
      map[key.toString()] = toPrimaryObject(val, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
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
    Object val = toPrimaryObject(obj, useTypeInfo: useTypeInfo, withTypeInfo: withTypeInfo);
    return _codec.encode(val);
  }
}
