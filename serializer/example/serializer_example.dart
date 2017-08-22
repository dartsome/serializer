// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library serializer.example;

import 'package:bson/bson.dart';
import 'serializer.dart';
import 'model.dart';
import 'model.codec.dart';

main() {
  Serializer sz = new CodegenSerializer.typedJson()
    ..addAllTypeCodecs(example_model_codecs)
    ..addTypeCodec(ObjectId, new ObjectIdCodec());

  Model m = new Model()..foo = "test";

  String json = sz.encode(m);
  Map<String, dynamic> map = sz.toMap(m);
  print(json);
  print(map);

  Model M = sz.decode(json);
  print(M.foo);
}
