/**
 * Created by lejard_h on 04/01/16.
 */

library serializer.test;

import "package:test/test.dart";
import "package:serializer/serializer.dart";

class TestApi extends Serializer {

}

abstract class DontWantToBeSerialize {
  String foo = "bar";
}

@serializable
abstract class Proxy extends Serialize {}

abstract class ProxyA extends Proxy {}

@serializable
class ModelInt extends ProxyA {
  int _bar;


  int get bar => _bar;
  set bar(int value) => _bar = value;

  ModelInt([this._bar = 42]);
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
  List<num>        nums;
  List<String>     strings;
  List<bool>       bools;
  List<int>        ints;
  List<double>     doubles;
  List<DateTime>   dates;
  List<WithIgnore> ignores;
  Map<String, num>        numSet;
  Map<String, String>     stringSet;
  Map<String, bool>       boolSet;
  Map<String, int>        intSet;
  Map<String, double>     doubleSet;
  Map<String, DateTime>   dateSet;
  Map<String, WithIgnore> ignoreSet;
  Map<String, List> listInnerMap;
}

main() {
  initSerializer(type_info_key: "@dart_type");

  test("Test Api Serializer", () {
    TestApi api = new TestApi();
    expect(true, api is Serializer);
  });

  group("Serialize", () {
    test("simple test", () {
      ModelA a = new ModelA("toto");

      expect("{@dart_type: ModelA, foo: toto}", a.toString());
      expect('{"@dart_type":"ModelA","foo":"toto"}', a.toJson());
      expect({"@dart_type": "ModelA", "foo": "toto"}, a.toMap());
    });

    test("Map to Map", () {
      Map a = {"test": "toto", "titi": new ModelA()};
      String json = Serializer.toJson(a);
      expect('{"test":"toto","titi":{"@dart_type":"ModelA","foo":"bar"}}', json);
    });

    test("list", () {
      List<ModelA> list = [new ModelA("toto"), new ModelA()];

      String json = Serializer.toJson(list);
      expect(
          '[{"@dart_type":"ModelA","foo":"toto"},{"@dart_type":"ModelA","foo":"bar"}]',
          json);
    });

    test("inner list 1", () {
      List<ModelA> list = [new ModelA("toto"), new ModelA()];
      ModelD test = new ModelD(list);
      String json = test.toJson();

      expect(
          '{"@dart_type":"ModelD","tests":[{"@dart_type":"ModelA","foo":"toto"},{"@dart_type":"ModelA","foo":"bar"}]}',
          json);
    });

    test("inner list 2", () {
      ModelE e = new ModelE(["toto","bar"]);

      expect('{"@dart_type":"ModelE","tests":["toto","bar"]}', e.toJson());
    });

    test("inner class non-serializable", () {
      ModelB b = new ModelB();
      expect('{"@dart_type":"ModelB","toto":"tata"}', b.toJson());
      expect({"@dart_type": "ModelB", "toto": "tata"}, b.toMap());
    });

    test("inner class serializable", () {
      ModelC c = new ModelC();
      expect(
          '{"@dart_type":"ModelC","foo":{"@dart_type":"ModelA","foo":"bar"},"plop":"titi"}',
          c.toJson());
      expect({
        "@dart_type": "ModelC",
        "foo": {"@dart_type": "ModelA", "foo": "bar"},
        "plop": "titi"
      }, c.toMap());
    });

    test("list class non-serializable", () {
      List list = [new ModelB(), new ModelB()];
      String json = Serializer.toJson(list);
      expect(
          '[{"@dart_type":"ModelB","toto":"tata"},{"@dart_type":"ModelB","toto":"tata"}]',
          json);
    });

    test("list inner list", () {
      List listA = [new ModelB(), new ModelB()];
      List listB = [new ModelB(), listA];
      String json = Serializer.toJson(listB);
      expect(
          '[{"@dart_type":"ModelB","toto":"tata"},[{"@dart_type":"ModelB","toto":"tata"},{"@dart_type":"ModelB","toto":"tata"}]]',
          json);
    });

    test("list class serializable", () {
      List list = [new ModelC(), new ModelC()];
      String json = Serializer.toJson(list);
      expect(
          '[{"@dart_type":"ModelC","foo":{"@dart_type":"ModelA","foo":"bar"},"plop":"titi"},{"@dart_type":"ModelC","foo":{"@dart_type":"ModelA","foo":"bar"},"plop":"titi"}]',
          json);
    });

    test("Datetime", () {
      Date date = new Date(new DateTime(2016, 1, 1));
      expect({"@dart_type": "Date", "date": "2016-01-01T00:00:00.000"},
          date.toMap());
      expect('{"@dart_type":"Date","date":"2016-01-01T00:00:00.000"}',
          date.toJson());
    });

    test("Max Superclass", () {
      TestMaxSuperClass _test = new TestMaxSuperClass();
      expect(
          '{"@dart_type":"TestMaxSuperClass","serialize":"okay"}',
          Serializer.toJson(_test));
      expect({"@dart_type":"TestMaxSuperClass","serialize":"okay"}, Serializer.toMap(_test));
    });

    test("Ignore attribute", () {
      WithIgnore _ignore = new WithIgnore("1337", "42", "ThisIsASecret");
      expect(
          '{"@dart_type":"WithIgnore","a":"1337","b":"42"}',
          Serializer.toJson(_ignore));
      expect({"@dart_type":"WithIgnore","a":"1337","b":"42"}, Serializer.toMap(_ignore));
    });
  });

  group("Deserialize", () {
    test("simple test - fromJson", () {
      ModelA a =
      Serializer.fromJson('{"@dart_type":"ModelA","foo":"toto"}');

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("simple test - fromMap - without type field", () {
      ModelA a =
      Serializer.fromMap({"foo": "toto"}, ModelA);

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("simple test - fromMap", () {
      ModelA a =
      Serializer.fromMap({"@dart_type": "ModelA", "foo": "toto"});

      expect(ModelA, a.runtimeType);
      expect("toto", a.foo);
    });



    test("Map fromMap Map", () {
      Map a = {"test": "toto", "titi": new ModelA()};
      Map b = Serializer.fromMap(a);

      expect(a["test"], b["test"]);
      expect(ModelA, b["titi"].runtimeType);
      expect("bar", b["titi"].foo);
    });

    test("list - fromJson", () {
      List list = Serializer.fromJson(
          '[{"@dart_type":"ModelA","foo":"toto"},{"@dart_type":"ModelA","foo":"bar"}]');

      expect(2, list.length);
      expect("toto", list[0]?.foo);
      expect("bar", list[1]?.foo);

      expect(ModelA, list[0]?.runtimeType);
      expect(ModelA, list[1]?.runtimeType);
    });

    test("list - fromList", () {
      List list = Serializer.fromList(
          [{"@dart_type":"ModelA","foo":"toto"},{"@dart_type":"ModelA","foo":"bar"}],
          ModelA);

      expect(2, list.length);
      expect("toto", list[0]?.foo);
      expect("bar", list[1]?.foo);

      expect(ModelA, list[0]?.runtimeType);
      expect(ModelA, list[1]?.runtimeType);
    });

    test("inner list 1", () {
      ModelD test = Serializer.fromJson(
          '{"@dart_type":"ModelD","tests":[{"@dart_type":"ModelA","foo":"toto"},{"@dart_type":"ModelA","foo":"bar"}]}');

      expect(2, test?.tests?.length);
      expect(ModelA, test?.tests[0]?.runtimeType);
      expect(ModelA, test?.tests[1]?.runtimeType);
      expect("toto", test?.tests[0]?.foo);
      expect("bar", test?.tests[1]?.foo);
    });

    test("inner list 2", () {
      ModelE test = Serializer.fromJson(
          '{"@dart_type": "ModelE", "tests":["toto","bar"]}');

      expect(2, test?.tests?.length);
      expect("toto", test?.tests[0]);
      expect("bar", test?.tests[1]);
    });

    test("inner class non-serializable", () {
      ModelB b = Serializer.fromJson(
          '{"@dart_type":"ModelB","toto":"tata","foo":{"toto":"tata"}}');

      expect("tata", b.foo.toto);
    });

    test("inner class serializable", () {
      ModelC c = Serializer.fromJson(
          '{"@dart_type":"ModelC","foo":{"@dart_type":"ModelA","foo":"toto"},"plop":"bar"}');
      expect(ModelA, c.foo.runtimeType);
      expect("toto", c.foo.foo);
      expect("bar", c.plop);
    });

    test("Datetime", () {
      Date date = Serializer.fromJson(
          '{"@dart_type":"Date","date":"2016-01-01T00:00:00.000"}');

      expect("2016-01-01T00:00:00.000", date.date.toIso8601String());
      expect('{"@dart_type":"Date","date":"2016-01-01T00:00:00.000"}',
          date.toJson());
    });

    test("Max Superclass", () {
      TestMaxSuperClass _test = Serializer.fromJson(
          '{"@dart_type":"TestMaxSuperClass","serialize":"okay","foo":"nobar"}');

      expect("okay", _test.serialize);
      expect("bar", _test.foo);
    });

    test("Ignore attribute", () {
      WithIgnore _ignore = Serializer.fromJson(
          '{"@dart_type":"WithIgnore","a":"1337","b":"42","secret":"ignore"}');

      expect("1337", _ignore.a);
      expect("42", _ignore.b);
      expect(null, _ignore.secret);
    });
  });

  group("Complex", () {
    test("Serialize", () {
      var complex = new Complex()
      ..listInnerMap = { "test": ["123456"] }
          ..nums     = [ 1, 2.2, 3 ]
          ..strings  = [ "1", "2", "3" ]
          ..bools    = [ true, false, true ]
          ..ints     = [ 1, 2, 3 ]
          ..doubles  = [ 1.1, 2.2, 3.3 ]
          ..dates    = [ new DateTime(2016,12,24), new DateTime(2016,12,25), new DateTime(2016,12,26)]
          ..ignores  = [ new WithIgnore("1337A", "42A", "ThisIsASecretA"), new WithIgnore("1337B", "42B", "ThisIsASecretB") ]
          ..numSet     = { "numA": 1, "numB": 12.2 }
          ..stringSet  = { "strA": "1", "strB": "3" }
          ..boolSet    = { "ok": true, "nok": false }
          ..intSet     = { "intA": 1, "intB": 12 }
          ..doubleSet  = { "dblA": 1, "dblB": 12 }
          ..dateSet    = { "fiesta": new DateTime(2016,12,24), "christmas": new DateTime(2016,12,25) }
          ..ignoreSet  = { "A": new WithIgnore("1337A", "42A", "ThisIsASecretA"), "B": new WithIgnore("1337B", "42B", "ThisIsASecretB") };
      var json = Serializer.toJson(complex);
      expect(json, '{"@dart_type":"Complex","nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"@dart_type":"WithIgnore","a":"1337A","b":"42A"},{"@dart_type":"WithIgnore","a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1,"dblB":12},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"@dart_type":"WithIgnore","a":"1337A","b":"42A"},"B":{"@dart_type":"WithIgnore","a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');
    });

    test("Deserialize", () {
      Complex complex = Serializer.fromJson('{"@dart_type":"Complex","listInnerMap":{"test":["123456"]},"nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"@dart_type":"WithIgnore","a":"1337A","b":"42A"},{"@dart_type":"WithIgnore","a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1,"dblB":12},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"@dart_type":"WithIgnore","a":"1337A","b":"42A"},"B":{"@dart_type":"WithIgnore","a":"1337B","b":"42B"}}}');

      expect(complex.nums,    [ 1, 2.2, 3 ]);
      expect(complex.strings, [ "1", "2", "3" ]);
      expect(complex.bools,   [ true, false, true ]);
      expect(complex.ints,    [ 1, 2, 3 ]);
      expect(complex.doubles, [ 1.1, 2.2, 3.3 ]);
      expect(complex.dates,   [ new DateTime(2016,12,24), new DateTime(2016,12,25), new DateTime(2016,12,26)]);
      expect(complex.ignores[0].a,      "1337A");
      expect(complex.ignores[0].b,      "42A");
      expect(complex.ignores[0].secret, null);
      expect(complex.ignores[1].a,      "1337B");
      expect(complex.ignores[1].b,      "42B");
      expect(complex.ignores[1].secret, null);
      expect(complex.listInnerMap["test"], [ "123456"]);

      expect(complex.numSet   , { "numA": 1, "numB": 12.2 });
      expect(complex.stringSet, { "strA": "1", "strB": "3" });
      expect(complex.boolSet  , { "ok": true, "nok": false });
      expect(complex.intSet   , { "intA": 1, "intB": 12 });
      expect(complex.doubleSet, { "dblA": 1, "dblB": 12 });
      expect(complex.dateSet  , { "fiesta": new DateTime(2016,12,24), "christmas": new DateTime(2016,12,25) });
      expect(complex.ignoreSet["A"].a,      "1337A");
      expect(complex.ignoreSet["A"].b,      "42A");
      expect(complex.ignoreSet["A"].secret, null);
      expect(complex.ignoreSet["B"].a,      "1337B");
      expect(complex.ignoreSet["B"].b,      "42B");
      expect(complex.ignoreSet["B"].secret, null);
    });
  });
}
