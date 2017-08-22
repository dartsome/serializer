// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class Serializable {
  const Serializable();
}

const serializable = const Serializable();

class Ignore {
  const Ignore();
}

const ignore = const Ignore();

class Referenceable {
  const Referenceable();
}

const referenceable = const Referenceable();

class Reference {
  const Reference();
}

const reference = const Reference();

class SerializedName {
  final String name;
  const SerializedName(this.name);
}

class SerializedWithTypeInfo {
  const SerializedWithTypeInfo();
}

const serializedWithTypeInfo = const SerializedWithTypeInfo();

class UseType {
  final Type type;
  const UseType(this.type);
}
