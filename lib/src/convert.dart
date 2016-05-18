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

bool _isObjPrimaryType(Object obj) => _isPrimaryType(obj.runtimeType);

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
    case "DateTime":
      return DateTime;
    default:
      ClassMirror classMirror = Serializer.classes[name];
      return classMirror?.dynamicReflectedType;
  }
}

List _fromList(List list, [Type type]) {
  List data = new List();
  list.forEach((value) => data.add(_decode(value, type)));
  return data;
}

bool _asMetadata(DeclarationMirror dec, Type type) {
  for (var data in dec?.metadata) {
    if (data.runtimeType == type) {
      return true;
    }
  }
  return false;
}

Object _fromMap(Map map, [Type embedType]) {
  if (map == null || map.isEmpty) {
    return null;
  }
  var type = _decodeType(map.remove(_type_info_key));

  // Only Map
  if (type == null) {
    Map data = new Map();
    map.forEach((key, value){
      if (value is Map) {
        data[key] = _fromMap(value);
      } else if (value is List) {
        data[key] = _fromList(value, type);
      } else if (embedType == DateTime) {
        data[key] = DateTime.parse(value);
      } else {
        data[key] = value;
      }
    });
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
    print(e);
    return null;
  }

  for (var key in map.keys) {
    MethodMirror met = cm.instanceMembers[key];
    DeclarationMirror dec = cm.declarations[key];
    if (met != null
        && dec != null
        && _isSerializableVariable(met)
        && !_asMetadata(dec, Ignore)) {
      var _type = met.reflectedReturnType;
      if (_isPrimaryType(_type)) {
        instance.invokeSetter(key, map[key]);
      } else if (_type == DateTime) {
        instance.invokeSetter(key, DateTime.parse(map[key]));
      } else if (_type.toString().startsWith("List")) {
        var listOf = _findGenericOfList(_type);
        if (_isPrimaryType(listOf)) {
          instance.invokeSetter(key, _fromList(map[key]));
        } else if (listOf == DateTime) {
          instance.invokeSetter(key, _fromList(map[key], DateTime));
        } else if (Serializer.classes.containsKey(listOf.toString())) {
          instance.invokeSetter(key, _fromList(map[key], listOf));
        }
      } else if (_type.toString().startsWith("Map")) {
        var mapOf = _findGenericOfMap(_type);
        if (_isPrimaryType(mapOf[1])) {
          instance.invokeSetter(key, _fromMap(map[key]));
        } else if (mapOf[1] == DateTime) {
          instance.invokeSetter(key, _fromMap(map[key], DateTime));
        } else {
          instance.invokeSetter(key, _fromMap(map[key]));
        }
      } else if (Serializer.classes.containsKey(_type.toString())) {
        instance.invokeSetter(key, _fromMap(map[key]));
      }
    }
  }

  return instance.reflectee;
}

Object _decode(Object decode, [Type type]) {
  if (decode is Map) {
    return _fromMap(decode);
  } else if (decode is List) {
    return _fromList(decode, type);
  } else if (type == DateTime) {
    return DateTime.parse(decode);
  }
  return decode;
}

Object _fromJson(String json) {
  if (json == null || json.isEmpty) {
    return null;
  }
  return _decode(JSON.decode(json));
}

List _convertList(List list) {
  return list.map((elem) {
    if (elem is Map ||
        Serializer.classes.containsKey(elem.runtimeType.toString())) {
      return _toMap(elem);
    } else if (elem is List) {
      return _convertList(elem);
    } else if (elem is DateTime) {
      return elem.toIso8601String();
    } else if (_isObjPrimaryType(elem)) {
      return elem;
    }
  }).toList(growable: false);
}

_convertMap(Map data, key, value) {
  if (value is Map ||
      Serializer.classes.containsKey(value.runtimeType.toString())) {
    data[key] = _toMap(value);
  } else if (value is List) {
    data[key] = _convertList(value);
  } else if (value is DateTime) {
    data[key] = value.toIso8601String();
  } else if (_isObjPrimaryType(value)) {
    data[key] = value;
  }
}

bool _isValidGetterName(String name) =>/* name != 'toString' && */name != 'toMap' && name != 'toJson';

Map _toMap(Object obj) {
  if (obj == null || obj is List) {
    return null;
  }
  if (obj is Map) {
    Map data = new Map();
    obj.forEach((key, value) => _convertMap(data, key, value));
    return data;
  }
  InstanceMirror mir = serializable.reflect(obj);
  ClassMirror cm = mir.type;
  Map data = new Map();
  data[_type_info_key] = obj.runtimeType.toString();

  while (cm != null
      && cm.superclass != null
      && Serializer.classes.containsKey(cm.simpleName)) {
    cm.declarations.forEach((String key, DeclarationMirror dec) {
      if (((dec is VariableMirror && _isSerializableVariable(dec)) ||
          (dec is MethodMirror && dec.isGetter)) &&
          !_asMetadata(dec, Ignore) && _isValidGetterName(dec.simpleName)) {
        _convertMap(data, key, mir.invokeGetter(dec.simpleName));
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
    return JSON.encode(_convertList(obj));
  }
  return JSON.encode(_toMap(obj));
}
