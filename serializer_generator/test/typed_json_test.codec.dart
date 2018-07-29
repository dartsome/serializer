// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SerializerGenerator
// **************************************************************************

library typed_json_test.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
import 'package:serializer/codecs.dart';
import 'typed_json_test.dart';

class TypedModelIntCodec extends TypeCodec<TypedModelInt> {
  @override
  TypedModelInt decode(dynamic value, {Serializer serializer}) {
    TypedModelInt obj = new TypedModelInt();
    obj.bar = (value['bar'] as num)?.toInt() ?? obj.bar;
    return obj;
  }

  @override
  dynamic encode(TypedModelInt value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['bar'] = value.bar?.toInt();
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelInt';
}

class TypedModelACodec extends TypeCodec<TypedModelA> {
  @override
  TypedModelA decode(dynamic value, {Serializer serializer}) {
    TypedModelA obj = new TypedModelA();
    obj.foo = value['foo'] as String ?? obj.foo;
    return obj;
  }

  @override
  dynamic encode(TypedModelA value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['foo'] = value.foo;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelA';
}

class TypedModelBCodec extends TypeCodec<TypedModelB> {
  @override
  TypedModelB decode(dynamic value, {Serializer serializer}) {
    TypedModelB obj = new TypedModelB();
    obj.foo = serializer?.decode(value['foo'], type: Test) as Test ?? obj.foo;
    obj.toto = value['toto'] as String ?? obj.toto;
    return obj;
  }

  @override
  dynamic encode(TypedModelB value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['foo'] = serializer?.toPrimaryObject(value.foo,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    map['toto'] = value.toto;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelB';
}

class TypedModelCCodec extends TypeCodec<TypedModelC> {
  @override
  TypedModelC decode(dynamic value, {Serializer serializer}) {
    TypedModelC obj = new TypedModelC();
    obj.foo =
        serializer?.decode(value['foo'], type: TypedModelA) as TypedModelA ??
            obj.foo;
    obj.plop = value['plop'] as String ?? obj.plop;
    return obj;
  }

  @override
  dynamic encode(TypedModelC value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['foo'] = serializer?.toPrimaryObject(value.foo,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    map['plop'] = value.plop;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelC';
}

class TypedModelDCodec extends TypeCodec<TypedModelD> {
  @override
  TypedModelD decode(dynamic value, {Serializer serializer}) {
    TypedModelD obj = new TypedModelD();
    List _tests = serializer?.decode(value['tests'], type: TypedModelA);
    obj.tests = (_tests != null ? new List<TypedModelA>.from(_tests) : null) ??
        obj.tests;
    return obj;
  }

  @override
  dynamic encode(TypedModelD value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['tests'] = serializer?.toPrimaryObject(value.tests,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelD';
}

class TypedModelECodec extends TypeCodec<TypedModelE> {
  @override
  TypedModelE decode(dynamic value, {Serializer serializer}) {
    TypedModelE obj = new TypedModelE();
    List _tests = serializer?.decode(value['tests'], type: String);
    obj.tests =
        (_tests != null ? new List<String>.from(_tests) : null) ?? obj.tests;
    return obj;
  }

  @override
  dynamic encode(TypedModelE value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['tests'] = value.tests;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelE';
}

class TypedModelRenamedCodec extends TypeCodec<TypedModelRenamed> {
  @override
  TypedModelRenamed decode(dynamic value, {Serializer serializer}) {
    TypedModelRenamed obj = new TypedModelRenamed();
    List _tests = serializer?.decode(value['tests'], type: String);
    obj.tests =
        (_tests != null ? new List<String>.from(_tests) : null) ?? obj.tests;
    obj.original = value['new'] as String ?? obj.original;
    return obj;
  }

  @override
  dynamic encode(TypedModelRenamed value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['tests'] = value.tests;
    map['new'] = value.original;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedModelRenamed';
}

class TypedWithIgnoreCodec extends TypeCodec<TypedWithIgnore> {
  @override
  TypedWithIgnore decode(dynamic value, {Serializer serializer}) {
    TypedWithIgnore obj = new TypedWithIgnore();
    obj.a = value['a'] as String ?? obj.a;
    obj.b = value['b'] as String ?? obj.b;
    return obj;
  }

  @override
  dynamic encode(TypedWithIgnore value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['a'] = value.a;
    map['b'] = value.b;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedWithIgnore';
}

class TypedDateCodec extends TypeCodec<TypedDate> {
  @override
  TypedDate decode(dynamic value, {Serializer serializer}) {
    TypedDate obj = new TypedDate();
    obj.date = serializer?.decode(value['date'], type: DateTime) as DateTime ??
        obj.date;
    return obj;
  }

  @override
  dynamic encode(TypedDate value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['date'] = serializer?.toPrimaryObject(value.date,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedDate';
}

class TypedTestMaxSuperClassCodec extends TypeCodec<TypedTestMaxSuperClass> {
  @override
  TypedTestMaxSuperClass decode(dynamic value, {Serializer serializer}) {
    TypedTestMaxSuperClass obj = new TypedTestMaxSuperClass();
    obj.foo = value['foo'] as String ?? obj.foo;
    obj.serialize = value['serialize'] as String ?? obj.serialize;
    return obj;
  }

  @override
  dynamic encode(TypedTestMaxSuperClass value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['foo'] = value.foo;
    map['serialize'] = value.serialize;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedTestMaxSuperClass';
}

class TypedComplexCodec extends TypeCodec<TypedComplex> {
  @override
  TypedComplex decode(dynamic value, {Serializer serializer}) {
    TypedComplex obj = new TypedComplex();
    List _nums = serializer?.decode(value['nums'], type: num);
    obj.nums = (_nums != null ? new List<num>.from(_nums) : null) ?? obj.nums;
    List _strings = serializer?.decode(value['strings'], type: String);
    obj.strings = (_strings != null ? new List<String>.from(_strings) : null) ??
        obj.strings;
    List _bools = serializer?.decode(value['bools'], type: bool);
    obj.bools =
        (_bools != null ? new List<bool>.from(_bools) : null) ?? obj.bools;
    List _ints = serializer?.decode(value['ints'], type: int);
    obj.ints = (_ints != null
            ? new List<int>.from(_ints.map((item) => (item as num)?.toInt()))
            : null) ??
        obj.ints;
    List _doubles = serializer?.decode(value['doubles'], type: double);
    obj.doubles = (_doubles != null
            ? new List<double>.from(
                _doubles.map((item) => (item as num)?.toDouble()))
            : null) ??
        obj.doubles;
    List _dates = serializer?.decode(value['dates'], type: DateTime);
    obj.dates =
        (_dates != null ? new List<DateTime>.from(_dates) : null) ?? obj.dates;
    List _ignores = serializer?.decode(value['ignores'], type: TypedWithIgnore);
    obj.ignores =
        (_ignores != null ? new List<TypedWithIgnore>.from(_ignores) : null) ??
            obj.ignores;
    Map _numSet =
        serializer?.decode(value['numSet'], mapOf: const [String, num]);
    obj.numSet = (_numSet != null ? new Map.from(_numSet) : null) ?? obj.numSet;
    Map _stringSet =
        serializer?.decode(value['stringSet'], mapOf: const [String, String]);
    obj.stringSet =
        (_stringSet != null ? new Map.from(_stringSet) : null) ?? obj.stringSet;
    Map _boolSet =
        serializer?.decode(value['boolSet'], mapOf: const [String, bool]);
    obj.boolSet =
        (_boolSet != null ? new Map.from(_boolSet) : null) ?? obj.boolSet;
    Map _intSet =
        serializer?.decode(value['intSet'], mapOf: const [String, int]);
    obj.intSet = (_intSet != null
            ? new Map.fromIterable(_intSet.keys,
                key: (key) => key as String,
                value: (key) => (_intSet[key] as num)?.toInt())
            : null) ??
        obj.intSet;
    Map _doubleSet =
        serializer?.decode(value['doubleSet'], mapOf: const [String, double]);
    obj.doubleSet = (_doubleSet != null
            ? new Map.fromIterable(_doubleSet.keys,
                key: (key) => key as String,
                value: (key) => (_doubleSet[key] as num)?.toDouble())
            : null) ??
        obj.doubleSet;
    Map _dateSet =
        serializer?.decode(value['dateSet'], mapOf: const [String, DateTime]);
    obj.dateSet =
        (_dateSet != null ? new Map.from(_dateSet) : null) ?? obj.dateSet;
    Map _ignoreSet = serializer
        ?.decode(value['ignoreSet'], mapOf: const [String, TypedWithIgnore]);
    obj.ignoreSet =
        (_ignoreSet != null ? new Map.from(_ignoreSet) : null) ?? obj.ignoreSet;
    Map _listInnerMap =
        serializer?.decode(value['listInnerMap'], mapOf: const [String, List]);
    obj.listInnerMap =
        (_listInnerMap != null ? new Map.from(_listInnerMap) : null) ??
            obj.listInnerMap;
    return obj;
  }

  @override
  dynamic encode(TypedComplex value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['nums'] = value.nums;
    map['strings'] = value.strings;
    map['bools'] = value.bools;
    map['ints'] = value.ints;
    map['doubles'] = value.doubles;
    map['dates'] = serializer?.toPrimaryObject(value.dates,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    map['ignores'] = serializer?.toPrimaryObject(value.ignores,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    map['numSet'] = value.numSet;
    map['stringSet'] = value.stringSet;
    map['boolSet'] = value.boolSet;
    map['intSet'] = value.intSet;
    map['doubleSet'] = value.doubleSet;
    map['dateSet'] = serializer?.toPrimaryObject(value.dateSet,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    map['ignoreSet'] = serializer?.toPrimaryObject(value.ignoreSet,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    map['listInnerMap'] = serializer?.toPrimaryObject(value.listInnerMap,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'TypedComplex';
}

class MixinCodec extends TypeCodec<Mixin> {
  @override
  Mixin decode(dynamic value, {Serializer serializer}) {
    Mixin obj = new Mixin();
    obj.m1 = value['m1'] as String ?? obj.m1;
    obj.m2 = value['m2'] as String ?? obj.m2;
    obj.a = value['a'] as String ?? obj.a;
    obj.b = value['b'] as String ?? obj.b;
    return obj;
  }

  @override
  dynamic encode(Mixin value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
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

Map<String, TypeCodec<dynamic>> test_typed_json_test_codecs =
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
