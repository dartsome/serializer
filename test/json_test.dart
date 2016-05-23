// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file

// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:serializer/serializer.dart';
import "package:serializer/src/convert.dart";

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

  factory ModelInt.fromJson(String json) {
    ModelInt data = serializer.decode(json, ModelInt);
  }
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

@serializable
class Date extends ProxyA {
  DateTime date = new DateTime.now();

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

Serializer serializer;

main() {
  setUpAll(() {
    serializer = new Serializer.Json();
  });

  tearDownAll(() {
    dumpSerializables();
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
      expect(
          '[{"foo":"toto"},{"foo":"bar"}]',
          json);
    });

    test("inner list 1", () {
      List<ModelA> list = [new ModelA("toto"), new ModelA()];
      ModelD test = new ModelD(list);
      String json = test.toJson();

      expect(
          '{"tests":[{"foo":"toto"},{"foo":"bar"}]}',
          json);
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
      expect(
          '{"foo":{"foo":"bar"},"plop":"titi"}',
          c.toJson());
      expect({
        "foo": {"foo": "bar"},
        "plop": "titi"
      }, c.toMap());
    });

    test("list class non-serializable", () {
      List list = [new ModelB(), new ModelB()];
      String json = serializer.encode(list);
      expect(
          '[{"toto":"tata"},{"toto":"tata"}]',
          json);
    });

    test("list inner list", () {
      List listA = [new ModelB(), new ModelB()];
      List listB = [new ModelB(), listA];
      String json = serializer.encode(listB);
      expect(
          '[{"toto":"tata"},[{"toto":"tata"},{"toto":"tata"}]]',
          json);
    });

    test("list class serializable", () {
      List list = [new ModelC(), new ModelC()];
      String json = serializer.encode(list);
      expect(
          '[{"foo":{"foo":"bar"},"plop":"titi"},{"foo":{"foo":"bar"},"plop":"titi"}]',
          json);
    });

    test("Datetime", () {
      Date date = new Date(new DateTime(2016, 1, 1));
      expect({"date": "2016-01-01T00:00:00.000"},
          date.toMap());
      expect('{"date":"2016-01-01T00:00:00.000"}',
          date.toJson());
    });

    test("Max Superclass", () {
      TestMaxSuperClass _test = new TestMaxSuperClass();
      expect(
          '{"serialize":"okay"}',
          serializer.encode(_test));
      expect({"serialize":"okay"}, serializer.toMap(_test));
    });

    test("Ignore attribute", () {
      WithIgnore _ignore = new WithIgnore("1337", "42", "ThisIsASecret");
      expect(
          '{"a":"1337","b":"42"}',
          serializer.encode(_ignore));
      expect({"a":"1337", "b":"42"}, serializer.toMap(_ignore));
    });

    test("Serialized name", () {
      ModelRenamed _model = new ModelRenamed("Hello")
        ..tests = ["A", "B", "C"];
      expect('{"new":"Hello","tests":["A","B","C"]}', serializer.encode(_model));
      expect({"new":"Hello", "tests":["A", "B", "C"]}, serializer.toMap(_model));
    });

    test("Test Double", () {
      ModelDouble d = new ModelDouble();
      expect({"bar": 42.42}, serializer.toMap(d));
    });
  });

  group("Deserialize", () {
    test("simple test - fromJson", () {
      ModelA a =
      serializer.decode('{"foo":"toto"}', ModelA);

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("simple test - fromMap - without type field", () {
      ModelA a =
      serializer.fromMap({"foo": "toto"}, ModelA);

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("simple test - fromMap", () {
      ModelA a =
      serializer.fromMap({"foo": "toto"}, ModelA);

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("Map fromMap Map", () {
      Map a = {"titi": new ModelA().toMap()};
      Map b = serializer.fromMap(a, Map, [String, ModelA]);

      expect(ModelA, b["titi"].runtimeType);
      expect("bar", b["titi"].foo);
    });

    test("list - fromJson", () {
      List<ModelA> list = serializer.decode(
          '[{"foo":"toto"},{"foo":"bar"}]', ModelA) as List<ModelA>;

      expect(2, list.length);
      expect("toto", list[0]?.foo);
      expect("bar", list[1]?.foo);

      expect(ModelA, list[0]?.runtimeType);
      expect(ModelA, list[1]?.runtimeType);
    });

    test("list - fromList", () {
      List list = serializer.fromList(
          [{"@dart_type":"ModelA", "foo":"toto"}, {"@dart_type":"ModelA", "foo":"bar"}],
          ModelA);

      expect(2, list.length);
      expect("toto", list[0]?.foo);
      expect("bar", list[1]?.foo);

      expect(ModelA, list[0]?.runtimeType);
      expect(ModelA, list[1]?.runtimeType);
    });

    test("inner list 1", () {
      ModelD test = serializer.decode(
          '{"tests":[{"foo":"toto"},{"foo":"bar"}]}', ModelD);

      expect(2, test?.tests?.length);
      expect(ModelA, test?.tests[0]?.runtimeType);
      expect(ModelA, test?.tests[1]?.runtimeType);
      expect("toto", test?.tests[0]?.foo);
      expect("bar", test?.tests[1]?.foo);
    });

    test("inner list 2", () {
      ModelE test = serializer.decode(
          '{"tests":["toto","bar"]}', ModelE);

      expect(2, test?.tests?.length);
      expect("toto", test?.tests[0]);
      expect("bar", test?.tests[1]);
    });

    test("inner class non-serializable", () {
      ModelB b = serializer.decode(
          '{"toto":"tata","foo":{"toto":"tata"}}', ModelB);

      expect("tata", b.foo.toto);
    });

    test("inner class serializable", () {
      ModelC c = serializer.decode(
          '{"foo":{"foo":"toto"},"plop":"bar"}', ModelC);
      expect(ModelA, c.foo.runtimeType);
      expect("toto", c.foo.foo);
      expect("bar", c.plop);
    });

    test("Datetime", () {
      Date date = serializer.decode(
          '{"date":"2016-01-01T00:00:00.000"}', Date);

      expect("2016-01-01T00:00:00.000", date.date.toIso8601String());
      expect('{"date":"2016-01-01T00:00:00.000"}',
          date.toJson());
    });

    test("Max Superclass", () {
      TestMaxSuperClass _test = serializer.decode(
          '{"serialize":"okay","foo":"nobar"}', TestMaxSuperClass);

      expect("okay", _test.serialize);
      expect("bar", _test.foo);
    });

    test("Ignore attribute", () {
      WithIgnore _ignore = serializer.decode(
          '{"a":"1337","b":"42","secret":"ignore"}', WithIgnore);

      expect("1337", _ignore.a);
      expect("42", _ignore.b);
      expect(null, _ignore.secret);
    });

    test("Serialized name", () {
      ModelRenamed _model = serializer.decode(
          '{"new":"Hello","tests":["A","B","C"]}', ModelRenamed);

      expect("Hello", _model.original);
      expect(["A", "B", "C"], _model.tests);
    });

    test("Test reflectable error", () {
      try {
        DontWantToBeSerialize _ = serializer.decode(
            '{"foo":"bar"}', DontWantToBeSerialize);
      } catch (e) {
        expect(true, e is String);
        // expect("Cannot instantiate abstract class DontWantToBeSerialize: _url 'null' line null", e);
      }
    });

    test("Test Double", () {
      ModelDouble d = serializer.decode(
          '{"bar":42.1}', ModelDouble);
      expect(d.bar, 42.1);
    });
  });

  group("Complex", () {
    test("Serialize", () {
      var complex = new Complex()
        ..nums = [ 1, 2.2, 3]
        ..strings = [ "1", "2", "3"]
        ..bools = [ true, false, true]
        ..ints = [ 1, 2, 3]
        ..doubles = [ 1.1, 2.2, 3.3]
        ..dates = [ new DateTime(2016, 12, 24), new DateTime(2016, 12, 25), new DateTime(2016, 12, 26)]
        ..ignores = [ new WithIgnore("1337A", "42A", "ThisIsASecretA"), new WithIgnore("1337B", "42B", "ThisIsASecretB")
        ]
        ..numSet = { "numA": 1, "numB": 12.2}
        ..stringSet = { "strA": "1", "strB": "3"}
        ..boolSet = { "ok": true, "nok": false}
        ..intSet = { "intA": 1, "intB": 12}
        ..doubleSet = { "dblA": 1.0, "dblB": 12.0}
        ..dateSet = { "fiesta": new DateTime(2016, 12, 24), "christmas": new DateTime(2016, 12, 25)}
        ..ignoreSet = {
          "A": new WithIgnore("1337A", "42A", "ThisIsASecretA"),
          "B": new WithIgnore("1337B", "42B", "ThisIsASecretB")
        }
        ..listInnerMap = { "test": ["123456"]};
      var json = serializer.encode(complex);
      expect(json,
          '{"nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"a":"1337A","b":"42A"},{"a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.0,"dblB":12.0},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"a":"1337A","b":"42A"},"B":{"a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');
    });

    test("Deserialize", () {
      Complex complex = serializer.decode(
          '{"nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"a":"1337A","b":"42A"},{"a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.0,"dblB":12.0},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"a":"1337A","b":"42A"},"B":{"a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}',
          Complex);

      expect(complex.nums, [ 1, 2.2, 3]);
      expect(complex.strings, [ "1", "2", "3"]);
      expect(complex.bools, [ true, false, true]);
      expect(complex.ints, [ 1, 2, 3]);
      expect(complex.doubles, [ 1.1, 2.2, 3.3]);
      expect(complex.dates, [ new DateTime(2016, 12, 24), new DateTime(2016, 12, 25), new DateTime(2016, 12, 26)]);
      expect(complex.ignores[0].a, "1337A");
      expect(complex.ignores[0].b, "42A");
      expect(complex.ignores[0].secret, null);
      expect(complex.ignores[1].a, "1337B");
      expect(complex.ignores[1].b, "42B");
      expect(complex.ignores[1].secret, null);
      expect(complex.listInnerMap["test"], [ "123456"]);

      expect(complex.numSet, { "numA": 1, "numB": 12.2});
      expect(complex.stringSet, { "strA": "1", "strB": "3"});
      expect(complex.boolSet, { "ok": true, "nok": false});
      expect(complex.intSet, { "intA": 1, "intB": 12});
      expect(complex.doubleSet, { "dblA": 1.0, "dblB": 12.0});
      expect(complex.dateSet, { "fiesta": new DateTime(2016, 12, 24), "christmas": new DateTime(2016, 12, 25)});
      expect(complex.ignoreSet["A"].a, "1337A");
      expect(complex.ignoreSet["A"].b, "42A");
      expect(complex.ignoreSet["A"].secret, null);
      expect(complex.ignoreSet["B"].a, "1337B");
      expect(complex.ignoreSet["B"].b, "42B");
      expect(complex.ignoreSet["B"].secret, null);
    });
  });
}
