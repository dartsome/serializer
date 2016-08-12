// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:serializer/serializer.dart';

final _jsonSerializer = new Serializer.Json();
final _typedDsonSerializer = new Serializer.TypedJson();

@serializable
class DoubleSimple extends JsonObject {
  double test = 1.1;

  DoubleSimple();
  factory DoubleSimple.fromJson(String json) => _jsonSerializer.decode(json, type: DoubleSimple);
  factory DoubleSimple.fromMap(Map map) => _jsonSerializer.fromMap(map, type: DoubleSimple);
}

@serializable
class DoubleComplex extends JsonObject {
  Map<String, double> map = {"foo": 1.1};
  List<double> list = [1.1, 2.2, 3.3];

  DoubleComplex();
  factory DoubleComplex.fromJson(String json) => _typedDsonSerializer.decode(json, type: DoubleComplex);
  factory DoubleComplex.fromMap(Map map) => _typedDsonSerializer.fromMap(map, type: DoubleComplex);
}

main() {
  DoubleSimple simple = new DoubleSimple();
  DoubleComplex complex = new DoubleComplex();

  Map outputSimpleMap = simple.toMap();
  Map outputComplexMap = complex.toMap();

  String outputSimpleJson = simple.toJson();
  String outputComplexJson = complex.toJson();

  test("Serialize simple Json", () {
    expect(outputSimpleJson, '{"test":1.1}');
  });

  test("Serialize complex Json", () {
    expect(outputComplexJson, '{"map":{"foo":1.1},"list":[1.1,2.2,3.3]}');
  });

  test("Serialize simple Map", () {
    expect(outputSimpleMap, {"test": 1.1});
  });

  test("Serialize complex Map", () {
    expect(outputComplexMap["map"], {"foo":1.1});
    expect(outputComplexMap["list"], [1.1,2.2,3.3]);
  });

  test("Deserialize simple Json", () {
    DoubleSimple _simple = new DoubleSimple.fromJson(outputSimpleJson);
    expect(_simple.test, 1.1);
  });

  test("Deserialize complex Json", () {
    DoubleComplex _complex = new DoubleComplex.fromJson(outputComplexJson);
    expect(_complex.map, {"foo": 1.1});
    expect(_complex.list, [1.1, 2.2, 3.3]);
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
}
