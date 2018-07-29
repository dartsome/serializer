// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:serializer/serializer.dart';
import 'double_json_test.codec.dart';

Serializer _jsonSerializer;
Serializer _typedJsonSerializer;

@serializable
class DoubleSimple {
  double test = 1.1;

  DoubleSimple();
  factory DoubleSimple.fromJson(String json) => _jsonSerializer.decode(json, type: DoubleSimple) as DoubleSimple;
  factory DoubleSimple.fromMap(Map map) =>
      _jsonSerializer.fromMap(map as Map<String, dynamic>, type: DoubleSimple) as DoubleSimple;
}

@serializable
class DoubleComplex {
  Map<String, double> map = {"foo": 1.1};
  List<double> list = [1.1, 2.2, 3.3];

  DoubleComplex();
  factory DoubleComplex.fromJson(String json) =>
      _typedJsonSerializer.decode(json, type: DoubleComplex) as DoubleComplex;
  factory DoubleComplex.fromMap(Map map) => _typedJsonSerializer.fromMap(map, type: DoubleComplex) as DoubleComplex;
}

main() {
  DoubleSimple simple;
  DoubleComplex complex;

  Map outputSimpleMap;
  Map outputComplexMap;

  String outputSimpleJson;
  String outputComplexJson;

  setUpAll(() {
    _jsonSerializer = new Serializer.json()..addAllTypeCodecs(test_double_json_test_codecs);
    _typedJsonSerializer = new Serializer.typedJson()..addAllTypeCodecs(test_double_json_test_codecs);

    simple = new DoubleSimple();
    complex = new DoubleComplex();

    outputSimpleMap = _jsonSerializer.toMap(simple);
    outputComplexMap = _jsonSerializer.toMap(complex);

    outputSimpleJson = _jsonSerializer.encode(simple);
    outputComplexJson = _jsonSerializer.encode(complex);
  });

  test("Serialize simple Json", () {
    expect(outputSimpleJson, '{"test":1.1}');
  });

  test("Serialize simple Json with int", () {
    var simple = new DoubleSimple()..test = 1.toDouble();
    var output = _jsonSerializer.encode(simple);
    expect(output, '{"test":1}');
  }, skip: true);

  test("Serialize complex Json", () {
    expect(outputComplexJson, '{"map":{"foo":1.1},"list":[1.1,2.2,3.3]}');
  });

  test("Serialize simple Map", () {
    expect(outputSimpleMap, {"test": 1.1});
  });

  test("Serialize simple Map with int", () {
    var simple = new DoubleSimple()..test = 1.toDouble();
    var output = _jsonSerializer.toMap(simple);
    expect(output, {"test": 1});
  }, skip: true);

  test("Serialize complex Map", () {
    expect(outputComplexMap["map"], {"foo": 1.1});
    expect(outputComplexMap["list"], [1.1, 2.2, 3.3]);
  });

  test("Serialize complex Map with int", () {
    var complex = new DoubleComplex()
      ..list = [1.0, 2.0, 3.0]
      ..map = {"foo": 1.0};
    var output = _jsonSerializer.toMap(complex);
    expect(output["map"], {"foo": 1});
    expect(output["list"], [1, 2, 3]);
  });

  test("Deserialize simple Json", () {
    DoubleSimple _simple = new DoubleSimple.fromJson(outputSimpleJson);
    expect(_simple.test, 1.1);
  });

  test("Deserialize simple Json with int", () {
    DoubleSimple output = _jsonSerializer.decode('{"test":1}', type: DoubleSimple);
    expect(output.test, 1);
  });

  test("Deserialize complex Json", () {
    DoubleComplex _complex = new DoubleComplex.fromJson(outputComplexJson);
    expect(_complex.map, {"foo": 1.1});
    expect(_complex.list, [1.1, 2.2, 3.3]);
  });

  test("Deserialize complex Json with int", () {
    DoubleComplex _complex = _jsonSerializer.decode('{"map":{"foo":1},"list":[1,2,3]}', type: DoubleComplex);
    expect(_complex.map, {"foo": 1});
    expect(_complex.list, [1, 2, 3]);
  });

  test("Deserialize simple Map", () {
    DoubleSimple _simple = new DoubleSimple.fromMap(outputSimpleMap);
    expect(_simple.test, 1.1);
  });

  test("Deserialize complex Map", () {
    DoubleComplex _complex = new DoubleComplex.fromMap(outputComplexMap);
    expect(_complex.map, {"foo": 1.1});
    expect(_complex.list, [1.1, 2.2, 3.3]);
  });

  test("Deserialize complex Map with int", () {
    DoubleComplex _complex = new DoubleComplex.fromMap({
      "map": {"foo": 1},
      "list": [1, 2, 3]
    });
    expect(_complex.map, {"foo": 1});
    expect(_complex.list, [1, 2, 3]);
  });
}
