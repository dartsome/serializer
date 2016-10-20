// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: SerializerGenerator
// Target: library
// **************************************************************************

library model.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
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
    obj.id = (serializer?.decode(value['_id'], type: ObjectId) ?? obj.id)
        as ObjectId;
    obj.name = (value['name'] ?? obj.name) as String;
    obj.plop = (value['plop'] ?? obj.plop) as String;
    obj.age = (value['age'] ?? obj.age) as num;
    return obj;
  }

  @override
  dynamic encode(ModelA value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['_id'] = serializer?.toPrimaryObject(value.id,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['name'] = value.name;
    map['plop'] = value.plop;
    map['age'] = value.age;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'ModelA';
}

Map<String, TypeCodec<dynamic>> example_model_codecs =
    <String, TypeCodec<dynamic>>{
  'ModelA': new ModelACodec(),
};
