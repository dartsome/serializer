import 'dart:async';
import 'dart:mirrors';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/annotation.dart';
import 'package:source_gen/src/utils.dart';

import '../core.dart';
import "annotations.dart";

void closeBrace(StringBuffer buffer) => buffer.writeln("}");

void generateClass(StringBuffer buffer, String classType, String name, [String extendsClass]) {
  buffer.writeln("$classType $name ${ extendsClass != null ? 'extends $extendsClass' : '' } {");
}

void generateFunction(
    StringBuffer buffer, String returnType, String name, List<String> parameters, List<String> optionnal) {
  buffer.writeln("$returnType $name(${parameters.join((", "))}${ optionnal?.isNotEmpty == true
          ? ",{${optionnal.join(", ")}}"
          : ''}) {");
}

void generateGetter(StringBuffer buffer, String returnType, String name, String value) {
  buffer.writeln("$returnType get $name => $value;");
}

void import(StringBuffer buffer, String import, {List<String> show, String as}) =>
    buffer.writeln("import '$import' ${show?.isNotEmpty == true ? "show ${show.join(",")}" : as?.isNotEmpty == true
            ? "as $as"
            : ""};");

void semiColumn(StringBuffer buffer) => buffer.writeln(";");

class SerializerGenerator extends Generator {
  final String library;

  StringBuffer _codecsBuffer;

  SerializerGenerator(this.library);

  String get codescMapAsString => (_codecsBuffer..writeln("};")).toString();

  @override
  Future<String> generate(Element element, BuildStep buildStep) async {
    StringBuffer buffer = new StringBuffer();
    if (friendlyNameForElement(element).startsWith("library")) {
      buffer.writeln("library ${buildStep.input.id.path
          .split("/")
          .last
          .split(".")
          .first}.codec;");
      import(buffer, "package:serializer/core.dart", show: ["Serializer", "cleanNullInMap"]);
      import(buffer, "package:serializer/codecs.dart");
      import(buffer, buildStep.input.id.path.split("/").last);
    } else if (element is ClassElement &&
        _isClassSerializable(element) == true &&
        element.isAbstract == false &&
        element.isPrivate == false) {
      _classCodec(buffer, element.displayName);

      _generateDecode(buffer, element);
      _generateEncode(buffer, element);
      _generateUtils(buffer, element);

      closeBrace(buffer);

      _codecsBuffer.writeln("'${element.displayName}': new ${element.displayName}Codec(),");
    }
    return buffer.toString();
  }

  initCodecsMap() {
    _codecsBuffer = new StringBuffer("<String,TypeCodec<dynamic>>{");
  }

  String withTypeInfoKey(FieldElement field, [bool decode = false]) {
    if (field.metadata.any((ElementAnnotation a) => _matchAnnotation(SerializedWithTypeInfo, a)) ||
        field.type.toString() == "dynamic") {
      return "true";
    }
    if (decode == true) {
      return "false";
    }
    return "typeInfoKey?.isNotEmpty == true";
  }

  void _classCodec(StringBuffer buffer, String className) =>
      generateClass(buffer, "class", "${className}Codec", "TypeCodec<$className>");

  String _findGenericOfList(String type) {
    RegExp reg = new RegExp(r"^List<(.*)>$");
    Iterable<Match> matches = reg.allMatches(type);
    if (matches == null || matches.isEmpty) {
      return null;
    }
    return matches.first.group(1);
  }

  String _findGenericOfMap(String type) {
    RegExp reg = new RegExp(r"^Map<(.*)\ *,\ *(.*)>$");
    Iterable<Match> matches = reg.allMatches(type);
    if (matches == null || matches.isEmpty) {
      return null;
    }
    return matches.first.group(2);
  }

  bool _matchAnnotation(Type annotationType, ElementAnnotation annotation) {
    try {
      return matchAnnotation(annotationType, annotation);
    } catch (e, s) {
      //print(e);
      //print(s);
    }
    return false;
  }

  bool _decodeWithTypeInfo(Element element) =>
      (_isClassSerializable(element) == true && (element as ClassElement).isAbstract == true) ||
      element.displayName == "dynamic" ||
      (element as ClassElement).metadata.any((ElementAnnotation a) => _matchAnnotation(SerializedWithTypeInfo, a)) ==
          true;

  bool _decodeWithType(Element element) =>
      _isClassSerializable(element) == true && (element as ClassElement).isAbstract == false;

  bool _encodeWithTypeInfo(Element element) =>
      _isClassSerializable(element) == true && (element as ClassElement).isAbstract == true;

  void _generateDecode(StringBuffer buffer, ClassElement element) {
    Map<String, FieldElement> fields = _setters(element);
    buffer.writeln("@override");
    generateFunction(buffer, "${element.displayName}", "decode", ["dynamic value"], ["Serializer serializer"]);

    buffer.writeln("${element.displayName} obj = new ${element.displayName}();");

    fields.forEach((String name, FieldElement field) {
      String genericType = _getType(field).split("<").first;
      buffer.write("obj.$name = (");
      if (isPrimaryTypeString(genericType) && genericType == "${field.type}") {
        buffer.write("value['${_getSerializedName(field)}']");
      } else if (_decodeWithTypeInfo(field.type.element)) {
        buffer.write("serializer?.decode(value['${_getSerializedName(field)}'], useTypeInfo: true) ");
      } else {
        buffer.write("serializer?.decode(value['${_getSerializedName(field)}'], type: $genericType) ");
      }
      buffer.writeln("?? obj.$name) as ${field.type};");
    });

    buffer.writeln("return obj;");

    closeBrace(buffer);
  }

  void _generateEncode(StringBuffer buffer, ClassElement element) {
    Map<String, FieldElement> fields = _getters(element);

    buffer.writeln("@override");
    generateFunction(
        buffer, "dynamic", "encode", ["${element.displayName} value"], ["Serializer serializer", "String typeInfoKey"]);

    buffer.writeln("Map<String, dynamic> map = new Map<String, dynamic>();");

    buffer.writeln("if (typeInfoKey != null) {");
    buffer.writeln("map[typeInfoKey] = typeInfo;");
    closeBrace(buffer);
    fields.forEach((String name, FieldElement field) {
      buffer.write("map['${_getSerializedName(field)}'] = ");
      if (isPrimaryTypeString(_getType(field)) == false) {
        buffer.write("serializer?.toPrimaryObject(value.$name, useTypeInfo: ${_useTypeInfoKey(field)});");
      } else {
        buffer.write("value.$name;");
      }
    });

    buffer.writeln("return cleanNullInMap(map);");

    closeBrace(buffer);
  }

  void _generateUtils(StringBuffer buffer, Element element) {
    buffer.writeln("@override");
    generateGetter(buffer, "String", "typeInfo", "'${element.displayName}'");
  }

  String _getSerializedName(FieldElement field) {
    ElementAnnotation nameAnnotation =
        field.metadata.firstWhere((ElementAnnotation a) => _matchAnnotation(SerializedName, a), orElse: () => null);
    if (nameAnnotation != null) {
      return nameAnnotation.constantValue.getField("name").toStringValue();
    }
    return field.name;
  }

  String _getType(FieldElement field) {
    String t = _findGenericOfMap(field.type.toString());
    if (t == null) {
      t = _findGenericOfList(field.type.toString());
    }
    t ??= field.type.toString();
    if (t == "dynamic") {
      return "null";
    }
    return t;
  }

  bool _isFieldSerializable(Element field) =>
      field is FieldElement &&
      field.isStatic == false &&
      field.isConst == false &&
      field.isPrivate == false &&
      field.metadata.any((ElementAnnotation a) => _matchAnnotation(Ignore, a)) == false;

  bool _isClassSerializable(Element elem) =>
      elem is ClassElement && elem.metadata.any((ElementAnnotation a) => _matchAnnotation(Serializable, a)) == true;

  Map<String, FieldElement> _getters(ClassElement element) => _getMatchingFields(
      element, (FieldElement field, t) => _isFieldSerializable(field) == true && t.getGetter(field.name) != null);
  Map<String, FieldElement> _setters(ClassElement element) => _getMatchingFields(
      element, (FieldElement field, t) => _isFieldSerializable(field) == true && t.getSetter(field.name) != null);

  Map<String, FieldElement> _getMatchingFields(ClassElement element, Function matcher) {
    Map<String, FieldElement> fields = <String, FieldElement>{};
    element.allSupertypes.forEach((InterfaceType t) {
      if (_isClassSerializable(t.element)) {
        t.element.fields.forEach((FieldElement field) {
          if (matcher(field, t) == true) {
            fields[field.name] = field;
          }
        });
      }
    });

    element.mixins.forEach((InterfaceType t) {
      //  if (_isClassSerializable(t.element)) {
      t.element.fields.forEach((FieldElement field) {
        if (matcher(field, t) == true) {
          fields[field.name] = field;
        }
      });
      // }
    });

    element.fields.forEach((FieldElement field) {
      if (matcher(field, element) == true) {
        fields[field.name] = field;
      }
    });
    return fields;
  }

  String _useTypeInfoKey(FieldElement field, [bool decode = false]) {
    String type = _getType(field).split("<").first;
    if (type == "null" || _encodeWithTypeInfo(field.type.element)) {
      return "true";
    }
    return "${withTypeInfoKey(field, decode)}";
  }
}
