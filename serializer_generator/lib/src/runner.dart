import 'dart:async';

import 'package:build_config/build_config.dart' show InputSet;
import 'package:build_runner/build_runner.dart' as runner;
import 'package:source_gen/source_gen.dart';

import 'package:serializer_generator/src/generator.dart';

List<runner.BuilderApplication> _buildApplication(
        String library, final List<String> inputs) =>
    [
      runner.applyToRoot(
        new LibraryBuilder(new SerializerGenerator(library),
            generatedExtension: '.codec.dart'),
        generateFor: new InputSet(include: inputs),
      ),
    ];

Future<runner.BuildResult> build(String library, final List<String> files) =>
    runner.build(_buildApplication(library, files), deleteFilesByDefault: true);

Future<runner.ServeHandler> watch(String library, final List<String> files) =>
    runner.watch(_buildApplication(library, files), deleteFilesByDefault: true);
