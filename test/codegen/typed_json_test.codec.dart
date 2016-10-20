// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: SerializerGenerator
// Target: library
// **************************************************************************

library typed_json_test.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
import 'package:serializer/codecs.dart';
import 'typed_json_test.dart';

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedModelInt
// **************************************************************************

class TypedModelIntCodec extends TypeCodec<TypedModelInt> {
  @override
  TypedModelInt decode(dynamic value, {Serializer serializer}) {
    TypedModelInt obj = new TypedModelInt();
    obj.bar = (value['bar'] ?? obj.bar) as int;
    return obj;
  }

  @override
  dynamic encode(TypedModelInt value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['bar'] = value.bar;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelInt';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedModelA
// **************************************************************************

class TypedModelACodec extends TypeCodec<TypedModelA> {
  @override
  TypedModelA decode(dynamic value, {Serializer serializer}) {
    TypedModelA obj = new TypedModelA();
    obj.foo = (value['foo'] ?? obj.foo) as String;
    return obj;
  }

  @override
  dynamic encode(TypedModelA value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['foo'] = value.foo;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelA';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedModelB
// **************************************************************************

class TypedModelBCodec extends TypeCodec<TypedModelB> {
  @override
  TypedModelB decode(dynamic value, {Serializer serializer}) {
    TypedModelB obj = new TypedModelB();
    obj.foo = (serializer?.decode(value['foo'], type: Test) ?? obj.foo) as Test;
    obj.toto = (value['toto'] ?? obj.toto) as String;
    return obj;
  }

  @override
  dynamic encode(TypedModelB value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['foo'] = serializer?.toPrimaryObject(value.foo,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['toto'] = value.toto;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelB';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedModelC
// **************************************************************************

class TypedModelCCodec extends TypeCodec<TypedModelC> {
  @override
  TypedModelC decode(dynamic value, {Serializer serializer}) {
    TypedModelC obj = new TypedModelC();
    obj.foo = (serializer?.decode(value['foo'], type: TypedModelA) ?? obj.foo)
        as TypedModelA;
    obj.plop = (value['plop'] ?? obj.plop) as String;
    return obj;
  }

  @override
  dynamic encode(TypedModelC value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['foo'] = serializer?.toPrimaryObject(value.foo,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['plop'] = value.plop;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelC';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedModelD
// **************************************************************************

class TypedModelDCodec extends TypeCodec<TypedModelD> {
  @override
  TypedModelD decode(dynamic value, {Serializer serializer}) {
    TypedModelD obj = new TypedModelD();
    obj.tests = (serializer?.decode(value['tests'], type: TypedModelA) ??
        obj.tests) as List<TypedModelA>;
    return obj;
  }

  @override
  dynamic encode(TypedModelD value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['tests'] = serializer?.toPrimaryObject(value.tests,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelD';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedModelE
// **************************************************************************

class TypedModelECodec extends TypeCodec<TypedModelE> {
  @override
  TypedModelE decode(dynamic value, {Serializer serializer}) {
    TypedModelE obj = new TypedModelE();
    obj.tests = (serializer?.decode(value['tests'], type: String) ?? obj.tests)
        as List<String>;
    return obj;
  }

  @override
  dynamic encode(TypedModelE value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['tests'] = value.tests;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelE';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedModelRenamed
// **************************************************************************

class TypedModelRenamedCodec extends TypeCodec<TypedModelRenamed> {
  @override
  TypedModelRenamed decode(dynamic value, {Serializer serializer}) {
    TypedModelRenamed obj = new TypedModelRenamed();
    obj.tests = (serializer?.decode(value['tests'], type: String) ?? obj.tests)
        as List<String>;
    obj.original = (value['new'] ?? obj.original) as String;
    return obj;
  }

  @override
  dynamic encode(TypedModelRenamed value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['tests'] = value.tests;
    map['new'] = value.original;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelRenamed';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedWithIgnore
// **************************************************************************

class TypedWithIgnoreCodec extends TypeCodec<TypedWithIgnore> {
  @override
  TypedWithIgnore decode(dynamic value, {Serializer serializer}) {
    TypedWithIgnore obj = new TypedWithIgnore();
    obj.a = (value['a'] ?? obj.a) as String;
    obj.b = (value['b'] ?? obj.b) as String;
    return obj;
  }

  @override
  dynamic encode(TypedWithIgnore value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['a'] = value.a;
    map['b'] = value.b;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedWithIgnore';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedDate
// **************************************************************************

class TypedDateCodec extends TypeCodec<TypedDate> {
  @override
  TypedDate decode(dynamic value, {Serializer serializer}) {
    TypedDate obj = new TypedDate();
    obj.date = (serializer?.decode(value['date'], type: DateTime) ?? obj.date)
        as DateTime;
    return obj;
  }

  @override
  dynamic encode(TypedDate value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['date'] = serializer?.toPrimaryObject(value.date,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['serializer'] = serializer?.toPrimaryObject(value.serializer,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedDate';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedTestMaxSuperClass
// **************************************************************************

class TypedTestMaxSuperClassCodec extends TypeCodec<TypedTestMaxSuperClass> {
  @override
  TypedTestMaxSuperClass decode(dynamic value, {Serializer serializer}) {
    TypedTestMaxSuperClass obj = new TypedTestMaxSuperClass();
    obj.serialize = (value['serialize'] ?? obj.serialize) as String;
    return obj;
  }

  @override
  dynamic encode(TypedTestMaxSuperClass value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['serialize'] = value.serialize;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedTestMaxSuperClass';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TypedComplex
// **************************************************************************

class TypedComplexCodec extends TypeCodec<TypedComplex> {
  @override
  TypedComplex decode(dynamic value, {Serializer serializer}) {
    TypedComplex obj = new TypedComplex();
    obj.nums =
        (serializer?.decode(value['nums'], type: num) ?? obj.nums) as List<num>;
    obj.strings = (serializer?.decode(value['strings'], type: String) ??
        obj.strings) as List<String>;
    obj.bools = (serializer?.decode(value['bools'], type: bool) ?? obj.bools)
        as List<bool>;
    obj.ints =
        (serializer?.decode(value['ints'], type: int) ?? obj.ints) as List<int>;
    obj.doubles = (serializer?.decode(value['doubles'], type: double) ??
        obj.doubles) as List<double>;
    obj.dates = (serializer?.decode(value['dates'], type: DateTime) ??
        obj.dates) as List<DateTime>;
    obj.ignores =
        (serializer?.decode(value['ignores'], type: TypedWithIgnore) ??
            obj.ignores) as List<TypedWithIgnore>;
    obj.numSet = (serializer?.decode(value['numSet'], type: num) ?? obj.numSet)
        as Map<String, num>;
    obj.stringSet = (serializer?.decode(value['stringSet'], type: String) ??
        obj.stringSet) as Map<String, String>;
    obj.boolSet = (serializer?.decode(value['boolSet'], type: bool) ??
        obj.boolSet) as Map<String, bool>;
    obj.intSet = (serializer?.decode(value['intSet'], type: int) ?? obj.intSet)
        as Map<String, int>;
    obj.doubleSet = (serializer?.decode(value['doubleSet'], type: double) ??
        obj.doubleSet) as Map<String, double>;
    obj.dateSet = (serializer?.decode(value['dateSet'], type: DateTime) ??
        obj.dateSet) as Map<String, DateTime>;
    obj.ignoreSet =
        (serializer?.decode(value['ignoreSet'], type: TypedWithIgnore) ??
            obj.ignoreSet) as Map<String, TypedWithIgnore>;
    obj.listInnerMap = (serializer?.decode(value['listInnerMap'], type: List) ??
        obj.listInnerMap) as Map<String, List<dynamic>>;
    return obj;
  }

  @override
  dynamic encode(TypedComplex value,
      {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['nums'] = value.nums;
    map['strings'] = value.strings;
    map['bools'] = value.bools;
    map['ints'] = value.ints;
    map['doubles'] = value.doubles;
    map['dates'] = serializer?.toPrimaryObject(value.dates,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['ignores'] = serializer?.toPrimaryObject(value.ignores,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['numSet'] = value.numSet;
    map['stringSet'] = value.stringSet;
    map['boolSet'] = value.boolSet;
    map['intSet'] = value.intSet;
    map['doubleSet'] = value.doubleSet;
    map['dateSet'] = serializer?.toPrimaryObject(value.dateSet,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['ignoreSet'] = serializer?.toPrimaryObject(value.ignoreSet,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    map['listInnerMap'] = serializer?.toPrimaryObject(value.listInnerMap,
        useTypeInfo: typeInfoKey?.isNotEmpty == true);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedComplex';
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class Mixin
// **************************************************************************

class MixinCodec extends TypeCodec<Mixin> {
  @override
  Mixin decode(dynamic value, {Serializer serializer}) {
    Mixin obj = new Mixin();
    obj.m1 = (value['m1'] ?? obj.m1) as String;
    obj.m2 = (value['m2'] ?? obj.m2) as String;
    obj.a = (value['a'] ?? obj.a) as String;
    obj.b = (value['b'] ?? obj.b) as String;
    return obj;
  }

  @override
  dynamic encode(Mixin value, {Serializer serializer, String typeInfoKey}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (typeInfoKey != null) {
      map[typeInfoKey] = typeInfo;
    }
    map['m1'] = value.m1;
    map['m2'] = value.m2;
    map['a'] = value.a;
    map['b'] = value.b;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'Mixin';
}

Map<String, TypeCodec<dynamic>> test_codegen_typed_json_test_codecs =
    <String, TypeCodec<dynamic>>{
  'TypedModelInt': new TypedModelIntCodec(),
  'TypedModelA': new TypedModelACodec(),
  'TypedModelB': new TypedModelBCodec(),
  'TypedModelC': new TypedModelCCodec(),
  'TypedModelD': new TypedModelDCodec(),
  'TypedModelE': new TypedModelECodec(),
  'TypedModelRenamed': new TypedModelRenamedCodec(),
  'TypedWithIgnore': new TypedWithIgnoreCodec(),
  'TypedDate': new TypedDateCodec(),
  'TypedTestMaxSuperClass': new TypedTestMaxSuperClassCodec(),
  'TypedComplex': new TypedComplexCodec(),
  'Mixin': new MixinCodec(),
};
