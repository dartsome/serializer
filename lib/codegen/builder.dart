import 'dart:async';

import 'package:build/build.dart' as _build;
import 'package:source_gen/source_gen.dart';
import 'generator.dart';

class SerializerGeneratorBuilder extends GeneratorBuilder {
  SerializerGeneratorBuilder({String generatedExtension: '.codec.dart'})
      : super(const [const SerializerGenerator()], isStandalone: true, generatedExtension: generatedExtension);
}

_build.PhaseGroup _phases(String library, final List<String> files) =>
    new _build.PhaseGroup.singleAction(new SerializerGeneratorBuilder(), new _build.InputSet(library, files));

build(String library, final List<String> files) async =>
    _build.build(_phases(library, files), deleteFilesByDefault: true);

watch(String library, final List<String> files) async =>
    _build.watch(_phases(library, files), deleteFilesByDefault: true);
