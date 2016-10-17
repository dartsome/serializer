// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file

// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:serializer/codecs.dart';
import 'package:serializer/serializer_reflectable.dart';
import "package:serializer/reflectable/convert.dart";
import 'models_test.dart';

abstract class DontWantToBeSerialize {
  String foo = "bar";
}

@serializable
abstract class Proxy extends JsonObject {}

abstract class ProxyA extends Proxy {}

@serializable
class ModelInt extends ProxyA {
  int _bar;

  int get bar => _bar;

  set bar(int value) => _bar = value;

  ModelInt([this._bar = 42]);
}

@serializable
class ModelDouble extends ProxyA {
  double bar;

  ModelDouble([this.bar = 42.42]);
}

@serializable
class ModelA extends ProxyA {
  String _foo;

  String get foo => _foo;

  set foo(String value) => _foo = value;

  ModelA([this._foo = "bar"]);
}

class Test {
  String toto = "tata";
}

@serializable
class ModelB extends ProxyA {
  Test foo = new Test();
  String toto = "tata";
}

@serializable
class ModelC extends ProxyA {
  ModelA foo = new ModelA();
  String plop = "titi";
}

@serializable
class ModelD extends ProxyA {
  List<ModelA> tests;

  ModelD([this.tests]);
}

@serializable
class ModelE extends ProxyA {
  List<String> tests;

  ModelE([this.tests]);
}

@serializable
class NullTest extends ProxyA {
  List<String> tests = null;
  String test = null;
  List<ModelA> testModel = null;

  NullTest();
}

@serializable
class ModelRenamed extends ModelE {
  @SerializedName("new")
  String original;

  ModelRenamed([this.original]);
}

@serializable
class WithIgnore extends ProxyA {
  String a;
  String b;
  @ignore
  String secret;

  WithIgnore([this.a, this.b, this.secret]);
}

Serializer _dateSerializer = new ReflectableSerializer.json()
  ..addTypeCodec(DateTime, new DateTimeCodec());

@serializable
class Date extends ProxyA {
  DateTime date = new DateTime.now();

  @ignore
  Serializer get serializer => _dateSerializer;

  Date([this.date]);
}

@serializable
class TestMaxSuperClass extends DontWantToBeSerialize {
  String serialize = "okay";
}

@serializable
class Complex extends ProxyA {
  List<num> nums;
  List<String> strings;
  List<bool> bools;
  List<int> ints;
  List<double> doubles;
  List<DateTime> dates;
  List<WithIgnore> ignores;
  Map<String, num> numSet;
  Map<String, String> stringSet;
  Map<String, bool> boolSet;
  Map<String, int> intSet;
  Map<String, double> doubleSet;
  Map<String, DateTime> dateSet;
  Map<String, WithIgnore> ignoreSet;
  Map<String, List> listInnerMap;
}

@serializable
class Mixin extends ProxyA with M1, M2 {
  String a;
  String b;
}

Serializer serializer;

main() {
  setUpAll(() {
    serializer = new ReflectableSerializer.json()
      ..addTypeCodec(DateTime, new DateTimeCodec());
  });

  tearDownAll(() {
    printAndDumpSerializables();
  });

  group("Serialize", () {
    test("simple test", () {
      ModelA a = new ModelA("toto");

      expect("{foo: toto}", a.toString());
      expect('{"foo":"toto"}', a.toJson());
      expect({"foo": "toto"}, a.toMap());
    });

    test("Map to Map", () {
      Map a = {"test": "toto", "titi": new ModelA()};
      String json = serializer.encode(a);
      expect('{"test":"toto","titi":{"foo":"bar"}}', json);
    });

    test("list", () {
      List<ModelA> list = [new ModelA("toto"), new ModelA()];

      String json = serializer.encode(list);
      expect('[{"foo":"toto"},{"foo":"bar"}]', json);
    });

    test("inner list 1", () {
      List<ModelA> list = [new ModelA("toto"), new ModelA()];
      ModelD test = new ModelD(list);
      String json = test.toJson();

      expect('{"tests":[{"foo":"toto"},{"foo":"bar"}]}', json);
    });

    test("inner list 2", () {
      ModelE e = new ModelE(["toto", "bar"]);

      expect('{"tests":["toto","bar"]}', e.toJson());
    });

    test("inner class non-serializable", () {
      ModelB b = new ModelB();
      expect('{"toto":"tata"}', b.toJson());
      expect({"toto": "tata"}, b.toMap());
    });

    test("inner class serializable", () {
      ModelC c = new ModelC();
      expect('{"foo":{"foo":"bar"},"plop":"titi"}', c.toJson());
      expect({
        "foo": {"foo": "bar"},
        "plop": "titi"
      }, c.toMap());
    });

    test("list class non-serializable", () {
      List list = [new ModelB(), new ModelB()];
      String json = serializer.encode(list);
      expect('[{"toto":"tata"},{"toto":"tata"}]', json);
    });

    test("list inner list", () {
      List listA = [new ModelB(), new ModelB()];
      List listB = [new ModelB(), listA];
      String json = serializer.encode(listB);
      expect('[{"toto":"tata"},[{"toto":"tata"},{"toto":"tata"}]]', json);
    });

    test("list class serializable", () {
      List list = [new ModelC(), new ModelC()];
      String json = serializer.encode(list);
      expect('[{"foo":{"foo":"bar"},"plop":"titi"},{"foo":{"foo":"bar"},"plop":"titi"}]', json);
    });

    test("Datetime", () {
      Date date = new Date(new DateTime(2016, 1, 1));
      expect({"date": "2016-01-01T00:00:00.000"}, date.toMap());
      expect('{"date":"2016-01-01T00:00:00.000"}', date.toJson());
    });

    test("Max Superclass", () {
      TestMaxSuperClass _test = new TestMaxSuperClass();
      expect('{"serialize":"okay"}', serializer.encode(_test));
      expect({"serialize": "okay"}, serializer.toMap(_test));
    });

    test("Ignore attribute", () {
      WithIgnore _ignore = new WithIgnore("1337", "42", "ThisIsASecret");
      expect('{"a":"1337","b":"42"}', serializer.encode(_ignore));
      expect({"a": "1337", "b": "42"}, serializer.toMap(_ignore));
    });

    test("Serialized name", () {
      ModelRenamed _model = new ModelRenamed("Hello")..tests = ["A", "B", "C"];
      expect('{"new":"Hello","tests":["A","B","C"]}', serializer.encode(_model));
      expect({
        "new": "Hello",
        "tests": ["A", "B", "C"]
      }, serializer.toMap(_model));
    });

    test("Test Double", () {
      ModelDouble d = new ModelDouble();
      expect({"bar": 42.42}, serializer.toMap(d));
    });

    test("Null Test", () {
      NullTest d = new NullTest();
      d.testModel = [null];
      d.test = "test";
      expect(serializer.encode(d), '{"test":"test","testModel":[null]}');
    });

    test("toPrimaryObject 1", () {
      expect(serializer.toPrimaryObject(new ModelA()), equals({"foo": "bar"}));
      expect(serializer.toPrimaryObject(new ModelD([new ModelA(), null])), equals({"tests": [{"foo": "bar"}, null]}));
      expect(serializer.toPrimaryObject(1), equals(1));
      expect(serializer.toPrimaryObject("Test"), equals("Test"));
      expect(serializer.toPrimaryObject({"foo": "bar"}), equals({"foo": "bar"}));
      expect(serializer.toPrimaryObject(42.42), equals(42.42));
      expect(serializer.toPrimaryObject(null), isNull);
    });

    test("toPrimaryObject 2", () {
      List<NullTest> d = [
        new NullTest()..test = "test",
        null,
        new NullTest()..testModel = [new ModelA(), null, new ModelA("toto")]
      ];

      var obj = serializer.toPrimaryObject(d);
      expect(obj is List, isTrue);
      expect((obj as List).length, equals(3));
      expect((obj as List)[0] is Map, isTrue);
      expect((obj as List)[0], equals({"test": "test"}));
      expect((obj as List)[1], isNull);
      expect((obj as List)[2] is Map, isTrue);
      expect(
          ((obj as List)[2] as Map)["testModel"],
          equals([
            {"foo": "bar"},
            null,
            {"foo": "toto"}
          ]));
    });

    test("dynamic", () {
      Cat cat = new Cat()
        ..name = "Felix"
        ..mew  = false;
      Dog dog = new Dog()
        ..name = "Medor"
        ..bark = true;
      Pet pet;

      pet = new Pet()
        ..name = "Pet"
        ..animal = cat;
      expect('{"name":"Pet","animal":{"@type":"Cat","name":"Felix","mew":false}}', serializer.encode(pet));

      pet = new Pet()
        ..name = "Pet"
        ..animal = dog;
      expect('{"name":"Pet","animal":{"@type":"Dog","name":"Medor","bark":true}}', serializer.encode(pet));
    });

    test("with typeInfo", () {
      Cat cat = new Cat()
        ..name = "Felix"
        ..mew  = false;
      Dog dog = new Dog()
        ..name = "Medor"
        ..bark = true;
      var pet;

      pet = new PetWithTypeInfo()
        ..name = "Pet"
        ..animal = cat;
      expect('{"name":"Pet","animal":{"@type":"Cat","name":"Felix","mew":false}}', serializer.encode(pet));

      pet = new PetWithTypeInfo()
        ..name = "Pet"
        ..animal = dog;
      expect('{"name":"Pet","animal":{"@type":"Dog","name":"Medor","bark":true}}', serializer.encode(pet));
    });
  });

  group("Deserialize", () {
    test("simple test - fromJson", () {
      ModelA a = serializer.decode('{"foo":"toto"}', type: ModelA);

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("simple test - fromMap - without type field", () {
      ModelA a = serializer.fromMap({"foo": "toto"}, type: ModelA);

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("simple test - fromMap", () {
      ModelA a = serializer.fromMap({"foo": "toto"}, type: ModelA);

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("Map fromMap Map", () {
      Map a = {"titi": new ModelA().toMap()};
      Map b = serializer.fromMap(a, type: Map, mapOf: [String, ModelA]);

      expect(ModelA, b["titi"].runtimeType);
      expect("bar", b["titi"].foo);
    });

    test("list - fromJson", () {
      List<ModelA> list = serializer.decode('[{"foo":"toto"},{"foo":"bar"}]', type: ModelA) as List<ModelA>;

      expect(2, list.length);
      expect("toto", list[0]?.foo);
      expect("bar", list[1]?.foo);

      expect(ModelA, list[0]?.runtimeType);
      expect(ModelA, list[1]?.runtimeType);
    });

    test("list - fromList", () {
      List list = serializer.fromList([
        {"@dart_type": "ModelA", "foo": "toto"},
        {"@dart_type": "ModelA", "foo": "bar"}
      ], type: ModelA);

      expect(2, list.length);
      expect("toto", list[0]?.foo);
      expect("bar", list[1]?.foo);

      expect(ModelA, list[0]?.runtimeType);
      expect(ModelA, list[1]?.runtimeType);
    });

    test("inner list 1", () {
      ModelD test = serializer.decode('{"tests":[{"foo":"toto"},{"foo":"bar"}]}', type: ModelD);

      expect(2, test?.tests?.length);
      expect(ModelA, test?.tests[0]?.runtimeType);
      expect(ModelA, test?.tests[1]?.runtimeType);
      expect("toto", test?.tests[0]?.foo);
      expect("bar", test?.tests[1]?.foo);
    });

    test("inner list 2", () {
      ModelE test = serializer.decode('{"tests":["toto","bar"]}', type: ModelE);

      expect(2, test?.tests?.length);
      expect("toto", test?.tests[0]);
      expect("bar", test?.tests[1]);
    });

    test("inner class non-serializable", () {
      ModelB b = serializer.decode('{"toto":"tata","foo":{"toto":"tata"}}', type: ModelB);

      expect("tata", b.foo.toto);
    });

    test("inner class serializable", () {
      ModelC c = serializer.decode('{"foo":{"foo":"toto"},"plop":"bar"}', type: ModelC);
      expect(ModelA, c.foo.runtimeType);
      expect("toto", c.foo.foo);
      expect("bar", c.plop);
    });

    test("Datetime", () {
      Date date = serializer.decode('{"date":"2016-01-01T00:00:00.000"}', type: Date);

      expect("2016-01-01T00:00:00.000", date.date.toIso8601String());
      expect('{"date":"2016-01-01T00:00:00.000"}', date.toJson());
    });

    test("Max Superclass", () {
      TestMaxSuperClass _test = serializer.decode('{"serialize":"okay","foo":"nobar"}', type: TestMaxSuperClass);

      expect("okay", _test.serialize);
      expect("bar", _test.foo);
    });

    test("Ignore attribute", () {
      WithIgnore _ignore = serializer.decode('{"a":"1337","b":"42","secret":"ignore"}', type: WithIgnore);

      expect("1337", _ignore.a);
      expect("42", _ignore.b);
      expect(null, _ignore.secret);
    });

    test("Serialized name", () {
      ModelRenamed _model = serializer.decode('{"new":"Hello","tests":["A","B","C"]}', type: ModelRenamed);

      expect("Hello", _model.original);
      expect(["A", "B", "C"], _model.tests);
    });

    test("Test reflectable error", () {
      try {
        DontWantToBeSerialize _ = serializer.decode('{"foo":"bar"}', type: DontWantToBeSerialize);
      } catch (e) {
        expect(true, e is String);
        // expect("Cannot instantiate abstract class DontWantToBeSerialize: _url 'null' line null", e);
      }
    });

    test("Test Double", () {
      ModelDouble d = serializer.decode('{"bar":42.1}', type: ModelDouble);
      expect(d.bar, 42.1);
    });

    test("Null Test", () {
      ModelD d = serializer.decode('{"tests":null}', type: ModelD);
      expect(d.tests, isNull);
    });

    test("Already Decode", () {
      List a = [new ModelA()];
      List<ModelA> b = serializer.fromList(a, type: ModelA) as List<ModelA>;

      expect(a, equals(b));

      Map c = { "test": new ModelA()};
      Map<String, ModelA> d = serializer.fromMap(c, type: Map, mapOf: [String, ModelA]) as Map<String, ModelA>;

      expect(c, equals(d));
    });

    test("dynamic", () {
      Pet pet;

      pet = serializer.decode('{"name":"Pet","animal":{"@type":"Cat","name":"Felix","mew":false}}', type: Pet);
      expect(pet.name, "Pet");
      print((pet.animal as Cat));
      expect(pet.animal is Cat, isTrue);
      var cat = pet.animal as Cat;
      expect(cat.name, "Felix");
      expect(cat.mew, false);

      pet = serializer.decode('{"name":"Pet","animal":{"@type":"Dog","name":"Medor","bark":true}}', type: Pet);
      expect(pet.name, "Pet");
      expect(pet.animal is Dog, isTrue);
      var dog = pet.animal as Dog;
      expect(dog.name, "Medor");
      expect(dog.bark, true);
    });

    test("with typeInfo", () {
      PetWithTypeInfo pet;

      pet = serializer.decode('{"name":"Pet","animal":{"@type":"Cat","name":"Felix","mew":false}}', type: PetWithTypeInfo);
      expect(pet.name, "Pet");
      expect(pet.animal is Cat, isTrue);
      var cat = pet.animal as Cat;
      expect(cat.name, "Felix");
      expect(cat.mew, false);

      pet = serializer.decode('{"name":"Pet","animal":{"@type":"Dog","name":"Medor","bark":true}}', type: PetWithTypeInfo);
      expect(pet.name, "Pet");
      expect(pet.animal is Dog, isTrue);
      var dog = pet.animal as Dog;
      expect(dog.name, "Medor");
      expect(dog.bark, true);
    });
  });

  group("Complex", () {
    test("Serialize", () {
      var complex = new Complex()
        ..nums = [1, 2.2, 3]
        ..strings = ["1", "2", "3"]
        ..bools = [true, false, true]
        ..ints = [1, 2, 3]
        ..doubles = [1.1, 2.2, 3.3]
        ..dates = [new DateTime(2016, 12, 24), new DateTime(2016, 12, 25), new DateTime(2016, 12, 26)]
        ..ignores = [new WithIgnore("1337A", "42A", "ThisIsASecretA"), new WithIgnore("1337B", "42B", "ThisIsASecretB")]
        ..numSet = {"numA": 1, "numB": 12.2}
        ..stringSet = {"strA": "1", "strB": "3"}
        ..boolSet = {"ok": true, "nok": false}
        ..intSet = {"intA": 1, "intB": 12}
        ..doubleSet = {"dblA": 1.1, "dblB": 12.1}
        ..dateSet = {"fiesta": new DateTime(2016, 12, 24), "christmas": new DateTime(2016, 12, 25)}
        ..ignoreSet = {"A": new WithIgnore("1337A", "42A", "ThisIsASecretA"), "B": new WithIgnore("1337B", "42B", "ThisIsASecretB")}
        ..listInnerMap = {
          "test": ["123456"]
        };
      var json = serializer.encode(complex);
      expect(json,
          '{"nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"a":"1337A","b":"42A"},{"a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"a":"1337A","b":"42A"},"B":{"a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');
      var typedJson;
      typedJson = serializer.encode(complex, useTypeInfo: false);
      expect(typedJson,
          '{"nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"a":"1337A","b":"42A"},{"a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"a":"1337A","b":"42A"},"B":{"a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');
      typedJson = serializer.encode(complex, useTypeInfo: true);
      expect(typedJson,
          '{"@type":"Complex","nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"@type":"WithIgnore","a":"1337A","b":"42A"},{"@type":"WithIgnore","a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"@type":"WithIgnore","a":"1337A","b":"42A"},"B":{"@type":"WithIgnore","a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');

      var jsonWithType;
      jsonWithType = serializer.encode(complex, withTypeInfo: false);
      expect(jsonWithType,
          '{"nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"a":"1337A","b":"42A"},{"a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"a":"1337A","b":"42A"},"B":{"a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');
      jsonWithType = serializer.encode(complex, withTypeInfo: true);
      expect(jsonWithType,
          '{"@type":"Complex","nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"a":"1337A","b":"42A"},{"a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"a":"1337A","b":"42A"},"B":{"a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');
    });

    test("Deserialize", () {
      checkComplex(Complex complex) {
        expect(complex.nums, [1, 2.2, 3]);
        expect(complex.strings, ["1", "2", "3"]);
        expect(complex.bools, [true, false, true]);
        expect(complex.ints, [1, 2, 3]);
        expect(complex.doubles, [1.1, 2.2, 3.3]);
        expect(complex.dates, [new DateTime(2016, 12, 24), new DateTime(2016, 12, 25), new DateTime(2016, 12, 26)]);
        expect(complex.ignores[0].a, "1337A");
        expect(complex.ignores[0].b, "42A");
        expect(complex.ignores[0].secret, null);
        expect(complex.ignores[1].a, "1337B");
        expect(complex.ignores[1].b, "42B");
        expect(complex.ignores[1].secret, null);
        expect(complex.listInnerMap["test"], ["123456"]);

        expect(complex.numSet, {"numA": 1, "numB": 12.2});
        expect(complex.stringSet, {"strA": "1", "strB": "3"});
        expect(complex.boolSet, {"ok": true, "nok": false});
        expect(complex.intSet, {"intA": 1, "intB": 12});
        expect(complex.doubleSet, {"dblA": 1.1, "dblB": 12.1});
        expect(complex.dateSet, {"fiesta": new DateTime(2016, 12, 24), "christmas": new DateTime(2016, 12, 25)});
        expect(complex.ignoreSet["A"].a, "1337A");
        expect(complex.ignoreSet["A"].b, "42A");
        expect(complex.ignoreSet["A"].secret, null);
        expect(complex.ignoreSet["B"].a, "1337B");
        expect(complex.ignoreSet["B"].b, "42B");
        expect(complex.ignoreSet["B"].secret, null);
      }

      Complex complex = serializer.decode(
          '{"nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"a":"1337A","b":"42A"},{"a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"a":"1337A","b":"42A"},"B":{"a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}',
          type: Complex);
      checkComplex(complex);

      Complex typedComplex = serializer.decode(
          '{"@type":"Complex","nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"@type":"WithIgnore","a":"1337A","b":"42A"},{"@type":"WithIgnore","a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"@type":"WithIgnore","a":"1337A","b":"42A"},"B":{"@type":"WithIgnore","a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}',
          useTypeInfo: true);
      checkComplex(typedComplex);

      Complex complexWithType = serializer.decode(
          '{"@type":"Complex","nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"a":"1337A","b":"42A"},{"a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"a":"1337A","b":"42A"},"B":{"a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}',
          withTypeInfo: true);
      checkComplex(complexWithType);
    });
  });

  group("Mixin", () {
    test("Serialize", () {
      var mixin = new Mixin()
        ..a = "A"
        ..b = "B"
        ..m1 = "M1"
        ..m2 = "M2";
      var json = serializer.encode(mixin);
      expect(json, '{"a":"A","b":"B","m2":"M2","m1":"M1"}');
    });

    test("Deserialize", () {
      Mixin mixin = serializer.decode('{"a":"A","b":"B","m2":"M2","m1":"M1"}', type: Mixin);

      expect(mixin.a, "A");
      expect(mixin.b, "B");
      expect(mixin.m1, "M1");
      expect(mixin.m2, "M2");
    });
  });

  group("Referenceable", () {
    test("Serialize", () {
      Address addressManager = new Address()
        ..id = 1337
        ..location = "Somewhere";

      Address addressEmployee = new Address()
        ..id = 1338
        ..location = "Somewhere else";

      Employee manager = new Employee()
        ..id = 43
        ..name = "Alice Doo"
        ..address = addressManager;
      addressManager.owner = manager;

      Employee employee = new Employee()
        ..id = 42
        ..name = "Bob Smith"
        ..address = addressEmployee
        ..manager = manager;
      addressEmployee.owner = employee;

      expect(serializer.encode(addressManager), '{"id":1337,"location":"Somewhere","owner":{"id":43}}');
      expect(serializer.encode(addressEmployee), '{"id":1338,"location":"Somewhere else","owner":{"id":42}}');
      expect(serializer.encode(manager), '{"id":43,"name":"Alice Doo","address":{"id":1337}}');
      expect(serializer.encode(employee), '{"id":42,"name":"Bob Smith","address":{"id":1338},"manager":{"id":43}}');
    });
  });

  group("Static", () {
    test("Serialize const", () {
      WithStaticConst static = new WithStaticConst()..other = "42";

      expect(serializer.encode(static), '{"other":"42"}');
    });

    test("Deserialize const", () {
      WithStaticConst static = serializer.decode('{"other":"42"}', type: WithStaticConst);

      expect(static.other, "42");
    });

    test("Serialize", () {
      WithStatic static = new WithStatic()..other = "42";

      expect(serializer.encode(static), '{"other":"42"}');
    });

    test("Deserialize", () {
      WithStatic static = serializer.decode('{"other":"42"}', type: WithStatic);

      expect(static.other, "42");
    });
  });
}
