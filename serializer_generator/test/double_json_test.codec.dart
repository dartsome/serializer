// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SerializerGenerator
// **************************************************************************

library double_json_test.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
import 'package:serializer/codecs.dart';
import 'double_json_test.dart';

class DoubleSimpleCodec extends TypeCodec<DoubleSimple> {
  @override
  DoubleSimple decode(dynamic value, {Serializer serializer}) {
    DoubleSimple obj = new DoubleSimple();
    obj.test = value['test']?.toDouble() ?? obj.test;
    return obj;
  }

  @override
  dynamic encode(DoubleSimple value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['test'] = value.test?.toDouble();
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'DoubleSimple';
}

class DoubleComplexCodec extends TypeCodec<DoubleComplex> {
  @override
  DoubleComplex decode(dynamic value, {Serializer serializer}) {
    DoubleComplex obj = new DoubleComplex();
    Map _map = serializer?.decode(value['map'], mapOf: const [String, double]);
    obj.map = (_map != null
            ? new Map.fromIterable(_map.keys,
                key: (key) => key, value: (key) => _map[key]?.toDouble())
            : null) ??
        obj.map;
    List _list = serializer?.decode(value['list'], type: double);
    obj.list = (_list != null
            ? new List<double>.from(_list.map((item) => item?.toDouble()))
            : null) ??
        obj.list;
    return obj;
  }

  @override
  dynamic encode(DoubleComplex value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['map'] = value.map;
    map['list'] = value.list;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'DoubleComplex';
}

Map<String, TypeCodec<dynamic>> test_double_json_test_codecs =
    <String, TypeCodec<dynamic>>{
  'DoubleSimple': new DoubleSimpleCodec(),
  'DoubleComplex': new DoubleComplexCodec(),
};
