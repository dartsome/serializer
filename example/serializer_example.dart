// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library serializer.example;

import 'package:bson/bson.dart';
import 'serializer.dart';
import 'model.dart';
import 'model.codec.dart';
import 'model_b.dart';
import 'model_b.codec.dart';

//Map<String, TypeCodec> _codecs = {"ModelA": new ModelACodec()};

Serializer sz = new CodegenSerializer.typedJson()..addAllTypeCodecs(example_model_b_codecs)..addAllTypeCodecs(example_model_codecs);
//Serializer sz = new ReflectableSerializer.typedJson();

main() {
  sz.addTypeCodec(ObjectId, new ObjectIdCodec());
  ModelA a = new ModelA(new ObjectId(), "toto", 15);
  ModelB b = new ModelB()
    ..a = a
    ..A = [a]
    ..C = {"test": new ModelC()};

  print(sz.toMap(a));
  print(sz.encode(a));

  print(sz.toMap(b));
  print(sz.encode(b));

  ModelA A = sz.decode(sz.encode(a));
  print(sz.encode(A));

  ModelB B = sz.decode(sz.encode(b));
  print(sz.encode(B));
}
