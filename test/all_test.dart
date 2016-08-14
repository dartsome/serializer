// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'codecs_test.dart' as _codecs;
import 'json_test.dart' as _json;
import 'double_json_test.dart' as _double_json;
import 'typed_json_test.dart' as _typed_json;

main() {
  _codecs.main();
  _json.main();
  _typed_json.main();
  _double_json.main();
}
