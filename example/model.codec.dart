// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: SerializerGenerator
// Target: library
// **************************************************************************

library model.codec;

import 'package:serializer/core.dart' show Serializer;
import 'package:serializer/codecs.dart';
import 'model.dart';

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelA
// **************************************************************************

class ModelACodec extends TypeCodec<ModelA> {
  ModelA decode(dynamic value, {Serializer serializer}) {
    ModelA obj = new ModelA();
    obj.id = (serializer?.isSerializable(ObjectId) == true
            ? serializer?.decode(value['_id'], type: ObjectId)
            : value['_id']) ??
        obj.id;
    obj.name = (serializer?.isSerializable(String) == true
            ? serializer?.decode(value['name'], type: String)
            : value['name']) ??
        obj.name;
    obj.plop = (serializer?.isSerializable(String) == true
            ? serializer?.decode(value['plop'], type: String)
            : value['plop']) ??
        obj.plop;
    obj.age = (serializer?.isSerializable(num) == true
            ? serializer?.decode(value['age'], type: num)
            : value['age']) ??
        obj.age;
    return obj;
  }

  dynamic encode(ModelA value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['_id'] = serializer?.isSerializable(ObjectId) == true
        ? serializer?.encode(value.id,
            useTypeInfo: typeInfoKey?.isNotEmpty == true)
        : value.id;
    map['name'] = serializer?.isSerializable(String) == true
        ? serializer?.encode(value.name,
            useTypeInfo: typeInfoKey?.isNotEmpty == true)
        : value.name;
    map['plop'] = serializer?.isSerializable(String) == true
        ? serializer?.encode(value.plop,
            useTypeInfo: typeInfoKey?.isNotEmpty == true)
        : value.plop;
    map['age'] = serializer?.isSerializable(num) == true
        ? serializer?.encode(value.age,
            useTypeInfo: typeInfoKey?.isNotEmpty == true)
        : value.age;
    return map;
  }

  String get typeInfo => 'ModelA';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelB
// **************************************************************************

class ModelBCodec extends TypeCodec<ModelB> {
  ModelB decode(dynamic value, {Serializer serializer}) {
    ModelB obj = new ModelB();
    obj.a = (serializer?.isSerializable(ModelA) == true
            ? serializer?.decode(value['a'], type: ModelA)
            : value['a']) ??
        obj.a;
    return obj;
  }

  dynamic encode(ModelB value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['a'] = serializer?.isSerializable(ModelA) == true
        ? serializer?.encode(value.a,
            useTypeInfo: typeInfoKey?.isNotEmpty == true)
        : value.a;
    return map;
  }

  String get typeInfo => 'ModelB';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: abstract class ModelD
// **************************************************************************

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelC
// **************************************************************************

class ModelCCodec extends TypeCodec<ModelC> {
  ModelC decode(dynamic value, {Serializer serializer}) {
    ModelC obj = new ModelC();
    return obj;
  }

  dynamic encode(ModelC value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    return map;
  }

  String get typeInfo => 'ModelC';
}

Map<String, TypeCodec> modelCodecs = <String, TypeCodec>{
  'ModelA': new ModelACodec(),
  'ModelB': new ModelBCodec(),
  'ModelC': new ModelCCodec(),
};
