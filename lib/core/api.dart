// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file

// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library serializer.api;

import '../codecs.dart';

bool isPrimaryType(Type obj) =>
    obj == num || obj == String || obj == bool || obj == int || obj == double;

bool isPrimaryTypeString(String obj) =>
    obj == "num" ||
    obj == "String" ||
    obj == "bool" ||
    obj == "int" ||
    obj == "double";

final String MapTypeString = {}.runtimeType.toString();
final String ListTypeString = [].runtimeType.toString();

Map cleanNullInMap(Map<String, dynamic> map) {
  Iterable<String> keys = new List.from(map.keys);
  keys.forEach((String k) {
    if (map[k] == null) {
      map.remove(k);
    }
  });
  return map;
}

abstract class Serializer {
  /// Return typeInfoKey value.
  String get typeInfoKey;

  /// Return useTypeInfo value.
  bool get useTypeInfo;

  /// Return if typeInfoKey must be enabled
  bool enableTypeInfo(bool useTypeInfo, bool withTypeInfo) =>
      useTypeInfo != null
          ? useTypeInfo || (withTypeInfo ?? false)
          : this.useTypeInfo || (withTypeInfo ?? false);

  /// Registers a [typeCodec] for the specific [type].
  addTypeCodec(Type type, TypeCodec typeCodec);

  /// Registers a map of [typeCodec].
  addAllTypeCodecs(Map<String, TypeCodec> typesCodecs);

  /// Checks if a TypeCodec is registered for the [type].
  bool hasTypeCodec(Type type);

  /// Get the TypeCodec for the specific [type]
  TypeCodec typeCodec(Type type);

  /// Checks if a class is registered as a Serializable class.
  bool isSerializable(Type type);

  /// Convert the object to a Map
  Map<String, dynamic> toMap(Object input,
      {bool useTypeInfo, bool withTypeInfo});

  /// Convert to a Map or a List recursively
  Object toPrimaryObject(Object input, {bool useTypeInfo, bool withTypeInfo});

  /// Encode the object to serialized string
  String encode(Object input, {bool useTypeInfo, bool withTypeInfo});

  /// Decode the object from a seriablized string
  Object decode(dynamic encoded,
      {Type type, List<Type> mapOf, bool useTypeInfo, bool withTypeInfo});

  /// Convert a serialized object to map
  Object fromMap(Map<String, dynamic> map,
      {Type type, List<Type> mapOf, bool useTypeInfo, bool withTypeInfo});

  /// Convert a serialized object's [list] to a list of the given [type]
  List fromList(List<dynamic> list,
      {Type type, bool useTypeInfo, bool withTypeInfo});
}
