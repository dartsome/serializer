/**
 * Created by lejard_h on 29/01/16.
 */

part of serializer.base;

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
    return dec.simpleName;
  }
}
