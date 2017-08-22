import 'dart:async';
import 'dart:io';
import 'dart:mirrors';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

import '../core.dart';
import "annotations.dart";

// Copied from pkg/source_gen - lib/src/utils.
String friendlyNameForElement(Element element) {
  var friendlyName = element.displayName;

  if (friendlyName == null) {
    throw new ArgumentError(
        'Cannot get friendly name for $element - ${element.runtimeType}.');
  }

  var names = <String>[friendlyName];
  if (element is ClassElement) {
    names.insert(0, 'class');
    if (element.isAbstract) {
      names.insert(0, 'abstract');
    }
  }
  if (element is VariableElement) {
    names.insert(0, element.type.toString());

    if (element.isConst) {
      names.insert(0, 'const');
    }

    if (element.isFinal) {
      names.insert(0, 'final');
    }
  }
  if (element is LibraryElement) {
    names.insert(0, 'library');
  }

  return names.join(' ');
}

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

class SerializerGenerator extends GeneratorForAnnotation<Serializable> {
  final String library;

  StringBuffer _codecsBuffer;

  SerializerGenerator(this.library);

  String get codescMapAsString => (_codecsBuffer..writeln("};")).toString();

  @override
  Future<String> generate(
      LibraryReader libraryReader, BuildStep buildStep) async {
    StringBuffer buffer = new StringBuffer();

    buffer.writeln("library ${buildStep.inputId.path
        .split("/")
        .last
        .split(".")
        .first}.codec;");
    import(buffer, "package:serializer/core.dart",
        show: ["Serializer", "cleanNullInMap"]);
    import(buffer, "package:serializer/codecs.dart");
    import(buffer, buildStep.inputId.path.split("/").last);

    initCodecsBuffer();
    buffer.write(await super.generate(libraryReader, buildStep));

    String codecMapName =
        buildStep.inputId.path.split(".").first.replaceAll("/", "_");
    buffer.writeln(
        "Map<String, TypeCodec<dynamic>> ${codecMapName}_codecs = ${codescMapAsString}");

    return buffer.toString();
  }

  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      var friendlyName = friendlyNameForElement(element);
      throw new InvalidGenerationSourceError(
          'Generator cannot target `$friendlyName`.',
          todo: 'Remove the Serializable annotation from `$friendlyName`.');
    }

    var classElement = element as ClassElement;
    var buffer = new StringBuffer();
    if (_isClassSerializable(element) == true &&
        classElement.isAbstract == false &&
        classElement.isPrivate == false) {
      Map<String, Field> fields = _getFields(element);
      _classCodec(buffer, classElement.displayName);
      _generateDecode(buffer, classElement, fields);
      _generateEncode(buffer, classElement, fields);
      _generateUtils(buffer, classElement);

      closeBrace(buffer);

      _codecsBuffer.writeln(
          "'${element.displayName}': new ${element.displayName}Codec(),");
    }
    return buffer.toString();
  }

  void initCodecsBuffer() {
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

  String _findGenericOfList(DartType type) {
    if (type is ParameterizedType) {
      if (type.typeArguments.length == 1) {
        var name = type.typeArguments[0].name;
        return name;
      }
    }
    return null;
  }

  String _findGenericOfMap(DartType type) {
    if (type is ParameterizedType) {
      if (type.typeArguments.length == 2) {
        var name = type.typeArguments[1].name;
        return name;
      }
    }
    return null;
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

  List<String> _numTypes = ["int", "double"];

  String _castType(Field field, [bool as = true]) {
    String type = field.useType ?? field.type.toString();
    if (_numTypes.contains(type)) {
      if (type == "int") {
        return "?.toInt()";
      } else {
        return "?.toDouble()";
      }
    }
    if (as == true) {
      return " as $type";
    }
    return "";
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
        buffer.write("?? obj.$name)${_castType(field)};");
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
          buffer.write("value.$name${_castType(field, false)};");
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
    String t = _findGenericOfMap(field.type);
    if (t == null) {
      t = _findGenericOfList(field.type);
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
    var annotationValueType = annotation.constantValue?.type;
    if (annotationValueType == null) {
      throw new ArgumentError.value(annotation, 'annotation',
          'Could not determine type of annotation. Are you missing a dependency?');
    }

    return _matchTypes(annotationType, annotationValueType);
  } catch (e, _) {
    //print(e);
    //print(s);
  }
  return false;
}

bool _matchTypes(Type annotationType, ParameterizedType annotationValueType) {
  var classMirror = reflectClass(annotationType);
  var classMirrorSymbol = classMirror.simpleName;

  var annTypeName = annotationValueType.name;
  var annotationTypeSymbol = new Symbol(annTypeName);

  if (classMirrorSymbol != annotationTypeSymbol) {
    return false;
  }

  var annotationLibSource = annotationValueType.element.library.source;

  var libOwnerUri = (classMirror.owner as LibraryMirror).uri;
  var annotationLibSourceUri = annotationLibSource.uri;

  if (annotationLibSourceUri.scheme == 'file' &&
      libOwnerUri.scheme == 'package') {
    // try to turn the libOwnerUri into a file uri
    libOwnerUri = _fileUriFromPackageUri(libOwnerUri);
  } else if (annotationLibSourceUri.scheme == 'asset' &&
      libOwnerUri.scheme == 'package') {
    // try to turn the libOwnerUri into a asset uri
    libOwnerUri = _assetUriFromPackageUri(libOwnerUri);
  }

  return annotationLibSource.uri == libOwnerUri;
}

Uri _fileUriFromPackageUri(Uri libraryPackageUri) {
  assert(libraryPackageUri.scheme == 'package');

  var fullLibraryPath = p.join(_packageRoot, libraryPackageUri.path);

  var file = new File(fullLibraryPath);

  assert(file.existsSync());

  var normalPath = file.resolveSymbolicLinksSync();

  return new Uri.file(normalPath);
}

Uri _assetUriFromPackageUri(Uri libraryPackageUri) {
  assert(libraryPackageUri.scheme == 'package');
  var originalSegments = libraryPackageUri.pathSegments;
  var newSegments = [originalSegments[0]]
    ..add('lib')
    ..addAll(originalSegments.getRange(1, originalSegments.length));

  return new Uri(scheme: 'asset', pathSegments: newSegments);
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

String get _packageRoot {
  if (_packageRootCache == null) {
    var dir = Platform.packageRoot;

    if (dir.isEmpty) {
      dir = p.join(p.current, 'packages');
    }

    // Handle the case where we're running via pub and dir is a file: URI
    dir = p.prettyUri(dir);

    assert(FileSystemEntity.isDirectorySync(dir));
    _packageRootCache = dir;
  }
  return _packageRootCache;
}

String _packageRootCache;
