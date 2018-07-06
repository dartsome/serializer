// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// SerializerGenerator
// **************************************************************************

library json_test.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
import 'package:serializer/codecs.dart';
import 'json_test.dart';

class ModelIntCodec extends TypeCodec<ModelInt> {
  @override
  ModelInt decode(dynamic value, {Serializer serializer}) {
    ModelInt obj = new ModelInt();
    obj.bar = value['bar']?.toInt() ?? obj.bar;
    return obj;
  }

  @override
  dynamic encode(ModelInt value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['bar'] = value.bar?.toInt();
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'ModelInt';
}

class ModelDoubleCodec extends TypeCodec<ModelDouble> {
  @override
  ModelDouble decode(dynamic value, {Serializer serializer}) {
    ModelDouble obj = new ModelDouble();
    obj.bar = value['bar']?.toDouble() ?? obj.bar;
    return obj;
  }

  @override
  dynamic encode(ModelDouble value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['bar'] = value.bar?.toDouble();
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'ModelDouble';
}

class ModelACodec extends TypeCodec<ModelA> {
  @override
  ModelA decode(dynamic value, {Serializer serializer}) {
    ModelA obj = new ModelA();
    obj.foo = value['foo'] as String ?? obj.foo;
    return obj;
  }

  @override
  dynamic encode(ModelA value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['foo'] = value.foo;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'ModelA';
}

class ModelBCodec extends TypeCodec<ModelB> {
  @override
  ModelB decode(dynamic value, {Serializer serializer}) {
    ModelB obj = new ModelB();
    obj.foo = serializer?.decode(value['foo'], type: Test) ?? obj.foo;
    obj.toto = value['toto'] as String ?? obj.toto;
    return obj;
  }

  @override
  dynamic encode(ModelB value,
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
  String get typeInfo => 'ModelB';
}

class ModelCCodec extends TypeCodec<ModelC> {
  @override
  ModelC decode(dynamic value, {Serializer serializer}) {
    ModelC obj = new ModelC();
    obj.foo = serializer?.decode(value['foo'], type: ModelA) ?? obj.foo;
    obj.plop = value['plop'] as String ?? obj.plop;
    return obj;
  }

  @override
  dynamic encode(ModelC value,
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
  String get typeInfo => 'ModelC';
}

class ModelDCodec extends TypeCodec<ModelD> {
  @override
  ModelD decode(dynamic value, {Serializer serializer}) {
    ModelD obj = new ModelD();
    List _tests = serializer?.decode(value['tests'], type: ModelA);
    obj.tests =
        (_tests != null ? new List<ModelA>.from(_tests) : null) ?? obj.tests;
    return obj;
  }

  @override
  dynamic encode(ModelD value,
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
  String get typeInfo => 'ModelD';
}

class ModelECodec extends TypeCodec<ModelE> {
  @override
  ModelE decode(dynamic value, {Serializer serializer}) {
    ModelE obj = new ModelE();
    List _tests = serializer?.decode(value['tests'], type: String);
    obj.tests =
        (_tests != null ? new List<String>.from(_tests) : null) ?? obj.tests;
    return obj;
  }

  @override
  dynamic encode(ModelE value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['tests'] = value.tests;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'ModelE';
}

class NullTestCodec extends TypeCodec<NullTest> {
  @override
  NullTest decode(dynamic value, {Serializer serializer}) {
    NullTest obj = new NullTest();
    List _tests = serializer?.decode(value['tests'], type: String);
    obj.tests =
        (_tests != null ? new List<String>.from(_tests) : null) ?? obj.tests;
    obj.test = value['test'] as String ?? obj.test;
    List _testModel = serializer?.decode(value['testModel'], type: ModelA);
    obj.testModel =
        (_testModel != null ? new List<ModelA>.from(_testModel) : null) ??
            obj.testModel;
    return obj;
  }

  @override
  dynamic encode(NullTest value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['tests'] = value.tests;
    map['test'] = value.test;
    map['testModel'] = serializer?.toPrimaryObject(value.testModel,
        useTypeInfo: useTypeInfo, withTypeInfo: false);
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'NullTest';
}

class ModelRenamedCodec extends TypeCodec<ModelRenamed> {
  @override
  ModelRenamed decode(dynamic value, {Serializer serializer}) {
    ModelRenamed obj = new ModelRenamed();
    List _tests = serializer?.decode(value['tests'], type: String);
    obj.tests =
        (_tests != null ? new List<String>.from(_tests) : null) ?? obj.tests;
    obj.original = value['new'] as String ?? obj.original;
    return obj;
  }

  @override
  dynamic encode(ModelRenamed value,
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
  String get typeInfo => 'ModelRenamed';
}

class WithIgnoreCodec extends TypeCodec<WithIgnore> {
  @override
  WithIgnore decode(dynamic value, {Serializer serializer}) {
    WithIgnore obj = new WithIgnore();
    obj.a = value['a'] as String ?? obj.a;
    obj.b = value['b'] as String ?? obj.b;
    return obj;
  }

  @override
  dynamic encode(WithIgnore value,
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
  String get typeInfo => 'WithIgnore';
}

class DateCodec extends TypeCodec<Date> {
  @override
  Date decode(dynamic value, {Serializer serializer}) {
    Date obj = new Date();
    obj.date = serializer?.decode(value['date'], type: DateTime) ?? obj.date;
    return obj;
  }

  @override
  dynamic encode(Date value,
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
  String get typeInfo => 'Date';
}

class TestMaxSuperClassCodec extends TypeCodec<TestMaxSuperClass> {
  @override
  TestMaxSuperClass decode(dynamic value, {Serializer serializer}) {
    TestMaxSuperClass obj = new TestMaxSuperClass();
    obj.foo = value['foo'] as String ?? obj.foo;
    obj.serialize = value['serialize'] as String ?? obj.serialize;
    return obj;
  }

  @override
  dynamic encode(TestMaxSuperClass value,
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
  String get typeInfo => 'TestMaxSuperClass';
}

class ComplexCodec extends TypeCodec<Complex> {
  @override
  Complex decode(dynamic value, {Serializer serializer}) {
    Complex obj = new Complex();
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
            ? new List<int>.from(_ints.map((item) => item?.toInt()))
            : null) ??
        obj.ints;
    List _doubles = serializer?.decode(value['doubles'], type: double);
    obj.doubles = (_doubles != null
            ? new List<double>.from(_doubles.map((item) => item?.toDouble()))
            : null) ??
        obj.doubles;
    List _dates = serializer?.decode(value['dates'], type: DateTime);
    obj.dates =
        (_dates != null ? new List<DateTime>.from(_dates) : null) ?? obj.dates;
    List _ignores = serializer?.decode(value['ignores'], type: WithIgnore);
    obj.ignores =
        (_ignores != null ? new List<WithIgnore>.from(_ignores) : null) ??
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
                key: (key) => key, value: (key) => _intSet[key]?.toInt())
            : null) ??
        obj.intSet;
    Map _doubleSet =
        serializer?.decode(value['doubleSet'], mapOf: const [String, double]);
    obj.doubleSet = (_doubleSet != null
            ? new Map.fromIterable(_doubleSet.keys,
                key: (key) => key, value: (key) => _doubleSet[key]?.toDouble())
            : null) ??
        obj.doubleSet;
    Map _dateSet =
        serializer?.decode(value['dateSet'], mapOf: const [String, DateTime]);
    obj.dateSet =
        (_dateSet != null ? new Map.from(_dateSet) : null) ?? obj.dateSet;
    Map _ignoreSet = serializer
        ?.decode(value['ignoreSet'], mapOf: const [String, WithIgnore]);
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
  dynamic encode(Complex value,
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
  String get typeInfo => 'Complex';
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

Map<String, TypeCodec<dynamic>> test_json_test_codecs =
    <String, TypeCodec<dynamic>>{
  'ModelInt': new ModelIntCodec(),
  'ModelDouble': new ModelDoubleCodec(),
  'ModelA': new ModelACodec(),
  'ModelB': new ModelBCodec(),
  'ModelC': new ModelCCodec(),
  'ModelD': new ModelDCodec(),
  'ModelE': new ModelECodec(),
  'NullTest': new NullTestCodec(),
  'ModelRenamed': new ModelRenamedCodec(),
  'WithIgnore': new WithIgnoreCodec(),
  'Date': new DateCodec(),
  'TestMaxSuperClass': new TestMaxSuperClassCodec(),
  'Complex': new ComplexCodec(),
  'Mixin': new MixinCodec(),
};
