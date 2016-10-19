// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: SerializerGenerator
// Target: library
// **************************************************************************

library model_b.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
import 'package:serializer/codecs.dart';
import 'model_b.dart';

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelB
// **************************************************************************

class ModelBCodec extends TypeCodec<ModelB> {
  @override
  ModelB decode(dynamic value, {Serializer serializer}) {
    ModelB obj = new ModelB();
    obj.C = (serializer?.decode(value['C'], type: ModelC, useTypeInfo: false) ??
        obj.C) as Map<String, ModelC>;
    obj.A = (serializer?.decode(value['A'], type: ModelA, useTypeInfo: false) ??
        obj.A) as List<ModelA>;
    obj.a = (serializer?.decode(value['a'], type: ModelA, useTypeInfo: false) ??
        obj.a) as ModelA;
    return obj;
  }

  @override
  dynamic encode(ModelB value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['C'] = serializer?.toPrimaryObject(value.C,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['A'] = serializer?.toPrimaryObject(value.A,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['a'] = serializer?.toPrimaryObject(value.a,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'ModelB';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelC
// **************************************************************************

class ModelCCodec extends TypeCodec<ModelC> {
  @override
  ModelC decode(dynamic value, {Serializer serializer}) {
    ModelC obj = new ModelC();
    obj.foo = (value['foo'] ?? obj.foo) as String;
    obj.C = (serializer?.decode(value['C'], type: ModelC, useTypeInfo: false) ??
        obj.C) as Map<String, ModelC>;
    obj.A = (serializer?.decode(value['A'], type: ModelA, useTypeInfo: false) ??
        obj.A) as List<ModelA>;
    obj.a = (serializer?.decode(value['a'], type: ModelA, useTypeInfo: false) ??
        obj.a) as ModelA;
    return obj;
  }

  @override
  dynamic encode(ModelC value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['foo'] = value.foo;
    map['C'] = serializer?.toPrimaryObject(value.C,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['A'] = serializer?.toPrimaryObject(value.A,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['a'] = serializer?.toPrimaryObject(value.a,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'ModelC';
}

Map<String, TypeCodec<dynamic>> example_model_b_codecs =
    <String, TypeCodec<dynamic>>{
  'ModelB': new ModelBCodec(),
  'ModelC': new ModelCCodec(),
};
