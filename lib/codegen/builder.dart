import 'dart:async';

import 'dart:io';
import 'package:dart_style/dart_style.dart';
import 'package:build/build.dart' as _build;
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/utils.dart';
import 'package:source_gen/src/generated_output.dart';
import 'package:analyzer/dart/element/element.dart';
import 'generator.dart';
import 'dart:async';

class SerializerGeneratorBuilder extends _build.Builder {
  final String generatedExtension;
  static SerializerGenerator _gen = new SerializerGenerator();
  SerializerGeneratorBuilder({this.generatedExtension: '.codec.dart'});

  @override
  Future build(_build.BuildStep buildStep) async {
    var id = buildStep.input.id;
    var resolver = await buildStep.resolve(id, resolveAllConstants: false);
    var lib = resolver.getLibrary(id);
    await _generateForLibrary(lib, buildStep);
    resolver.release();
  }

  @override
  List<_build.AssetId> declareOutputs(_build.AssetId input) {
    if (input.extension != '.dart') return const [];
    return [_generatedFile(input)];
  }

  _build.AssetId _generatedFile(_build.AssetId input) =>
      input.changeExtension(generatedExtension);

  Future _generateForLibrary(
      LibraryElement library, _build.BuildStep buildStep) async {
    buildStep.logger.fine('Running $_gen for ${buildStep.input.id}');

    _gen.initCodecsMap();
    var generatedOutputs =
    await _generate(library, buildStep).toList();

    // Don't outputs useless files.
    if (generatedOutputs.isEmpty == true) return;

    var contentBuffer = new StringBuffer();


    for (GeneratedOutput output in generatedOutputs) {
      if (output.output.isEmpty == false) {
        contentBuffer.writeln('');
        contentBuffer.writeln(_headerLine);
        contentBuffer.writeln('// Generator: ${output.generator}');
        contentBuffer
            .writeln('// Target: ${friendlyNameForElement(output.sourceMember)}');
        contentBuffer.writeln(_headerLine);
        contentBuffer.writeln('');

        contentBuffer.writeln(output.output);
      }
    }
    String codecMapName = buildStep.input.id.path.split(".").first.replaceAll("/", "_");
    contentBuffer.writeln("Map<String, TypeCodec<dynamic>> ${codecMapName}_codecs = ${_gen.codescMapAsString}");

    var genPartContent = contentBuffer.toString();

    var formatter = new DartFormatter();
    try {
      genPartContent = formatter.format(genPartContent);
    } catch (e, stack) {
      buildStep.logger.severe(
          """Error formatting the generated source code.
This may indicate an issue in the generated code or in the formatter.
Please check the generated code and file an issue on source_gen
if approppriate.""",
          e,
          stack);
    }

    var outputId = _generatedFile(buildStep.input.id);
    var output = new _build.Asset(outputId, '$_topHeader$genPartContent');
    buildStep.writeAsString(output);
  }
  Stream<GeneratedOutput> _generate(LibraryElement unit, _build.BuildStep buildStep) async* {
    for (var element in getElementsFromLibraryElement(unit)) {
      yield* _processUnitMember(element, buildStep);
    }
  }

  Stream<GeneratedOutput> _processUnitMember(
      Element element, _build.BuildStep buildStep) async* {
    try {
      buildStep.logger.finer('Running $_gen for $element');
      var createdUnit = await _gen.generate(element, buildStep);

      if (createdUnit != null) {
        buildStep.logger.finest(() => 'Generated $createdUnit for $element');
        yield new GeneratedOutput(element, _gen, createdUnit);
      }
    } catch (e, stack) {
      buildStep.logger.severe('Error running $_gen for $element.', e, stack);
      yield new GeneratedOutput.fromError(element, _gen, e, stack);
    }
  }
}



const _topHeader = '''// GENERATED CODE - DO NOT MODIFY BY HAND

''';

final _headerLine = '// '.padRight(77, '*');



_build.PhaseGroup _phases(String library, final List<String> files) =>
    new _build.PhaseGroup.singleAction(new SerializerGeneratorBuilder(), new _build.InputSet(library, files));

build(String library, final List<String> files) async =>
    _build.build(_phases(library, files), deleteFilesByDefault: true);

watch(String library, final List<String> files) async =>
    _build.watch(_phases(library, files), deleteFilesByDefault: true);
