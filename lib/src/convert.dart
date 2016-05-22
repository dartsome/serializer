/**
 * Created by lejard_h on 29/01/16.
 */

part of serializer.base;

final String _MapTypeString  = {}.runtimeType.toString();
final String _ListTypeString = [].runtimeType.toString();

bool _isSerializableVariable(DeclarationMirror vm) {
  return !vm.isPrivate;
}

bool _isPrimaryType(Type obj) =>
    obj == num || obj == String || obj == bool || obj == int || obj == double;


bool _hasMetadata(DeclarationMirror dec, Type type) {
  for (var data in dec?.metadata) {
    if (data.runtimeType == type) {
      return true;
    }
  }
  return false;
}

Object _metadata(DeclarationMirror dec, Type type) {
  for (var data in dec?.metadata) {
    if (data.runtimeType == type) {
      return data;
    }
  }
  return null;
}

String _serializedName(DeclarationMirror dec) {
  SerializedName serializedName = _metadata(dec, SerializedName);
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

Map<String, dynamic> _dumpSerializables() {
  _initSingletonClasses();
  _singletonClasses.values.forEach((classMirror) {
    var cm = classMirror;

    print(cm.simpleName);
    while (cm != null
        && cm.superclass != null
        && _singletonClasses.containsValue(cm)) {
      print("  " + cm.simpleName);
      cm.declarations.forEach((symbol, decl) {
        if (!decl.isPrivate) {
          String name = symbol;
          Type type;
          bool isSetter  = false;
          bool isGetter  = false;
          bool isIgnored = _hasMetadata(decl, Ignore);
          String renamed = _serializedName(decl);

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
            line += isSetter  ? "G" : "-";
            line += isGetter  ? "S" : "-";
            line += isIgnored ? "I" : "-";
            line += ": $type $name";
            line += renamed != name ? " => $renamed" : "";
            print(line);
          }
        }
      });
      cm = cm?.superclass;
    }
  });
}
