// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: SerializerGenerator
// Target: library
// **************************************************************************

library models_test.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
import 'package:serializer/codecs.dart';
import 'models_test.dart';

// **************************************************************************
// Generator: SerializerGenerator
// Target: class M1
// **************************************************************************

class M1Codec extends TypeCodec<M1> {
  @override
  M1 decode(dynamic value, {Serializer serializer}) {
    M1 obj = new M1();
    obj.m1 = (value['m1'] ?? obj.m1) as String;
    return obj;
  }

  @override
  dynamic encode(M1 value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['m1'] = value.m1 as String;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'M1';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class M2
// **************************************************************************

class M2Codec extends TypeCodec<M2> {
  @override
  M2 decode(dynamic value, {Serializer serializer}) {
    M2 obj = new M2();
    obj.m2 = (value['m2'] ?? obj.m2) as String;
    return obj;
  }

  @override
  dynamic encode(M2 value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['m2'] = value.m2 as String;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'M2';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class Employee
// **************************************************************************

class EmployeeCodec extends TypeCodec<Employee> {
  @override
  Employee decode(dynamic value, {Serializer serializer}) {
    Employee obj = new Employee();
    obj.id = (value['id'] ?? obj.id).toInt();
    obj.name = (value['name'] ?? obj.name) as String;
    obj.address = (serializer?.decode(value['address'], type: Address) ??
        obj.address) as Address;
    obj.manager = (serializer?.decode(value['manager'], type: Employee) ??
        obj.manager) as Employee;
    return obj;
  }

  @override
  dynamic encode(Employee value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['id'] = value.id.toInt();
    map['name'] = value.name as String;
    map['address'] = serializer?.toPrimaryObject(value.address,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    map['manager'] = serializer?.toPrimaryObject(value.manager,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Employee';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class Address
// **************************************************************************

class AddressCodec extends TypeCodec<Address> {
  @override
  Address decode(dynamic value, {Serializer serializer}) {
    Address obj = new Address();
    obj.id = (value['id'] ?? obj.id).toInt();
    obj.location = (value['location'] ?? obj.location) as String;
    obj.owner = (serializer?.decode(value['owner'], type: Employee) ??
        obj.owner) as Employee;
    return obj;
  }

  @override
  dynamic encode(Address value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['id'] = value.id.toInt();
    map['location'] = value.location as String;
    map['owner'] = serializer?.toPrimaryObject(value.owner,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Address';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class WithStaticConst
// **************************************************************************

class WithStaticConstCodec extends TypeCodec<WithStaticConst> {
  @override
  WithStaticConst decode(dynamic value, {Serializer serializer}) {
    WithStaticConst obj = new WithStaticConst();
    obj.other = (value['other'] ?? obj.other) as String;
    return obj;
  }

  @override
  dynamic encode(WithStaticConst value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['other'] = value.other as String;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'WithStaticConst';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class WithStatic
// **************************************************************************

class WithStaticCodec extends TypeCodec<WithStatic> {
  @override
  WithStatic decode(dynamic value, {Serializer serializer}) {
    WithStatic obj = new WithStatic();
    obj.other = (value['other'] ?? obj.other) as String;
    return obj;
  }

  @override
  dynamic encode(WithStatic value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['other'] = value.other as String;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'WithStatic';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class Pet
// **************************************************************************

class PetCodec extends TypeCodec<Pet> {
  @override
  Pet decode(dynamic value, {Serializer serializer}) {
    Pet obj = new Pet();
    obj.name = (value['name'] ?? obj.name) as String;
    obj.animal = (serializer?.decode(value['animal'], useTypeInfo: true) ??
        obj.animal) as dynamic;
    return obj;
  }

  @override
  dynamic encode(Pet value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['name'] = value.name as String;
    map['animal'] = serializer?.toPrimaryObject(value.animal,
        useTypeInfo: useTypeInfo, withTypeInfo: true);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Pet';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class Dog
// **************************************************************************

class DogCodec extends TypeCodec<Dog> {
  @override
  Dog decode(dynamic value, {Serializer serializer}) {
    Dog obj = new Dog();
    obj.name = (value['name'] ?? obj.name) as String;
    obj.bark = (value['bark'] ?? obj.bark) as bool;
    return obj;
  }

  @override
  dynamic encode(Dog value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['name'] = value.name as String;
    map['bark'] = value.bark as bool;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Dog';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class Cat
// **************************************************************************

class CatCodec extends TypeCodec<Cat> {
  @override
  Cat decode(dynamic value, {Serializer serializer}) {
    Cat obj = new Cat();
    obj.name = (value['name'] ?? obj.name) as String;
    obj.mew = (value['mew'] ?? obj.mew) as bool;
    return obj;
  }

  @override
  dynamic encode(Cat value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['name'] = value.name as String;
    map['mew'] = value.mew as bool;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Cat';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class PetWithTypeInfo
// **************************************************************************

class PetWithTypeInfoCodec extends TypeCodec<PetWithTypeInfo> {
  @override
  PetWithTypeInfo decode(dynamic value, {Serializer serializer}) {
    PetWithTypeInfo obj = new PetWithTypeInfo();
    obj.name = (value['name'] ?? obj.name) as String;
    obj.animal = (serializer?.decode(value['animal'], useTypeInfo: true) ??
        obj.animal) as Animal;
    return obj;
  }

  @override
  dynamic encode(PetWithTypeInfo value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['name'] = value.name as String;
    map['animal'] = serializer?.toPrimaryObject(value.animal,
        useTypeInfo: useTypeInfo, withTypeInfo: true);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'PetWithTypeInfo';
}

Map<String, TypeCodec<dynamic>> test_codegen_models_test_codecs =
    <String, TypeCodec<dynamic>>{
  'M1': new M1Codec(),
  'M2': new M2Codec(),
  'Employee': new EmployeeCodec(),
  'Address': new AddressCodec(),
  'WithStaticConst': new WithStaticConstCodec(),
  'WithStatic': new WithStaticCodec(),
  'Pet': new PetCodec(),
  'Dog': new DogCodec(),
  'Cat': new CatCodec(),
  'PetWithTypeInfo': new PetWithTypeInfoCodec(),
};
