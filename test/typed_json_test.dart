// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:serializer/codecs.dart';
import 'package:serializer/serializer.dart';


abstract class TypedDontWantToBeSerialize {
  String foo = "bar";
}

@serializable
abstract class TypedProxy extends TypedJsonObject {}

abstract class TypedProxyA extends TypedProxy {}

@serializable
class TypedModelInt extends TypedProxyA {
  int _bar;


  int get bar => _bar;
  set bar(int value) => _bar = value;

  TypedModelInt([this._bar = 42]);
}

@serializable
class TypedModelA extends TypedProxyA {
  String _foo;


  String get foo => _foo;
  set foo(String value) => _foo = value;

  TypedModelA([this._foo = "bar"]);
}

class Test {
  String toto = "tata";
}

@serializable
class TypedModelB extends TypedProxyA {
  Test foo = new Test();
  String toto = "tata";
}

@serializable
class TypedModelC extends TypedProxyA {
  TypedModelA foo = new TypedModelA();
  String plop = "titi";
}

@serializable
class TypedModelD extends TypedProxyA {
  List<TypedModelA> tests;

  TypedModelD([this.tests]);
}

@serializable
class TypedModelE extends TypedProxyA {
  List<String> tests;

  TypedModelE([this.tests]);
}

@serializable
class TypedModelRenamed extends TypedModelE {
  @SerializedName("new")
  String original;

  TypedModelRenamed([this.original]);
}

@serializable
class TypedWithIgnore extends TypedProxyA {
  String a;
  String b;
  @ignore
  String secret;

  TypedWithIgnore([this.a, this.b, this.secret]);
}

Serializer _dateSerializer = new Serializer.typedJson()
    ..addTypeCodec(DateTime, new DateTimeCodec());
@serializable
class TypedDate extends TypedProxyA {
  DateTime date = new DateTime.now();

  @ignore
  Serializer get serializer => _dateSerializer;

  TypedDate([this.date]);
}

@serializable
class TypedTestMaxSuperClass extends TypedDontWantToBeSerialize {
  String serialize = "okay";
}

@serializable
class TypedComplex extends TypedProxyA {
  List<num>        nums;
  List<String>     strings;
  List<bool>       bools;
  List<int>        ints;
  List<double>     doubles;
  List<DateTime>   dates;
  List<TypedWithIgnore> ignores;
  Map<String, num>        numSet;
  Map<String, String>     stringSet;
  Map<String, bool>       boolSet;
  Map<String, int>        intSet;
  Map<String, double>     doubleSet;
  Map<String, DateTime>   dateSet;
  Map<String, TypedWithIgnore> ignoreSet;
  Map<String, List>       listInnerMap;
}

@serializable
class Mixin extends TypedProxyA with M1, M2 {
  String a;
  String b;
}

@serializable
class M1 {
  String m1;
}

@serializable
class M2 {
  String m2;
}

@referenceable
@serializable
class Employee {
  @reference
  int id;
  String name;
  Address address;
  Employee manager;
}

@referenceable
@serializable
class Address {
  @reference
  int id;
  String location;
  Employee owner;
}

@serializable
class Pet {
  String  name;
  dynamic animal;
}

@serializable
abstract class Animal {}

@serializable
class Dog extends Animal {
  String name;
  bool bark;
}

@serializable
class Cat extends Animal {
  String name;
  bool mew;
}

@serializable
class PetWithTypeInfo {
  String name;
  @serializedWithTypeInfo
  Animal animal;
}

main() {
  var serializer = new Serializer.typedJson()
      ..addTypeCodec(DateTime, new DateTimeCodec());

  group("Serialize", () {
    test("simple test", () {
      TypedModelA a = new TypedModelA("toto");

      expect('{@type: TypedModelA, foo: toto}', a.toString());
      expect('{"@type":"TypedModelA","foo":"toto"}', a.toJson());
      expect({"@type": "TypedModelA", "foo": "toto"}, a.toMap());
    });

    test("Map to Map", () {
      Map a = {"test": "toto", "titi": new TypedModelA()};
      String json = serializer.encode(a);
      expect('{"test":"toto","titi":{"@type":"TypedModelA","foo":"bar"}}', json);
    });

    test("list", () {
      List<TypedModelA> list = [new TypedModelA("toto"), new TypedModelA()];

      String json = serializer.encode(list);
      expect(
          '[{"@type":"TypedModelA","foo":"toto"},{"@type":"TypedModelA","foo":"bar"}]',
          json);
    });

    test("inner list 1", () {
      List<TypedModelA> list = [new TypedModelA("toto"), new TypedModelA()];
      TypedModelD test = new TypedModelD(list);
      String json = test.toJson();

      expect(
          '{"@type":"TypedModelD","tests":[{"@type":"TypedModelA","foo":"toto"},{"@type":"TypedModelA","foo":"bar"}]}',
          json);
    });

    test("inner list 2", () {
      TypedModelE e = new TypedModelE(["toto","bar"]);

      expect('{"@type":"TypedModelE","tests":["toto","bar"]}', e.toJson());
    });

    test("inner class non-serializable", () {
      TypedModelB b = new TypedModelB();
      expect('{"@type":"TypedModelB","toto":"tata"}', b.toJson());
      expect({"@type": "TypedModelB", "toto": "tata"}, b.toMap());
    });

    test("inner class serializable", () {
      TypedModelC c = new TypedModelC();
      expect(
          '{"@type":"TypedModelC","foo":{"@type":"TypedModelA","foo":"bar"},"plop":"titi"}',
          c.toJson());
      expect({
        "@type": "TypedModelC",
        "foo": {"@type": "TypedModelA", "foo": "bar"},
        "plop": "titi"
      }, c.toMap());
    });

    test("list class non-serializable", () {
      List list = [new TypedModelB(), new TypedModelB()];
      String json = serializer.encode(list);
      expect(
          '[{"@type":"TypedModelB","toto":"tata"},{"@type":"TypedModelB","toto":"tata"}]',
          json);
    });

    test("list inner list", () {
      List listA = [new TypedModelB(), new TypedModelB()];
      List listB = [new TypedModelB(), listA];
      String json = serializer.encode(listB);
      expect(
          '[{"@type":"TypedModelB","toto":"tata"},[{"@type":"TypedModelB","toto":"tata"},{"@type":"TypedModelB","toto":"tata"}]]',
          json);
    });

    test("list class serializable", () {
      List list = [new TypedModelC(), new TypedModelC()];
      String json = serializer.encode(list);
      expect(
          '[{"@type":"TypedModelC","foo":{"@type":"TypedModelA","foo":"bar"},"plop":"titi"},{"@type":"TypedModelC","foo":{"@type":"TypedModelA","foo":"bar"},"plop":"titi"}]',
          json);
    });

    test("Datetime", () {
      TypedDate date = new TypedDate(new DateTime(2016, 1, 1));
      expect({"@type": "TypedDate", "date": "2016-01-01T00:00:00.000"},
          date.toMap());
      expect('{"@type":"TypedDate","date":"2016-01-01T00:00:00.000"}',
          date.toJson());
    });

    test("Max Superclass", () {
      TypedTestMaxSuperClass _test = new TypedTestMaxSuperClass();
      expect(
          '{"@type":"TypedTestMaxSuperClass","serialize":"okay"}',
          serializer.encode(_test));
      expect({"@type":"TypedTestMaxSuperClass", "serialize":"okay"}, serializer.toMap(_test));
    });

    test("Ignore attribute", () {
      TypedWithIgnore _ignore = new TypedWithIgnore("1337", "42", "ThisIsASecret");
      expect(
          '{"@type":"TypedWithIgnore","a":"1337","b":"42"}',
          serializer.encode(_ignore));
      expect({"@type": "TypedWithIgnore", "a":"1337","b":"42"}, serializer.toMap(_ignore));
    });

    test("Serialized name", () {
      TypedModelRenamed _model = new TypedModelRenamed("Hello")
          ..tests = ["A", "B", "C"];
      expect('{"@type":"TypedModelRenamed","new":"Hello","tests":["A","B","C"]}', serializer.encode(_model));
      expect({"@type":"TypedModelRenamed", "new":"Hello","tests":["A","B","C"]}, serializer.toMap(_model));
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
      expect('{"@type":"Pet","name":"Pet","animal":{"@type":"Cat","name":"Felix","mew":false}}', serializer.encode(pet));

      pet = new Pet()
        ..name = "Pet"
        ..animal = dog;
      expect('{"@type":"Pet","name":"Pet","animal":{"@type":"Dog","name":"Medor","bark":true}}', serializer.encode(pet));
    });

    test("with typeInfo", () {
      Cat cat = new Cat()
        ..name = "Felix"
        ..mew  = false;
      Dog dog = new Dog()
        ..name = "Medor"
        ..bark = true;
      PetWithTypeInfo pet;

      pet = new PetWithTypeInfo()
        ..name = "Pet"
        ..animal = cat;
      expect('{"@type":"PetWithTypeInfo","name":"Pet","animal":{"@type":"Cat","name":"Felix","mew":false}}', serializer.encode(pet));

      pet = new PetWithTypeInfo()
        ..name = "Pet"
        ..animal = dog;
      expect('{"@type":"PetWithTypeInfo","name":"Pet","animal":{"@type":"Dog","name":"Medor","bark":true}}', serializer.encode(pet));
    });
  });

  group("Deserialize", () {
    test("simple test - fromJson", () {
      TypedModelA a =
      serializer.decode('{"@type":"TypedModelA","foo":"toto"}');

      expect(TypedModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("simple test - fromMap - without type field", () {
      TypedModelA a =
      serializer.fromMap({"foo": "toto"}, type: TypedModelA);

      expect(TypedModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("simple test - fromMap", () {
      TypedModelA a =
      serializer.fromMap({"@type": "TypedModelA", "foo": "toto"});

      expect(TypedModelA, a.runtimeType);
      expect("toto", a.foo);
    });

    test("Map fromMap Map", () {
      Map a = {"titi": new TypedModelA().toMap(), "foo": "bar"};
      Map b = serializer.fromMap(a);

      expect(TypedModelA, b["titi"].runtimeType);
      expect("bar", b["titi"].foo);
      expect("bar", b["foo"]);
    });

    test("list - fromJson", () {
      List<TypedModelA> list = serializer.decode(
          '[{"@type":"TypedModelA","foo":"toto"},{"@type":"TypedModelA","foo":"bar"}]') as List<TypedModelA>;

      expect(2, list.length);
      expect("toto", list[0]?.foo);
      expect("bar", list[1]?.foo);

      expect(TypedModelA, list[0]?.runtimeType);
      expect(TypedModelA, list[1]?.runtimeType);
    });

    test("list - fromList", () {
      List list = serializer.fromList(
          [{"@type":"TypedModelA","foo":"toto"},{"@type":"TypedModelA","foo":"bar"}]);

      expect(2, list.length);
      expect("toto", list[0]?.foo);
      expect("bar", list[1]?.foo);

      expect(TypedModelA, list[0]?.runtimeType);
      expect(TypedModelA, list[1]?.runtimeType);
    });

    test("inner list 1", () {
      TypedModelD test = serializer.decode(
          '{"@type":"TypedModelD","tests":[{"@type":"TypedModelA","foo":"toto"},{"@type":"TypedModelA","foo":"bar"}]}');

      expect(2, test?.tests?.length);
      expect(TypedModelA, test?.tests[0]?.runtimeType);
      expect(TypedModelA, test?.tests[1]?.runtimeType);
      expect("toto", test?.tests[0]?.foo);
      expect("bar", test?.tests[1]?.foo);
    });

    test("inner list 2", () {
      TypedModelE test = serializer.decode(
          '{"@type":"TypedModelE","tests":["toto","bar"]}');

      expect(2, test?.tests?.length);
      expect("toto", test?.tests[0]);
      expect("bar", test?.tests[1]);
    });

    test("inner class non-serializable", () {
      TypedModelB b = serializer.decode(
          '{"@type":"TypedModelB","toto":"tata","foo":{"@type":"TypedModelA","toto":"tata"}}');

      expect("tata", b.foo.toto);
    });

    test("inner class serializable", () {
      TypedModelC c = serializer.decode(
          '{"@type":"TypedModelC","foo":{"@type":"TypedModelA","foo":"toto"},"plop":"bar"}');
      expect(TypedModelA, c.foo.runtimeType);
      expect("toto", c.foo.foo);
      expect("bar", c.plop);
    });

    test("Datetime", () {
      TypedDate date = serializer.decode(
          '{"@type":"TypedDate","date":"2016-01-01T00:00:00.000"}');

      expect("2016-01-01T00:00:00.000", date.date.toIso8601String());
      expect('{"@type":"TypedDate","date":"2016-01-01T00:00:00.000"}',
          date.toJson());
    });

    test("Max Superclass", () {
      TypedTestMaxSuperClass _test = serializer.decode(
          '{"@type":"TypedTestMaxSuperClass","serialize":"okay","foo":"nobar"}');

      expect("okay", _test.serialize);
      expect("bar", _test.foo);
    });

    test("Ignore attribute", () {
      TypedWithIgnore _ignore = serializer.decode(
          '{"@type":"TypedWithIgnore","a":"1337","b":"42","secret":"ignore"}');

      expect("1337", _ignore.a);
      expect("42", _ignore.b);
      expect(null, _ignore.secret);
    });

    test("Serialized name", () {
      TypedModelRenamed _model = serializer.decode(
          '{"@type":"TypedModelRenamed","new":"Hello","tests":["A","B","C"]}');

      expect("Hello", _model.original);
      expect(["A","B","C"], _model.tests);
    });

    test("Test reflectable error", () {
      try {
        TypedDontWantToBeSerialize _ = serializer.decode('{"@type":"TypedDontWantToBeSerialize","foo":"bar"}');
      } catch (e) {
        expect(true, e is String);
        // expect("Cannot instantiate abstract class DontWantToBeSerialize: _url 'null' line null", e);
      }
    });

    test("dynamic", () {
      Pet pet;

      pet = serializer.decode('{"@type":"Pet","name":"Pet","animal":{"@type":"Cat","name":"Felix","mew":false}}');
      expect(pet.name, "Pet");
      expect(pet.animal is Cat, isTrue);
      var cat = pet.animal as Cat;
      expect(cat.name, "Felix");
      expect(cat.mew, false);

      pet = serializer.decode('{"@type":"Pet","name":"Pet","animal":{"@type":"Dog","name":"Medor","bark":true}}');
      expect(pet.name, "Pet");
      expect(pet.animal is Dog, isTrue);
      var dog = pet.animal as Dog;
      expect(dog.name, "Medor");
      expect(dog.bark, true);
    });

    test("with typeInfo", () {
      PetWithTypeInfo pet;

      pet = serializer.decode('{"@type":"PetWithTypeInfo","name":"Pet","animal":{"@type":"Cat","name":"Felix","mew":false}}');
      expect(pet.name, "Pet");
      expect(pet.animal is Cat, isTrue);
      var cat = pet.animal as Cat;
      expect(cat.name, "Felix");
      expect(cat.mew, false);

      pet = serializer.decode('{"@type":"PetWithTypeInfo","name":"Pet","animal":{"@type":"Dog","name":"Medor","bark":true}}');
      expect(pet.name, "Pet");
      expect(pet.animal is Dog, isTrue);
      var dog = pet.animal as Dog;
      expect(dog.name, "Medor");
      expect(dog.bark, true);
    });
  });

  group("Complex", () {
    test("Serialize", () {
      var complex = new TypedComplex()
          ..nums     = [ 1, 2.2, 3 ]
          ..strings  = [ "1", "2", "3" ]
          ..bools    = [ true, false, true ]
          ..ints     = [ 1, 2, 3 ]
          ..doubles  = [ 1.1, 2.2, 3.3 ]
          ..dates    = [ new DateTime(2016,12,24), new DateTime(2016,12,25), new DateTime(2016,12,26)]
          ..ignores  = [ new TypedWithIgnore("1337A", "42A", "ThisIsASecretA"), new TypedWithIgnore("1337B", "42B", "ThisIsASecretB") ]
          ..numSet     = { "numA": 1, "numB": 12.2 }
          ..stringSet  = { "strA": "1", "strB": "3" }
          ..boolSet    = { "ok": true, "nok": false }
          ..intSet     = { "intA": 1, "intB": 12 }
          ..doubleSet  = { "dblA": 1.1, "dblB": 12.1 }
          ..dateSet    = { "fiesta": new DateTime(2016,12,24), "christmas": new DateTime(2016,12,25) }
          ..ignoreSet  = { "A": new TypedWithIgnore("1337A", "42A", "ThisIsASecretA"), "B": new TypedWithIgnore("1337B", "42B", "ThisIsASecretB") }
          ..listInnerMap = { "test": ["123456"] };
      var json = serializer.encode(complex);
      expect(json, '{"@type":"TypedComplex","nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"@type":"TypedWithIgnore","a":"1337A","b":"42A"},{"@type":"TypedWithIgnore","a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"@type":"TypedWithIgnore","a":"1337A","b":"42A"},"B":{"@type":"TypedWithIgnore","a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');

      var noTypedJson;
      noTypedJson = serializer.encode(complex, useTypeInfo: true);
      expect(noTypedJson,
          '{"@type":"TypedComplex","nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"@type":"TypedWithIgnore","a":"1337A","b":"42A"},{"@type":"TypedWithIgnore","a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"@type":"TypedWithIgnore","a":"1337A","b":"42A"},"B":{"@type":"TypedWithIgnore","a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');
      noTypedJson = serializer.encode(complex, useTypeInfo: false);
      expect(noTypedJson,
          '{"nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"a":"1337A","b":"42A"},{"a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"a":"1337A","b":"42A"},"B":{"a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');

      var jsonWithType = serializer.encode(complex, withTypeInfo: false);
      expect(jsonWithType,
          '{"@type":"TypedComplex","nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"@type":"TypedWithIgnore","a":"1337A","b":"42A"},{"@type":"TypedWithIgnore","a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"@type":"TypedWithIgnore","a":"1337A","b":"42A"},"B":{"@type":"TypedWithIgnore","a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');
      jsonWithType = serializer.encode(complex, withTypeInfo: true);
      expect(jsonWithType,
          '{"@type":"TypedComplex","nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"@type":"TypedWithIgnore","a":"1337A","b":"42A"},{"@type":"TypedWithIgnore","a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.1,"dblB":12.1},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"@type":"TypedWithIgnore","a":"1337A","b":"42A"},"B":{"@type":"TypedWithIgnore","a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}');
    });

    test("Deserialize", () {
      checkComplex(TypedComplex complex) {
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
      }

      TypedComplex complex = serializer.decode('{"@type":"TypedComplex","listInnerMap":{"test":["123456"]},"nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"@type":"TypedWithIgnore","a":"1337A","b":"42A"},{"@type":"TypedWithIgnore","a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1,"dblB":12},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"@type":"TypedWithIgnore","a":"1337A","b":"42A"},"B":{"@type":"TypedWithIgnore","a":"1337B","b":"42B"}}}');
      checkComplex(complex);

      TypedComplex noTypedComplex = serializer.decode(
          '{"nums":[1,2.2,3],"strings":["1","2","3"],"bools":[true,false,true],"ints":[1,2,3],"doubles":[1.1,2.2,3.3],"dates":["2016-12-24T00:00:00.000","2016-12-25T00:00:00.000","2016-12-26T00:00:00.000"],"ignores":[{"a":"1337A","b":"42A"},{"a":"1337B","b":"42B"}],"numSet":{"numA":1,"numB":12.2},"stringSet":{"strA":"1","strB":"3"},"boolSet":{"ok":true,"nok":false},"intSet":{"intA":1,"intB":12},"doubleSet":{"dblA":1.0,"dblB":12.0},"dateSet":{"fiesta":"2016-12-24T00:00:00.000","christmas":"2016-12-25T00:00:00.000"},"ignoreSet":{"A":{"a":"1337A","b":"42A"},"B":{"a":"1337B","b":"42B"}},"listInnerMap":{"test":["123456"]}}',
          type: TypedComplex,
          useTypeInfo: false);
      checkComplex(noTypedComplex);
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
      expect(json, '{"@type":"Mixin","a":"A","b":"B","m2":"M2","m1":"M1"}');
    });

    test("Deserialize", () {
      Mixin mixin = serializer.decode(
          '{"@type":"Mixin","a":"A","b":"B","m2":"M2","m1":"M1"}');

      expect(mixin.a, "A");
      expect(mixin.b, "B");
      expect(mixin.m1, "M1");
      expect(mixin.m2, "M2");
    });
  });

  group("Referenceable", () {
    test("Serialize", () {
      Address addressManager = new Address()
        ..id       = 1337
        ..location = "Somewhere";

      Address addressEmployee = new Address()
        ..id       = 1338
        ..location = "Somewhere else";

      Employee manager = new Employee()
        ..id      = 43
        ..name    = "Alice Doo"
        ..address = addressManager;
      addressManager.owner = manager;

      Employee employee = new Employee()
        ..id      = 42
        ..name    = "Bob Smith"
        ..address = addressEmployee
        ..manager = manager;
      addressEmployee.owner = employee;

      expect(serializer.encode(addressManager),  '{"@type":"Address","id":1337,"location":"Somewhere","owner":{"@type":"Employee","id":43}}');
      expect(serializer.encode(addressEmployee), '{"@type":"Address","id":1338,"location":"Somewhere else","owner":{"@type":"Employee","id":42}}');
      expect(serializer.encode(manager),         '{"@type":"Employee","id":43,"name":"Alice Doo","address":{"@type":"Address","id":1337}}');
      expect(serializer.encode(employee),        '{"@type":"Employee","id":42,"name":"Bob Smith","address":{"@type":"Address","id":1338},"manager":{"@type":"Employee","id":43}}');
    });
  });
}
