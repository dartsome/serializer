/**
 * Created by lejard_h on 29/01/16.
 */

part of serializer.base;

bool _isSerializableVariable(DeclarationMirror vm) {
  return !vm.isPrivate;
}

bool _isObjPrimaryType(Object obj) => _isPrimaryType(obj.runtimeType);

bool _isPrimaryType(Type obj) =>
    obj == num || obj == String || obj == bool || obj == int || obj == double;

Type _decodeType(String name) {
  ClassMirror classMirror = Serializer.classes[name];
  return classMirror?.dynamicReflectedType;
}

String findGenericOfList(Type type) {
  String str = type.toString();
  RegExp reg = new RegExp(r"^List<(.*)>$");
  Iterable<Match> matches = reg.allMatches(str);
  if (matches == null || matches.isEmpty) {
    return null;
  }
  return matches.first.group(1);
}

List _fromList(List list, Type type) {
  List _list = new List.from(list);

  for (var i = 0; i < _list.length; i++) {
    if (_list[i] is String &&
        ((_list[i][0] == '"' && _list[i][_list[i].length - 1] == '"') ||
            (_list[i][0] == '{' && _list[i][_list[i].length - 1] == '}') ||
            (_list[i][0] == '[' && _list[i][_list[i].length - 1] == ']'))) {
      _list[i] = JSON.decode(_list[i]);
    }
    Type _type = type;
    if (_list[i] is Map && _list[i].containsKey(type_info_key)) {
      _type = _decodeType(_list[i][type_info_key]);
    }
    _list[i] = _decode(_list[i], _type ?? type);
  }
  return _list;
}

bool _asMetadata(DeclarationMirror dec, Type type) {
  for (var data in dec?.metadata) {
    if (data.runtimeType == type) {
      return true;
    }
  }
  return false;
}

Object _fromMap(Map json, Type type) {
  if (json == null || json.isEmpty) {
    return null;
  }
  json.remove(type_info_key);
  json.remove("useCache");

  if (type == Map) {
    return new Map.from(json);
  }

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

  for (var key in json.keys) {
    MethodMirror dec = cm.instanceMembers[key];
    if (dec != null &&
        _isSerializableVariable(dec) &&
        !_asMetadata(dec, Ignore)) {
      if (_isPrimaryType(dec.reflectedReturnType)) {
        instance.invokeSetter(key, json[key]);
      } else if (dec.reflectedReturnType == DateTime) {
        instance.invokeSetter(key, DateTime.parse(json[key]));
      } else {
        instance.invokeSetter(key, _decode(json[key], dec.reflectedReturnType));
      }
    }
  }

  return instance.reflectee;
}

Object _decode(Object decode, Type type) {
  if (decode is Map) {
    return _fromMap(decode, type);
  } else if (decode is List) {
    return _fromList(decode, type);
  }
  return decode;
}

Object _fromJson(String json, Type type) {
  if (json == null || json.isEmpty) {
    return null;
  }
  return _decode(JSON.decode(json), type);
}

List _convertList(List list) {
  List _list = new List.from(list);
  for (var elem in list) {
    if (elem is List) {
      elem = _convertList(elem);
    } else if (elem is Map ||
        elem is Serialize ||
        Serializer.classes.containsKey(elem.runtimeType.toString())) {
      elem = _toMap(elem);
    }
  }
  return _list;
}

bool _isValidGetterName(String name) =>/* name != 'toString' && */name != 'toMap' && name != 'toJson';

Map _toMap(Object obj) {
  if (obj == null || obj is List) {
    return null;
  }
  if (obj is Map) {
    Map data = new Map.from(obj);
    data[type_info_key] = obj.runtimeType.toString();
    data.forEach((key, value) {
      if (value is List) {
        data[key] = _convertList(value);
      } else if (value is Map ||
          value.runtimeType is Serialize ||
          Serializer.classes.containsKey(value.runtimeType.toString())) {
        data[key] = _toMap(value);
      }
    });
    return data;
  }
  InstanceMirror mir = serializable.reflect(obj);
  ClassMirror cm = mir.type;
  Map data = new Map();

  data[type_info_key] = obj.runtimeType.toString();

  while (cm != null &&
      cm.superclass != null &&
      cm.reflectedType != Serializer.max_superclass_type) {
    cm.declarations.forEach((String key, DeclarationMirror dec) {
      if (((dec is VariableMirror && _isSerializableVariable(dec)) ||
              (dec is MethodMirror && dec.isGetter)) &&
          !_asMetadata(dec, Ignore) && _isValidGetterName(dec.simpleName)) {
        var value = mir.invokeGetter(dec.simpleName);
        if (_isObjPrimaryType(value)) {
          data[key] = value;
        } else if (value is Map ||
            Serializer.classes.containsKey(value.runtimeType.toString())) {
          data[key] = _toMap(value);
        } else if (value is List) {
          data[key] = _convertList(value);
        } else if (value is DateTime) {
          data[key] = value.toString();
        }
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
