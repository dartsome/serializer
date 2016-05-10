// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library serializer.example;

import 'package:serializer/serializer.dart';

@serializable
class ModelA {
  String name;
  num age;

  ModelA([this.name, this.age]);
}

@serializable
class ModelB extends Serialize {
  String city, country;

  ModelB([this.city, this.country]);
}

@serializable
class ModelC extends Serialize {
  String name, password;

  @ignore
  int age;

  ModelC([this.name, this.password, this.age]);
}

main() async {
  await initSerializer();

  ModelA a = new ModelA("toto", 15);
  ModelB b = new ModelB("Paris", "France");
  ModelC c = new ModelC("Alice", "ThereIsNone", 42);

  print(b.toJson());
  print(b.toMap());
  print(c.toJson());

  print(Serializer.toJson(a));
  print(Serializer.toMap(a));

  ModelA A = Serializer.fromJson(Serializer.toJson(a), ModelA);

  print(Serializer.toJson(A));
}
