// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'package:serializer/serializer.dart';

import 'dynamic_list_test.codec.dart';

@serializable
class DynamicList {
  List<dynamic> list;
}

void main() {
  Serializer serializer;

  setUpAll(() {
    serializer = new Serializer.json()..addAllTypeCodecs(test_dynamic_list_test_codecs);
  });

  group('Encode', () {
    test('as String', () {
      var list = new DynamicList()..list = <String>['A', 'N', 'D'];
      var encoded = serializer.encode(list);
      expect(encoded, '{"list":["A","N","D"]}');
    });
  });

  group('Decode', () {
    test('as String', () {
      var encoded = '{"list":["A","N","D"]}';
      DynamicList list = serializer.decode(encoded, type: DynamicList);
      expect(list.list, <String>['A', 'N', 'D']);
    });
  });
}
