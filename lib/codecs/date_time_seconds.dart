// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'type_codec.dart';

/// A seconds since epoch DateTime codec.
class DateTimeSecondsSinceEpochCodec extends TypeCodec<DateTime> {
  DateTime decode(dynamic value, {Serializer serializer}) => new DateTime.fromMillisecondsSinceEpoch(value * 1000);
  dynamic encode(DateTime value, {Serializer serializer, bool useTypeInfo, bool withTypeInfo}) => value.millisecondsSinceEpoch ~/ 1000;
}
