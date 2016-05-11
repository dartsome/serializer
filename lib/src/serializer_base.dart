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
          typeCapability,
          typingCapability,
          superclassQuantifyCapability,
          newInstanceCapability,
          reflectedTypeCapability,
          libraryCapability,
          instanceInvokeCapability
        ]);
}

const serializable = const Serializable();

initSerializer({String type_info_key: "@type"}) {
  _type_info_key = type_info_key;
  for (ClassMirror classMirror in serializable.annotatedClasses) {
    if (classMirror != null
        && classMirror.simpleName != null
        && classMirror.metadata.contains(serializable)) {
      Serializer.classes[classMirror.simpleName] = classMirror;
    }
  }
}

class Ignore {
  const Ignore();
}

const ignore = const Ignore();