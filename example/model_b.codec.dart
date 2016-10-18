// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: SerializerGenerator
// Target: library
// **************************************************************************

library model_b.codec;

import 'package:serializer/core.dart' show Serializer;
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
    obj.C = (serializer?.isSerializable(ModelC) == true
            ? serializer?.decode(value['C'], type: ModelC)
            : value['C']) as Map<String, ModelC> ??
        obj.C;
    obj.A = (serializer?.isSerializable(ModelA) == true
            ? serializer?.decode(value['A'], type: ModelA)
            : value['A']) as List<ModelA> ??
        obj.A;
    obj.a = (serializer?.isSerializable(ModelA) == true
            ? serializer?.decode(value['a'], type: ModelA)
            : value['a']) as ModelA ??
        obj.a;
    return obj;
  }

  @override
  dynamic encode(ModelB value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['C'] = serializer?.isSerializable(ModelC) == true
        ? serializer?.encode(value.C,
            useTypeInfo: typeInfoKey?.isNotEmpty == true)
        : value.C;
    map['A'] = serializer?.isSerializable(ModelA) == true
        ? serializer?.encode(value.A,
            useTypeInfo: typeInfoKey?.isNotEmpty == true)
        : value.A;
    map['a'] = serializer?.isSerializable(ModelA) == true
        ? serializer?.encode(value.a,
            useTypeInfo: typeInfoKey?.isNotEmpty == true)
        : value.a;
    return map;
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
    return obj;
  }

  @override
  dynamic encode(ModelC value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    return map;
  }

  @override
  String get typeInfo => 'ModelC';
}

Map<String, TypeCodec> model_b_codecs = <String, TypeCodec>{
  'ModelB': new ModelBCodec(),
  'ModelC': new ModelCCodec(),
};
