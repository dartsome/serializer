import 'dart:async';

import 'package:build_runner/build_runner.dart' as runner;
import 'package:source_gen/source_gen.dart';

import 'package:serializer_generator/src/generator.dart';

List<runner.BuildAction> _buildActions(String library, final List<String> inputs) => [
      new runner.BuildAction(
        new LibraryBuilder(new SerializerGenerator(library),
            generatedExtension: '.codec.dart'),
        library,
        inputs: inputs,
      ),
    ];

Future<runner.BuildResult> build(String library, final List<String> files) =>
    runner.build(_buildActions(library, files));

Stream<runner.BuildResult> watch(String library, final List<String> files) =>
    runner.watch(_buildActions(library, files));
