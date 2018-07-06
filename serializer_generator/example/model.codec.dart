// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SerializerGenerator
// **************************************************************************

library model.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
import 'package:serializer/codecs.dart';
import 'model.dart';

class UserCodec extends TypeCodec<User> {
  @override
  User decode(dynamic value, {Serializer serializer}) {
    User obj = new User();
    obj.login = value['login'] as String ?? obj.login;
    return obj;
  }

  @override
  dynamic encode(User value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['login'] = value.login;
    map['toto'] = value.toto;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'User';
}

class IdCodec extends TypeCodec<Id> {
  @override
  Id decode(dynamic value, {Serializer serializer}) {
    Id obj = new Id();
    obj.id = serializer?.decode(value['_id'], type: ObjectId) ?? obj.id;
    return obj;
  }

  @override
  dynamic encode(Id value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['_id'] = serializer?.toPrimaryObject(value.id,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Id';
}

class ModelCodec extends TypeCodec<Model> {
  @override
  Model decode(dynamic value, {Serializer serializer}) {
    Model obj = new Model();
    obj.foo = value['foo'] as String ?? obj.foo;
    return obj;
  }

  @override
  dynamic encode(Model value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['foo'] = value.foo;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Model';
}

class CustomUserCodec extends TypeCodec<CustomUser> {
  @override
  CustomUser decode(dynamic value, {Serializer serializer}) {
    CustomUser obj = new CustomUser();
    obj.name = value['n'] as String ?? obj.name;
    obj.login = value['login'] as String ?? obj.login;
    obj.entity = value['entity'] as String ?? obj.entity;
    obj.id = serializer?.decode(value['_id'], type: ObjectId) ?? obj.id;
    obj.creationDate =
        serializer?.decode(value['d'], type: DateTime) ?? obj.creationDate;
    obj.test = value['test'] as String ?? obj.test;
    Map _models =
        serializer?.decode(value['models'], mapOf: const [String, Model]);
    obj.models = (_models != null ? new Map.from(_models) : null) ?? obj.models;
    return obj;
  }

  @override
  dynamic encode(CustomUser value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['n'] = value.name;
    map['login'] = value.login;
    map['toto'] = value.toto;
    map['entity'] = value.entity;
    map['_id'] = serializer?.toPrimaryObject(value.id,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    map['d'] = serializer?.toPrimaryObject(value.creationDate,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    map['test'] = value.test;
    map['models'] = serializer?.toPrimaryObject(value.models,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'CustomUser';
}

Map<String, TypeCodec<dynamic>> example_model_codecs =
    <String, TypeCodec<dynamic>>{
  'User': new UserCodec(),
  'Id': new IdCodec(),
  'Model': new ModelCodec(),
  'CustomUser': new CustomUserCodec(),
};
