// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library serializer.base;

import 'dart:convert';
import 'package:reflectable/reflectable.dart';

import 'package:serializer/type_codec.dart';
import 'package:serializer/codecs/date_time.dart';

part 'api.dart';
part 'convert.dart';

class Serializable extends Reflectable {
  const Serializable()
      : super.fromList(const [
          invokingCapability,
          typeRelationsCapability,
          metadataCapability,
          superclassQuantifyCapability,
          reflectedTypeCapability
        ]);
}

const serializable = const Serializable();

class Ignore {
  const Ignore();
}

const ignore = const Ignore();

class SerializedName {
  final String name;
  const SerializedName(this.name);
}
