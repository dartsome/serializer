/**
 * Created by lejard_h on 29/01/16.
 */

part of serializer.base;

List<Type> _findGenericOfMap(Type type) {
  String str = type.toString();
  RegExp reg = new RegExp(r"^Map<(.*)\ *,\ *(.*)>$");
  Iterable<Match> matches = reg.allMatches(str);
  if (matches == null || matches.isEmpty) {
    return null;
  }
  return [ _decodeType(matches.first.group(1)), _decodeType(matches.first.group(2))];
}

Type _findGenericOfList(Type type) {
  String str = type.toString();
  RegExp reg = new RegExp(r"^List<(.*)>$");
  Iterable<Match> matches = reg.allMatches(str);
  if (matches == null || matches.isEmpty) {
    return null;
  }
  return _decodeType(matches.first.group(1));
}

bool _isSerializableVariable(DeclarationMirror vm) {
  return !vm.isPrivate;
}

bool _isPrimaryType(Type obj) =>
    obj == num || obj == String || obj == bool || obj == int || obj == double;

Type _decodeType(String name) {
  switch (name) {
    case "num":
      return num;
    case "String":
      return String;
    case "bool":
      return bool;
    case "int":
      return int;
    case "double":
      return double;
    default:
      if (Serializer.codecs.containsKey(name)) {
        return Serializer.codecs[name].type;
      } else {
        ClassMirror classMirror = Serializer.classes[name];
        return classMirror?.dynamicReflectedType;
      }
  }
}

List _fromList(List list, [Type type]) {
  List data = new List();
  list.forEach((value) => data.add(_decodeValue(value, type)));
  return data;
}

bool _hasMetadata(DeclarationMirror dec, Type type) {
  for (var data in dec?.metadata) {
    if (data.runtimeType == type) {
      return true;
    }
  }
  return false;
}

Object _fromMap(Map map, [Type type = Map, List<Type> mapOf]) {
  if (map == null || map.isEmpty) {
    return null;
  }

  if (_type_info_key != null && map.containsKey(_type_info_key)) {
    type = _decodeType(map.remove(_type_info_key));
  }

  // Only Map
  if (type == Map) {
    Type embedType = mapOf != null ? mapOf[1] : null;
    Map data = new Map();
    map.forEach((key, value) => data[key] = _decodeValue(value, embedType));
    return data;
  }

  // Class from Map
  ClassMirror cm;
  Object obj;
  InstanceMirror instance;
  try {
    cm = serializable.reflectType(type);
    obj = cm.newInstance('', []);
    instance = serializable.reflect(obj);
  } catch (e) {
    throw e.toString();
  }

  for (var key in map.keys) {
    MethodMirror met = cm.instanceMembers[key];
    DeclarationMirror dec = cm.declarations[key];
    if (met != null
        && dec != null
        && _isSerializableVariable(met)
        && !_hasMetadata(dec, Ignore)) {
      var value = _decodeValue(map[key], met.reflectedReturnType);
      if (value != null) {
        instance.invokeSetter(key, value);
      }
    }
  }

  return instance.reflectee;
}

Object _fromJson(String json, [Type type]) {
  if (json == null || json.isEmpty) {
    return null;
  }
  var value = JSON.decode(json);
  if (value is Map) {
    return _fromMap(value, type);
  } else if (value is List) {
    return _fromList(value, type);
  }
  return _decodeValue(value, type);
}

Object _decodeValue(Object value, Type type) {
  if (Serializer.codecs.containsKey(type.toString())) {
    return Serializer.codecs[type.toString()].decode(value);
  } else if (type.toString().startsWith("Map")) {
    return _fromMap(value, Map, _findGenericOfMap(type));
  } else if (type.toString().startsWith("List")) {
    return _fromList(value, _findGenericOfList(type));
  } else if (Serializer.classes.containsKey(type.toString())) {
    return _fromMap(value, type);
  } else if (type == null || _isPrimaryType(type)) {
    return value;
  }
}

Object _encodeValue(value) {
  if (Serializer.codecs.containsKey(value.runtimeType.toString())) {
    return Serializer.codecs[value.runtimeType.toString()].encode(value);
  } else if (value is Map || Serializer.classes.containsKey(value.runtimeType.toString())) {
    return _toMap(value);
  } else if (value is List) {
    return _encodeList(value);
  } else if (_isPrimaryType(value.runtimeType)) {
    return value;
  }
}

List _encodeList(List list) {
  return list.map((elem) => _encodeValue(elem))
      .toList(growable: false);
}

_encodeMap(Map data, key, value) {
  value = _encodeValue(value);
  if (value != null) {
    data[key] = value;
  }
}

bool _isValidGetterName(String name) => /* name != 'toString' && */name != 'toMap' && name != 'toJson';

Map _toMap(Object obj) {
  if (obj == null || obj is List) {
    return null;
  }
  if (obj is Map) {
    Map data = new Map();
    obj.forEach((key, value) => _encodeMap(data, key, value));
    return data;
  }
  InstanceMirror mir = serializable.reflect(obj);
  ClassMirror cm = mir.type;
  Map data = new Map();

  if (_type_info_key != null) {
    data[_type_info_key] = obj.runtimeType.toString();
  }

  while (cm != null
      && cm.superclass != null
      && Serializer.classes.containsKey(cm.simpleName)) {
    cm.declarations.forEach((String key, DeclarationMirror dec) {
      if (((dec is VariableMirror && _isSerializableVariable(dec)) ||
          (dec is MethodMirror && dec.isGetter)) &&
          !_hasMetadata(dec, Ignore) && _isValidGetterName(dec.simpleName)) {
        _encodeMap(data, key, mir.invokeGetter(dec.simpleName));
      }
    });
    cm = cm?.superclass;
  }
  return data;
}

_toJson(Object obj) {
  if (obj == null) {
    return null;
  }
  if (obj is List) {
    return JSON.encode(_encodeList(obj));
  }
  return JSON.encode(_toMap(obj));
}
