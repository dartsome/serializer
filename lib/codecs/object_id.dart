// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:bson/bson.dart';
import 'type_codec.dart';

/// A simple ObjectId codec.
class ObjectIdCodec extends TypeCodec<ObjectId> {
  ObjectId decode(dynamic value, {Serializer serializer}) => value is ObjectId ? value : ObjectId.parse(value);
  dynamic encode(ObjectId value, {Serializer serializer, String typeInfoKey}) => value;
}
