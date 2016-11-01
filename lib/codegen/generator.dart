import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/annotation.dart';
import 'package:source_gen/src/utils.dart';

import '../core.dart';
import "annotations.dart";

void closeBrace(StringBuffer buffer) => buffer.writeln("}");

void generateClass(StringBuffer buffer, String classType, String name,
    [String extendsClass]) {
  buffer.writeln(
      "$classType $name ${ extendsClass != null ? 'extends $extendsClass' : '' } {");
}

void generateFunction(StringBuffer buffer, String returnType, String name,
    List<String> parameters, List<String> namedParameters) {
  buffer.writeln(
      "$returnType $name(${parameters.join((", "))}${ namedParameters?.isNotEmpty == true
          ? ",{${namedParameters.join(", ")}}"
          : ''}) {");
}

void generateGetter(
    StringBuffer buffer, String returnType, String name, String value) {
  buffer.writeln("$returnType get $name => $value;");
}

void import(StringBuffer buffer, String import,
        {List<String> show, String as}) =>
    buffer.writeln(
        "import '$import' ${show?.isNotEmpty == true ? "show ${show.join(",")}" : as?.isNotEmpty == true
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
      import(buffer, "package:serializer/core.dart",
          show: ["Serializer", "cleanNullInMap"]);
      import(buffer, "package:serializer/codecs.dart");
      import(buffer, buildStep.input.id.path.split("/").last);
    } else if (element is ClassElement &&
        _isClassSerializable(element) == true &&
        element.isAbstract == false &&
        element.isPrivate == false) {
      Map<String, Field> fields = _getFields(element);
      _classCodec(buffer, element.displayName);
      _generateDecode(buffer, element, fields);
      _generateEncode(buffer, element, fields);
      _generateUtils(buffer, element);

      closeBrace(buffer);

      _codecsBuffer.writeln(
          "'${element.displayName}': new ${element.displayName}Codec(),");
    }
    return buffer.toString();
  }

  initCodecsMap() {
    _codecsBuffer = new StringBuffer("<String,TypeCodec<dynamic>>{");
  }

  String _withTypeInfo(Field field) {
    if (field.useType == null &&
        (field.serializeWithTypeInfo || field.type.toString() == "dynamic")) {
      return "true";
    }
    return "false";
  }

  void _classCodec(StringBuffer buffer, String className) => generateClass(
      buffer, "class", "${className}Codec", "TypeCodec<$className>");

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

  bool _decodeWithTypeInfo(Field field) {
    if (field.useType == null) {
      Element elem = field.type.element;

      return field.type.element.displayName == "dynamic" ||
          field.serializeWithTypeInfo == true ||
          (_isClassSerializable(elem) == true &&
              (elem as ClassElement).isAbstract == true);
    }
    return false;
  }

  void _generateDecode(
      StringBuffer buffer, ClassElement element, Map<String, Field> fields) {
    buffer.writeln("@override");
    generateFunction(buffer, "${element.displayName}", "decode",
        ["dynamic value"], ["Serializer serializer"]);

    buffer
        .writeln("${element.displayName} obj = new ${element.displayName}();");

    fields.forEach((String name, Field field) {
      if (field.isSetter && field.ignore == false) {
        String genericType = _getType(field).split("<").first;
        if (field.useType != null) {
          genericType = field.useType;
        }
        buffer.write("obj.$name = (");
        if (isPrimaryTypeString(genericType) &&
            genericType == "${field.type}") {
          buffer.write("value['${field.key}']");
        } else if (_decodeWithTypeInfo(field)) {
          buffer.write(
              "serializer?.decode(value['${field.key}'], useTypeInfo: true) ");
        } else if (field.type.toString().split("<").first == "Map") {
          buffer.write(
              "serializer?.decode(value['${field.key}'], mapOf: const [String, $genericType]) ");
        } else {
          buffer.write(
              "serializer?.decode(value['${field.key}'], type: $genericType) ");
        }
        buffer.write("?? obj.$name) as ");
        if (field.useType != null) {
          buffer.writeln("${field.useType};");
        } else {
          buffer.writeln("${field.type};");
        }
      }
    });

    buffer.writeln("return obj;");

    closeBrace(buffer);
  }

  void _generateEncode(
      StringBuffer buffer, ClassElement element, Map<String, Field> fields) {
    buffer.writeln("@override");
    generateFunction(
        buffer,
        "dynamic",
        "encode",
        ["${element.displayName} value"],
        ["Serializer serializer", "bool useTypeInfo", "bool withTypeInfo"]);

    buffer.writeln("Map<String, dynamic> map = new Map<String, dynamic>();");

    buffer
        .writeln("if (serializer.enableTypeInfo(useTypeInfo, withTypeInfo)) {");
    buffer.writeln("map[serializer.typeInfoKey] = typeInfo;");
    closeBrace(buffer);
    fields.forEach((String name, Field field) {
      if (field.isGetter && field.ignore == false) {
        buffer.write("map['${field.key}'] = ");
        if (isPrimaryTypeString(_getType(field)) == false) {
          buffer.write(
              "serializer?.toPrimaryObject(value.$name, useTypeInfo: useTypeInfo, withTypeInfo: ${_withTypeInfo(field)} );");
        } else {
          buffer.write("value.$name;");
        }
      }
    });

    buffer.writeln("return cleanNullInMap(map);");

    closeBrace(buffer);
  }

  void _generateUtils(StringBuffer buffer, Element element) {
    buffer.writeln("@override");
    generateGetter(buffer, "String", "typeInfo", "'${element.displayName}'");
  }

  String _getType(Field field) {
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

  //fixme dirty
  bool _isInSameLibrary(ClassElement element) {
    return element.displayName != "Object" &&
        element.librarySource.fullName.split("|").first == library;
  }

  List _getFieldsFromMixins(ClassElement element) {
    List list = [];

    for (InterfaceType m in element.mixins) {
      for (InterfaceType s in m.element.allSupertypes) {
        if (_isInSameLibrary(s.element)) {
          list.addAll(s.element.accessors);
          list.addAll(s.element.fields);
          list.addAll(_getFieldsFromMixins(s.element));
        }
      }
      if (_isInSameLibrary(m.element)) {
        list.addAll(m.element.accessors);
        list.addAll(m.element.fields);
        list.addAll(_getFieldsFromMixins(m.element));
      }
    }
    return list;
  }

  Map<String, Field> _getFields(ClassElement element) {
    Map<String, Field> fields = {};

    List<dynamic> all = [];

    element.allSupertypes.forEach((InterfaceType t) {
      if (_isInSameLibrary(t.element)) {
        all.addAll(t.element.accessors);
        all.addAll(t.element.fields);
        all.addAll(_getFieldsFromMixins(t.element));
      }
    });
    all.addAll(_getFieldsFromMixins(element));
    all.addAll(element.accessors);
    all.addAll(element.fields);

    all.forEach((e) {
      if (e.isPrivate == false &&
          e.isStatic == false &&
          (e is PropertyAccessorElement ||
              (e is FieldElement && e.isFinal == false))) {
        if (fields.containsKey(_getElementName(e)) == false &&
            _isFieldSerializable(e) == true) {
          fields[_getElementName(e)] = new Field(e);
        } else {
          fields[_getElementName(e)]?.update(e);
        }
      }
    });

    return fields;
  }
}

class Field {
  String key;
  bool ignore;
  bool serializeWithTypeInfo;
  bool isSerializable;
  bool isGetter;
  bool isSetter;

  DartType type;
  String useType;

  Field(Element element) {
    isSerializable = _isFieldSerializable(element);
    update(element);
  }

  _setType(Element element) {
    useType ??= _getUseType(element);
    if (element is FieldElement) {
      type = element.type;
    } else if (element is PropertyAccessorElement) {
      if (isGetter == true) {
        type = element.returnType;
      } else if (isSetter == true) {
        type = element.type.normalParameterTypes.first;
      }
    }
  }

  _setIsGetter(Element element) {
    bool g;
    if (element is FieldElement) {
      g = true;
    } else if (element is PropertyAccessorElement) {
      g = element.isGetter;
    }
    if (isGetter != true) {
      isGetter = g;
    }
  }

  _setIsSetter(Element element) {
    bool s;
    if (element is FieldElement) {
      s = true;
    } else if (element is PropertyAccessorElement) {
      s = element.isSetter;
    }
    if (isSetter != true) {
      isSetter = s;
    }
  }

  _setKey(Element element) {
    String k = _getSerializedName(element);
    if ((key == element.name && k != element.name) || key == null) {
      key = k;
    }
  }

  _setIgnore(Element element) {
    if (ignore != true) {
      ignore = _ignoreField(element);
    }
  }

  _setSerializeWithType(Element element) {
    if (serializeWithTypeInfo != true) {
      serializeWithTypeInfo = _serializeFieldWithType(element);
    }
  }

  update(Element element) {
    _setIgnore(element);
    _setIsGetter(element);
    _setIsSetter(element);
    _setSerializeWithType(element);
    _setKey(element);
    _setType(element);
  }

  String toString() => {
        "name": key,
        "type": type?.displayName,
        "ignore": ignore,
        "serializeWithType": serializeWithTypeInfo,
        "isSerializable": isSerializable
      }.toString();
}

bool _ignoreField(Element field) =>
    field.metadata.firstWhere(
        (ElementAnnotation a) => _matchAnnotation(Ignore, a),
        orElse: () => null) !=
    null;
bool _serializeFieldWithType(Element field) =>
    field.metadata.firstWhere(
        (ElementAnnotation a) => _matchAnnotation(SerializedWithTypeInfo, a),
        orElse: () => null) !=
    null;

//fixme: very dirty
String _getSerializedName(Element field) {
  String key = _getElementName(field);
  field.metadata.forEach((ElementAnnotation a) {
    if (a
        .toString()
        .contains("@SerializedName(String name) → SerializedName")) {
      key = a.computeConstantValue().getField("name").toStringValue();
    }
  });
  return key;
}

//fixme: very dirty
String _getUseType(Element field) {
  String key = null;
  field.metadata.forEach((ElementAnnotation a) {
    if (a.toString().contains("@UseType(Type type) → UseType")) {
      key = a.computeConstantValue().getField("type").toTypeValue()?.toString();
    }
  });
  return key;
}

bool _matchAnnotation(Type annotationType, ElementAnnotation annotation) {
  try {
    return matchAnnotation(annotationType, annotation);
  } catch (e, _) {
    //print(e);
    //print(s);
  }
  return false;
}

bool _isFieldSerializable(Element field) =>
    field is PropertyAccessorElement &&
    field.isStatic == false &&
    field.isPrivate == false;

bool _isClassSerializable(Element elem) =>
    elem is ClassElement &&
    elem.metadata
            .any((ElementAnnotation a) => _matchAnnotation(Serializable, a)) ==
        true;

String _getElementName(Element element) => element.name.split(("=")).first;
