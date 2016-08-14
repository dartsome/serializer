// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library serializer.example;

import 'package:serializer/serializer.dart';

@serializable
class ModelA {
  @Id()
  int id;

  String name;
  num age;

  ModelA([this.id, this.name, this.age]);
}

@serializable
class ModelB extends JsonObject {
  String city, country;

  ModelB([this.city, this.country]);
}

@serializable
class ModelC extends JsonObject {
  String name, password;

  @ignore
  int age;

  ModelC([this.name, this.password, this.age]);
}

class Id extends SerializedName {
  const Id(): super("_id");
}

main() {
  ModelA a = new ModelA(42, "toto", 15);
  ModelB b = new ModelB("Paris", "France");
  ModelC c = new ModelC("Alice", "ThereIsNone", 42);

  print(b.toJson());
  print(b.toMap());
  print(c.toJson());

  var sz = new Serializer.typedJson();
  print(sz.toMap(a));
  print(sz.encode(a));

  ModelA A = sz.decode(sz.encode(a));
  print(sz.encode(A));
}
