// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:reflectable/reflectable.dart';
import '../core.dart';

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

class _MetadataManager<T> {
  const _MetadataManager();

  bool hasMetadata(DeclarationMirror dec) {
    return metadata(dec) != null;
  }

  Object metadata(DeclarationMirror dec) {
    for (var data in dec?.metadata) {
      if (data is T) {
        return data;
      }
    }
    return null;
  }
}

const _MetadataManager<SerializedName>         serializedNameMetadataManager         = const _MetadataManager<SerializedName>();
const _MetadataManager<Referenceable>          referenceableMetadataManager          = const _MetadataManager<Referenceable>();
const _MetadataManager<Reference>              referenceMetadataManager              = const _MetadataManager<Reference>();
const _MetadataManager<Ignore>                 ignoreMetadataManager                 = const _MetadataManager<Ignore>();
const _MetadataManager<SerializedWithTypeInfo> serializedWithTypeInfoMetadataManager = const _MetadataManager<SerializedWithTypeInfo>();
