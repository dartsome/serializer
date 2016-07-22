// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'type_codec.dart';

/// A UTC DateTime codec.
class DateTimeUtcCodec extends TypeCodec<DateTime> {
  DateTime decode(dynamic value) => DateTime.parse(value);
  dynamic encode(DateTime value) => value.toUtc().toIso8601String();
}
