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
  @override
  ModelA decode(dynamic value, {Serializer serializer}) {
    ModelA obj = new ModelA();
    obj.id = (serializer?.isSerializable(ObjectId) == true
            ? serializer?.decode(value['_id'], type: ObjectId)
            : value['_id']) as ObjectId ??
        obj.id;
    obj.name = (serializer?.isSerializable(String) == true
            ? serializer?.decode(value['name'], type: String)
            : value['name']) as String ??
        obj.name;
    obj.plop = (serializer?.isSerializable(String) == true
            ? serializer?.decode(value['plop'], type: String)
            : value['plop']) as String ??
        obj.plop;
    obj.age = (serializer?.isSerializable(num) == true
            ? serializer?.decode(value['age'], type: num)
            : value['age']) as num ??
        obj.age;
    return obj;
  }

  @override
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

  @override
  String get typeInfo => 'ModelA';
}

Map<String, TypeCodec> model_codecs = <String, TypeCodec>{
  'ModelA': new ModelACodec(),
};
