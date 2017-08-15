// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: SerializerGenerator
// Target: library
// **************************************************************************

library json_test.codec;

import 'package:serializer/core.dart' show Serializer, cleanNullInMap;
import 'package:serializer/codecs.dart';
import 'json_test.dart';

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelInt
// **************************************************************************

class ModelIntCodec extends TypeCodec<ModelInt> {
  @override
  ModelInt decode(dynamic value, {Serializer serializer}) {
    ModelInt obj = new ModelInt();
    obj.bar = (value['bar'] ?? obj.bar)?.toInt();
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelDouble
// **************************************************************************

class ModelDoubleCodec extends TypeCodec<ModelDouble> {
  @override
  ModelDouble decode(dynamic value, {Serializer serializer}) {
    ModelDouble obj = new ModelDouble();
    obj.bar = (value['bar'] ?? obj.bar)?.toDouble();
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelA
// **************************************************************************

class ModelACodec extends TypeCodec<ModelA> {
  @override
  ModelA decode(dynamic value, {Serializer serializer}) {
    ModelA obj = new ModelA();
    obj.foo = (value['foo'] ?? obj.foo) as String;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelB
// **************************************************************************

class ModelBCodec extends TypeCodec<ModelB> {
  @override
  ModelB decode(dynamic value, {Serializer serializer}) {
    ModelB obj = new ModelB();
    obj.foo = (serializer?.decode(value['foo'], type: Test) ?? obj.foo) as Test;
    obj.toto = (value['toto'] ?? obj.toto) as String;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelC
// **************************************************************************

class ModelCCodec extends TypeCodec<ModelC> {
  @override
  ModelC decode(dynamic value, {Serializer serializer}) {
    ModelC obj = new ModelC();
    obj.foo =
        (serializer?.decode(value['foo'], type: ModelA) ?? obj.foo) as ModelA;
    obj.plop = (value['plop'] ?? obj.plop) as String;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelD
// **************************************************************************

class ModelDCodec extends TypeCodec<ModelD> {
  @override
  ModelD decode(dynamic value, {Serializer serializer}) {
    ModelD obj = new ModelD();
    obj.tests = (serializer?.decode(value['tests'], type: ModelA) ?? obj.tests)
        as List<ModelA>;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelE
// **************************************************************************

class ModelECodec extends TypeCodec<ModelE> {
  @override
  ModelE decode(dynamic value, {Serializer serializer}) {
    ModelE obj = new ModelE();
    obj.tests = (serializer?.decode(value['tests'], type: String) ?? obj.tests)
        as List<String>;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class NullTest
// **************************************************************************

class NullTestCodec extends TypeCodec<NullTest> {
  @override
  NullTest decode(dynamic value, {Serializer serializer}) {
    NullTest obj = new NullTest();
    obj.tests = (serializer?.decode(value['tests'], type: String) ?? obj.tests)
        as List<String>;
    obj.test = (value['test'] ?? obj.test) as String;
    obj.testModel = (serializer?.decode(value['testModel'], type: ModelA) ??
        obj.testModel) as List<ModelA>;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class ModelRenamed
// **************************************************************************

class ModelRenamedCodec extends TypeCodec<ModelRenamed> {
  @override
  ModelRenamed decode(dynamic value, {Serializer serializer}) {
    ModelRenamed obj = new ModelRenamed();
    obj.tests = (serializer?.decode(value['tests'], type: String) ?? obj.tests)
        as List<String>;
    obj.original = (value['new'] ?? obj.original) as String;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class WithIgnore
// **************************************************************************

class WithIgnoreCodec extends TypeCodec<WithIgnore> {
  @override
  WithIgnore decode(dynamic value, {Serializer serializer}) {
    WithIgnore obj = new WithIgnore();
    obj.a = (value['a'] ?? obj.a) as String;
    obj.b = (value['b'] ?? obj.b) as String;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class Date
// **************************************************************************

class DateCodec extends TypeCodec<Date> {
  @override
  Date decode(dynamic value, {Serializer serializer}) {
    Date obj = new Date();
    obj.date = (serializer?.decode(value['date'], type: DateTime) ?? obj.date)
        as DateTime;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TestMaxSuperClass
// **************************************************************************

class TestMaxSuperClassCodec extends TypeCodec<TestMaxSuperClass> {
  @override
  TestMaxSuperClass decode(dynamic value, {Serializer serializer}) {
    TestMaxSuperClass obj = new TestMaxSuperClass();
    obj.foo = (value['foo'] ?? obj.foo) as String;
    obj.serialize = (value['serialize'] ?? obj.serialize) as String;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class Complex
// **************************************************************************

class ComplexCodec extends TypeCodec<Complex> {
  @override
  Complex decode(dynamic value, {Serializer serializer}) {
    Complex obj = new Complex();
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
    obj.ignores = (serializer?.decode(value['ignores'], type: WithIgnore) ??
        obj.ignores) as List<WithIgnore>;
    obj.numSet =
        (serializer?.decode(value['numSet'], mapOf: const [String, num]) ??
            obj.numSet) as Map<String, num>;
    obj.stringSet = (serializer
            ?.decode(value['stringSet'], mapOf: const [String, String]) ??
        obj.stringSet) as Map<String, String>;
    obj.boolSet =
        (serializer?.decode(value['boolSet'], mapOf: const [String, bool]) ??
            obj.boolSet) as Map<String, bool>;
    obj.intSet =
        (serializer?.decode(value['intSet'], mapOf: const [String, int]) ??
            obj.intSet) as Map<String, int>;
    obj.doubleSet = (serializer
            ?.decode(value['doubleSet'], mapOf: const [String, double]) ??
        obj.doubleSet) as Map<String, double>;
    obj.dateSet = (serializer
            ?.decode(value['dateSet'], mapOf: const [String, DateTime]) ??
        obj.dateSet) as Map<String, DateTime>;
    obj.ignoreSet = (serializer
            ?.decode(value['ignoreSet'], mapOf: const [String, WithIgnore]) ??
        obj.ignoreSet) as Map<String, WithIgnore>;
    obj.listInnerMap = (serializer
            ?.decode(value['listInnerMap'], mapOf: const [String, List]) ??
        obj.listInnerMap) as Map<String, List<dynamic>>;
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

// **************************************************************************
// Generator: SerializerGenerator
// Target: class GetterOnly
// **************************************************************************

class GetterOnlyCodec extends TypeCodec<GetterOnly> {
  @override
  GetterOnly decode(dynamic value, {Serializer serializer}) {
    GetterOnly obj = new GetterOnly();
    return obj;
  }

  @override
  dynamic encode(GetterOnly value,
      {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {
      map[serializer.typeInfoKey] = typeInfo;
    }
    map['value'] = value.value;
    return cleanNullInMap(map);
  }

  @override
  String get typeInfo => 'GetterOnly';
}

Map<String, TypeCodec<dynamic>> test_codegen_json_test_codecs =
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
  'GetterOnly': new GetterOnlyCodec(),
};
