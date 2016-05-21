// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library serializer.base;

import "dart:convert";
import "package:reflectable/reflectable.dart";

part "api.dart";
part "convert.dart";

String _type_info_key;

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
