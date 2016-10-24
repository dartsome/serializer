import 'package:build/build.dart';

import 'package:serializer/codegen/generator.dart';
import 'package:source_gen/source_gen.dart';

const List<String> files = const [
  'example/model.dart',
  'test/codegen/models_test.dart',
  'test/codegen/typed_json_test.dart',
  'test/codegen/json_test.dart',
  'test/codegen/double_json_test.dart',
];
const String library = "serializer";
