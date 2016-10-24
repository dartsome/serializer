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
// Target: class User
// **************************************************************************

class UserCodec extends TypeCodec<User> {
  @override
  User decode(dynamic value, {Serializer serializer}) {
    User obj = new User();
    obj.login = (value['login'] ?? obj.login) as String;
    return obj;
  }

  @override
  dynamic encode(User value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['login'] = value.login;
    map['toto'] = value.toto;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'User';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class Id
// **************************************************************************

class IdCodec extends TypeCodec<Id> {
  @override
  Id decode(dynamic value, {Serializer serializer}) {
    Id obj = new Id();
    obj.id = (serializer?.decode(value['_id'], type: ObjectId) ?? obj.id)
        as ObjectId;
    return obj;
  }

  @override
  dynamic encode(Id value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['_id'] = serializer?.toPrimaryObject(value.id,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Id';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class CustomUser
// **************************************************************************

class CustomUserCodec extends TypeCodec<CustomUser> {
  @override
  CustomUser decode(dynamic value, {Serializer serializer}) {
    CustomUser obj = new CustomUser();
    obj.login = (value['login'] ?? obj.login) as String;
    obj.toto = (value['toto'] ?? obj.toto) as String;
    obj.name = (value['n'] ?? obj.name) as String;
    obj.entity = (value['entity'] ?? obj.entity) as String;
    obj.id = (serializer?.decode(value['_id'], type: ObjectId) ?? obj.id)
        as ObjectId;
    obj.titi = (value['titi'] ?? obj.titi) as String;
    obj.creationDate = (serializer?.decode(value['d'], type: DateTime) ??
        obj.creationDate) as DateTime;
    obj.test = (value['test'] ?? obj.test) as String;
    return obj;
  }

  @override
  dynamic encode(CustomUser value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['login'] = value.login;
    map['toto'] = value.toto;
    map['n'] = value.name;
    map['entity'] = value.entity;
    map['_id'] = serializer?.toPrimaryObject(value.id,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['titi'] = value.titi;
    map['d'] = serializer?.toPrimaryObject(value.creationDate,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['test'] = value.test;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'CustomUser';
}

Map<String, TypeCodec<dynamic>> example_model_codecs =
    <String, TypeCodec<dynamic>>{
  'User': new UserCodec(),
  'Id': new IdCodec(),
  'CustomUser': new CustomUserCodec(),
};
