// Copyright (c) 2016, the Serializer project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:reflectable/reflectable.dart';

import '../core.dart';
import 'annotations.dart';

bool isSerializableClassMirror(Map<String, ClassSerialiazerInfo> serializables, ClassMirror cm) {
  return serializables.containsKey(cm.mixin.simpleName);
}

bool isSerializableVariable(VariableMirror vm) {
  return !vm.isPrivate && !vm.isConst && !vm.isStatic;
}

String serializedName(DeclarationMirror dec) {
  SerializedName serializedName = serializedNameMetadataManager.metadata(dec);
  if (serializedName != null) {
    return serializedName.name;
  } else {
    var name = dec.simpleName;
    if (dec is MethodMirror && dec.isSetter) {
      name = name.substring(0, name.length - 1);
    }
    return name;
  }
}

bool isEncodeableField(Map<String, ClassSerialiazerInfo> serializables, ClassMirror cm, DeclarationMirror dec, bool withReferenceable) {
  return withReferenceable || !serializables[cm.mixin.simpleName].isReferenceable || referenceMetadataManager.hasMetadata(dec);
}

_printToString(String data) => "$data\n";

String printAndDumpSerializables() {
  String output = "";
  initSingletonClasses();
  singletonClasses.values.forEach((classInfo) {
    var cm = classInfo.classMirror;
    output += _printToString(cm.mixin.simpleName);
    if (classInfo.isReferenceable) {
      print(cm.mixin.simpleName + " (with Reference)");
    } else {
      print(cm.mixin.simpleName);
    }
    while (cm != null
        && cm.superclass != null
        && isSerializableClassMirror(singletonClasses, cm)) {
      output += _printToString("  " + cm.mixin.simpleName);
      print("  " + cm.mixin.simpleName);
      cm.declarations.forEach((symbol, decl) {
        if (!decl.isPrivate) {
          String name = symbol;
          Type type;
          bool isSetter  = false;
          bool isGetter  = false;
          bool isIgnored = ignoreMetadataManager.hasMetadata(decl);
          bool isRef     = referenceMetadataManager.hasMetadata(decl);
          String renamed = serializedName(decl);

          if (decl is VariableMirror) {
            type = decl.reflectedType;
            if (!decl.isConst && !decl.isFinal) {
              isSetter = true;
            }
            if (!decl.isConst && !decl.isStatic) {
              isGetter = true;
            }
          } else if (decl is MethodMirror) {
            if (decl.isSetter) {
              // Remove ending '='
              name = name.substring(0, name.length - 1);
              type = decl.parameters[0].reflectedType;
              isSetter = true;
            }
            if (decl.isGetter) {
              type = decl.reflectedReturnType;
              isGetter = true;
            }
          }

          if (type != null) {
            var line = "    ";
            line += isRef     ? "R" : "-";
            line += isSetter  ? "G" : "-";
            line += isGetter  ? "S" : "-";
            line += isIgnored ? "I" : "-";
            line += ": $type $name";
            line += renamed != name ? " => $renamed" : "";
            output += _printToString(line);
            print(line);
          }
        }
      });
      cm = cm?.superclass;
    }
  });
  return output;
}


// Singleton that maps every class annotated with @serializable
class ClassSerialiazerInfo {
  ClassMirror classMirror;
  bool        isReferenceable;
  ClassSerialiazerInfo(this.classMirror, this.isReferenceable);
}


final singletonClasses = <String, ClassSerialiazerInfo>{};
final correspondingMinifiedTypes = <String, String>{};
initSingletonClasses() {
  if (singletonClasses.isEmpty) {
    for (ClassMirror classMirror in serializable.annotatedClasses) {
      if (classMirror != null
          && classMirror.simpleName != null
          && classMirror.metadata.contains(serializable)) {

        // Searching for referenceable annotation
        var isReferenceable = false;
        var cm = classMirror;
        while (cm != null && cm.superclass != null) {
          isReferenceable = isReferenceable || referenceableMetadataManager.hasMetadata(cm);
          cm = cm?.superclass;
        }

       // singletonClasses[classMirror.reflectedType.toString()] = new ClassSerialiazerInfo(classMirror, isReferenceable);
        singletonClasses[classMirror.simpleName] = new ClassSerialiazerInfo(classMirror, isReferenceable);
        correspondingMinifiedTypes[classMirror.reflectedType.toString()] = classMirror.simpleName;
      }
    }
  }
}
