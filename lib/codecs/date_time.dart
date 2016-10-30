// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'type_codec.dart';

/// A simple DateTime codec.
class DateTimeCodec extends TypeCodec<DateTime> {
  DateTime decode(dynamic value, {Serializer serializer}) => DateTime.parse(value);
  dynamic encode(DateTime value, {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) => value.toIso8601String();
}
