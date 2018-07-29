// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SerializerGenerator
// **************************************************************************

library models.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
import 'package:serializer/codecs.dart';
import 'models.dart';

class M1Codec extends TypeCodec<M1> {
  @override
  M1 decode(dynamic value, {Serializer serializer}) {
    M1 obj = new M1();
    obj.m1 = value['m1'] as String ?? obj.m1;
    return obj;
  }

  @override
  dynamic encode(M1 value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['m1'] = value.m1;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'M1';
}

class M2Codec extends TypeCodec<M2> {
  @override
  M2 decode(dynamic value, {Serializer serializer}) {
    M2 obj = new M2();
    obj.m2 = value['m2'] as String ?? obj.m2;
    return obj;
  }

  @override
  dynamic encode(M2 value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['m2'] = value.m2;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'M2';
}

class EmployeeCodec extends TypeCodec<Employee> {
  @override
  Employee decode(dynamic value, {Serializer serializer}) {
    Employee obj = new Employee();
    obj.id = (value['id'] as num)?.toInt() ?? obj.id;
    obj.name = value['name'] as String ?? obj.name;
    obj.address =
        serializer?.decode(value['address'], type: Address) as Address ??
            obj.address;
    obj.manager =
        serializer?.decode(value['manager'], type: Employee) as Employee ??
            obj.manager;
    return obj;
  }

  @override
  dynamic encode(Employee value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['id'] = value.id?.toInt();
    map['name'] = value.name;
    map['address'] = serializer?.toPrimaryObject(value.address,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    map['manager'] = serializer?.toPrimaryObject(value.manager,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Employee';
}

class AddressCodec extends TypeCodec<Address> {
  @override
  Address decode(dynamic value, {Serializer serializer}) {
    Address obj = new Address();
    obj.id = (value['id'] as num)?.toInt() ?? obj.id;
    obj.location = value['location'] as String ?? obj.location;
    obj.owner =
        serializer?.decode(value['owner'], type: Employee) as Employee ??
            obj.owner;
    return obj;
  }

  @override
  dynamic encode(Address value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['id'] = value.id?.toInt();
    map['location'] = value.location;
    map['owner'] = serializer?.toPrimaryObject(value.owner,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Address';
}

class WithStaticConstCodec extends TypeCodec<WithStaticConst> {
  @override
  WithStaticConst decode(dynamic value, {Serializer serializer}) {
    WithStaticConst obj = new WithStaticConst();
    obj.other = value['other'] as String ?? obj.other;
    return obj;
  }

  @override
  dynamic encode(WithStaticConst value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['other'] = value.other;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'WithStaticConst';
}

class WithStaticCodec extends TypeCodec<WithStatic> {
  @override
  WithStatic decode(dynamic value, {Serializer serializer}) {
    WithStatic obj = new WithStatic();
    obj.other = value['other'] as String ?? obj.other;
    return obj;
  }

  @override
  dynamic encode(WithStatic value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['other'] = value.other;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'WithStatic';
}

class PetCodec extends TypeCodec<Pet> {
  @override
  Pet decode(dynamic value, {Serializer serializer}) {
    Pet obj = new Pet();
    obj.name = value['name'] as String ?? obj.name;
    obj.animal =
        serializer?.decode(value['animal'], useTypeInfo: true) as dynamic ??
            obj.animal;
    return obj;
  }

  @override
  dynamic encode(Pet value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['name'] = value.name;
    map['animal'] = serializer?.toPrimaryObject(value.animal,
        useTypeInfo: useTypeInfo, withTypeInfo: true);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Pet';
}

class DogCodec extends TypeCodec<Dog> {
  @override
  Dog decode(dynamic value, {Serializer serializer}) {
    Dog obj = new Dog();
    obj.name = value['name'] as String ?? obj.name;
    obj.bark = value['bark'] as bool ?? obj.bark;
    return obj;
  }

  @override
  dynamic encode(Dog value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['name'] = value.name;
    map['bark'] = value.bark;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Dog';
}

class CatCodec extends TypeCodec<Cat> {
  @override
  Cat decode(dynamic value, {Serializer serializer}) {
    Cat obj = new Cat();
    obj.name = value['name'] as String ?? obj.name;
    obj.mew = value['mew'] as bool ?? obj.mew;
    return obj;
  }

  @override
  dynamic encode(Cat value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['name'] = value.name;
    map['mew'] = value.mew;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Cat';
}

class PetWithTypeInfoCodec extends TypeCodec<PetWithTypeInfo> {
  @override
  PetWithTypeInfo decode(dynamic value, {Serializer serializer}) {
    PetWithTypeInfo obj = new PetWithTypeInfo();
    obj.name = value['name'] as String ?? obj.name;
    obj.animal =
        serializer?.decode(value['animal'], useTypeInfo: true) as Animal ??
            obj.animal;
    return obj;
  }

  @override
  dynamic encode(PetWithTypeInfo value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['name'] = value.name;
    map['animal'] = serializer?.toPrimaryObject(value.animal,
        useTypeInfo: useTypeInfo, withTypeInfo: true);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'PetWithTypeInfo';
}

Map<String, TypeCodec<dynamic>> test_models_codecs =
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
