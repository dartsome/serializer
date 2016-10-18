import 'dart:async';

import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/src/generated/utilities_dart.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/annotation.dart';
import 'package:source_gen/src/utils.dart';
import 'package:source_gen/src/generated_output.dart';
import "annotations.dart";
import '../core.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dart_style/src/dart_formatter.dart';

void closeBrace(StringBuffer buffer) => buffer.writeln("}");
void semiColumn(StringBuffer buffer) => buffer.writeln(";");
void import(StringBuffer buffer, String import, {List<String> show}) =>
    buffer.writeln("import '$import' ${show?.isNotEmpty == true ? "show ${show.join(",")}" : ""};");
void generateFunction(
    StringBuffer buffer, String returnType, String name, List<String> parameters, List<String> optionnal) {
  buffer.writeln(
      "$returnType $name(${parameters.join((", "))}${ optionnal?.isNotEmpty == true ? ",{${optionnal.join(", ")}}" : ''}) {");
}

void generateGetter(StringBuffer buffer, String returnType, String name, String value) {
  buffer.writeln("$returnType get $name => $value;");
}

void generateClass(StringBuffer buffer, String classType, String name, [String extendsClass]) {
  buffer.writeln("$classType $name ${ extendsClass != null ? 'extends $extendsClass' : '' } {");
}

class SerializerGenerator extends Generator {
  SerializerGenerator();

  StringBuffer _codecsBuffer;
  String get codescMapAsString => (_codecsBuffer..writeln("};")).toString();

  initCodecsMap() {
    _codecsBuffer = new StringBuffer("<String,TypeCodec>{");
  }

  @override
  Future<String> generate(Element element, BuildStep buildStep) async {
    StringBuffer buffer = new StringBuffer();
    if (friendlyNameForElement(element).startsWith("library")) {
      buffer.writeln("library ${buildStep.input.id.path.split("/").last.split(".").first}.codec;");
      import(buffer, "package:serializer/core.dart", show: ["Serializer"]);
      import(buffer, "package:serializer/codecs.dart");
      import(buffer, buildStep.input.id.path.split("/").last);
    } else if (element is ClassElement &&
        element.isAbstract == false &&
        element.metadata.firstWhere((ElementAnnotation a) => matchAnnotation(Serializable, a), orElse: () => null) !=
            null) {
      Map<String, FieldElement> fields =
          element.fields.fold(<String, FieldElement>{}, (Map<String, FieldElement> map, field) {
            if (_isSerializable(field) == true) {
              map[field.name] = field;
            }
        return map;
      });

      element.allSupertypes.forEach((InterfaceType t) {
        if (t.element.metadata.any((ElementAnnotation a) => matchAnnotation(Serializable, a)) == true) {
          t.element.fields.forEach((FieldElement field) {
            if (_isSerializable(field) == true) {
              fields[field.name] = field;
            }
          });
        }
      });

      _classCodec(buffer, element.displayName);

      _generateDecode(buffer, element, fields);
      _generateEncode(buffer, element, fields);
      _generateUtils(buffer, element);

      closeBrace(buffer);

      _codecsBuffer.writeln("'${element.displayName}': new ${element.displayName}Codec(),");
    }
    return buffer.toString();
  }

  void _classCodec(StringBuffer buffer, String className) =>
      generateClass(buffer, "class", "${className}Codec", "TypeCodec<$className>");

  void _generateEncode(StringBuffer buffer, ClassElement element, Map<String, FieldElement> fields) {
    buffer.writeln("@override");
    generateFunction(
        buffer, "dynamic", "encode", ["${element.displayName} value"], ["Serializer serializer", "String typeInfoKey"]);

    buffer.writeln("Map<String, dynamic> map = new Map<String, dynamic>();");
    buffer.writeln("if (typeInfoKey != null) {");
    buffer.writeln("map[typeInfoKey] = typeInfo;");
    closeBrace(buffer);
    fields.forEach((String name, FieldElement field) {
      if (element.getGetter(name) != null) {
        buffer.write("map['${_getSerializedName(field)}'] = ");
        buffer.write("serializer?.isSerializable(${_getType(element.getGetter(name).returnType)}) == true ? ");
        buffer.write("serializer?.encode(value.$name, useTypeInfo: typeInfoKey?.isNotEmpty == true) ");
        buffer.write(": value.$name; ");
      }
    });

    buffer.writeln("return map;");

    closeBrace(buffer);
  }

  String _getType(DartType type) {
    String t = _findGenericOfMap(type.toString());
    if (t == null) {
      t = _findGenericOfList(type.toString());
    }
    return t ?? type.toString();
  }

  void _generateDecode(StringBuffer buffer, ClassElement element, Map<String, FieldElement> fields) {
    buffer.writeln("@override");
    generateFunction(buffer, "${element.displayName}", "decode", ["dynamic value"], ["Serializer serializer"]);

    buffer.writeln("${element.displayName} obj = new ${element.displayName}();");
    fields.forEach((String name, FieldElement field) {
      if (element.getSetter(name) != null) {
        buffer.write("obj.$name = ");
        buffer.write("(serializer?.isSerializable(${_getType(element.getGetter(name).returnType)}) == true ? ");
        buffer.write("serializer?.decode(value['${_getSerializedName(field)}'], type: ${_getType(element.getGetter(name).returnType)}) ");
        buffer.write(": value['${_getSerializedName(field)}'])  as ${element.getGetter(name).returnType} ");
        buffer.writeln("?? obj.$name;");
      }
    });

    buffer.writeln("return obj;");

    closeBrace(buffer);
  }

  void _generateUtils(StringBuffer buffer, Element element) {
    buffer.writeln("@override");
    generateGetter(buffer, "String", "typeInfo", "'${element.displayName}'");
  }

  String _findGenericOfMap(String type) {
    RegExp reg = new RegExp(r"^Map<(.*)\ *,\ *(.*)>$");
    Iterable<Match> matches = reg.allMatches(type);
    if (matches == null || matches.isEmpty) {
      return null;
    }
    return matches.first.group(2);
  }

  String _findGenericOfList(String type) {
    RegExp reg = new RegExp(r"^List<(.*)>$");
    Iterable<Match> matches = reg.allMatches(type);
    if (matches == null || matches.isEmpty) {
      return null;
    }
    return matches.first.group(1);
  }

  bool _isSerializable(FieldElement field) =>
      field.isStatic == false &&
      field.isConst == false &&
      field.isPrivate == false &&
      field.metadata.any((ElementAnnotation a) => matchAnnotation(Ignore, a)) == false;

  String _getSerializedName(FieldElement field) {
    ElementAnnotation nameAnnotation =
        field.metadata.firstWhere((ElementAnnotation a) => matchAnnotation(SerializedName, a), orElse: () => null);
    if (nameAnnotation != null) {
      return nameAnnotation.constantValue.getField("name").toStringValue();
    }
    return field.name;
  }
}
