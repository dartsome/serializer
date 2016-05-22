/**
 * Created by lejard_h on 29/01/16.
 */

part of serializer.base;

final _SerializerJson = new Serializer.Json();
final _SerializerTypedJson = new Serializer.TypedJson();

/// Utility class for a Serializable object
@serializable
abstract class Serialize {
  /// Get the serializer instance
  @ignore
  static Serializer get serializer => null;

  /// Convert the object to a map
  Map toMap();

  /// Override the toString method to show a stringify map of the object
  String toString() => toMap().toString();
}

/// Utility class for a JSON object
@serializable
abstract class JsonObject extends Serialize {
  /// Get the JSON serializer instance
  @ignore
  static Serializer get serializer => _SerializerJson;

  /// Convert the object to a map
  Map toMap() => _SerializerJson.toMap(this);

  /// Convert the object to JSON string
  String toJson() => _SerializerJson.encode(this);
}

/// Utility class for a typed JSON object
@serializable
abstract class TypedJsonObject extends Serialize {
  /// Get the typed JSON serializer instance
  @ignore
  static Serializer get serializer => _SerializerTypedJson;

  /// Convert the object to a map
  Map toMap() => _SerializerTypedJson.toMap(this);

  /// Convert the object to JSON string
  String toJson() => _SerializerTypedJson.encode(this);
}

// Singleton that maps every class annotated with @serializable
final _singletonClasses = <String, ClassMirror>{};
_initSingletonClasses() {
  if (_singletonClasses.isEmpty) {
    for (ClassMirror classMirror in serializable.annotatedClasses) {
      if (classMirror != null
          && classMirror.simpleName != null
          && classMirror.metadata.contains(serializable)) {
        _singletonClasses[classMirror.simpleName] = classMirror;
      }
    }
  }
}

/// Utility class to access to the serializer api
class Serializer {
  static final Map<String, ClassMirror> _classes = _singletonClasses;

  /// Dump serializable classes
  static dumpSerializables() => _dumpSerializables();

  final String _typeInfoKey;
  final Codec _codec;
  final Map<String, TypeCodec> _typeCodecs = <String, TypeCodec>{};


  /// Create a Serializer with a optional codec and type info key.
  /// The type info key is an added field (i.e. "@type") during the serialization,
  /// storing the type of the Dart Object
  Serializer([this._codec = JSON, this._typeInfoKey]) {
    _initSingletonClasses();
  }

  /// Create a default JSON serializer plus a simple DateTime codec
  factory Serializer.Json() {
    return new Serializer()
      ..addTypeCodec(DateTime, new DateTimeCodec());
  }

  /// Create a default JSON serializer plus a simple DateTime codec
  /// with '@type' added field
  factory Serializer.TypedJson() {
    return new Serializer(JSON, "@type")
      ..addTypeCodec(DateTime, new DateTimeCodec());
  }

  /// Registers a [typeCodec] for the specific [type]
  addTypeCodec(Type type, TypeCodec typeCodec) =>
      _typeCodecs[type.toString()] = typeCodec;

  /// Checks if a TypeCodec is registered for the [type].
  bool hasTypeCodec(Type type) =>
      _typeCodecs.containsKey(type.toString());

  /// Get the TypeCodec for the specific [type]
  TypeCodec typeCodec(Type type) => _typeCodecs[type.toString()];

  /// Checks if a class is registered as a Serializable class.
  bool isSerializable(Type type) =>
      _classes.containsKey(type.toString());

  /// Convert the object to a Map
  Map toMap(Object input) => _toMap(input);

  /// Encode the object to serialized string
  String encode(Object input) => _encode(input);

  /// Decode the object from a seriablized string
  Object decode(String encoded, [Type type]) => _decode(encoded, type);

  /// Convert a serialized object to map
  Object fromMap(Map map, [Type type, List<Type> mapOf]) => _fromMap(map, type, mapOf);

  /// Convert a serialized object's [list] to a list of the given [type]
  List fromList(List list, [Type type]) => _fromList(list, type);


  //////////////////////////////////////////////////////////////////////////////
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
      case "Map":
      case "_JsonMap":
        return Map;
      case "List":
        return List;
      default:
        if (name == _MapTypeString) {
          return Map;
        } else if (name == _ListTypeString) {
          return List;
        } else if (_typeCodecs.containsKey(name)) {
          return _typeCodecs[name].type;
        } else {
          ClassMirror classMirror = _classes[name];
          return classMirror?.dynamicReflectedType;
        }
    }
  }

  Object _decode(String encoded, [Type type]) {
    if (encoded == null || encoded.isEmpty) {
      return null;
    }
    var value = _codec.decode(encoded);
    if (value is Map) {
      return _fromMap(value, type);
    } else if (value is List) {
      return _fromList(value, type);
    }
    return _decodeValue(value, type);
  }

  Object _fromMap(Map map, [Type type, List<Type> mapOf]) {
    if (map == null || map.isEmpty) {
      return null;
    }

    if (_typeInfoKey != null && map.containsKey(_typeInfoKey)) {
      type = _decodeType(map.remove(_typeInfoKey));
    } else {
      type ??= Map;
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

    var visitedNames = [];
    while (cm != null
        && cm.superclass != null
        && _classes.containsKey(cm.simpleName)) {
      cm.declarations.forEach((String originalName, DeclarationMirror dec) {
        var name = _serializedName(dec);
        if (   map.containsKey(name)
            && !visitedNames.contains(name)
            && !_hasMetadata(dec, Ignore)
            && (   (dec is VariableMirror && _isSerializableVariable(dec))
                || (dec is MethodMirror))) {
          var value = _decodeValue(map[name], cm.instanceMembers[originalName].reflectedReturnType);
          if (value != null) {
            instance.invokeSetter(originalName, value);
            visitedNames.add(name);
          }
        }
      });
      cm = cm?.superclass;
    }

    return instance.reflectee;
  }

  List _fromList(List list, [Type type]) {
    List data = new List();
    list.forEach((value) => data.add(_decodeValue(value, type)));
    return data;
  }

  Object _decodeValue(Object value, Type type) {
    type ??= _decodeType(value.runtimeType.toString());
    if (hasTypeCodec(type)) {
      return typeCodec(type).decode(value);
    } else if (type.toString().startsWith("Map")) {
      return _fromMap(value, Map, _findGenericOfMap(type));
    } else if (type.toString().startsWith("List")) {
      return _fromList(value, _findGenericOfList(type));
    } else if (isSerializable(type)) {
      return _fromMap(value, type);
    } else if (type == null || _isPrimaryType(type)) {
      return value;
    }
    return null;
  }

  Object _encodeValue(value) {
    if (hasTypeCodec(value.runtimeType)) {
      return typeCodec(value.runtimeType).encode(value);
    } else if (value is Map || isSerializable(value.runtimeType)) {
      return _toMap(value);
    } else if (value is List) {
      return _encodeList(value);
    } else if (_isPrimaryType(value.runtimeType)) {
      return value;
    }
    return null;
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

    if (_typeInfoKey != null) {
      data[_typeInfoKey] = obj.runtimeType.toString();
    }

    while (cm != null
        && cm.superclass != null
        && _classes.containsKey(cm.simpleName)) {
      cm.declarations.forEach((String originalName, DeclarationMirror dec) {
        var name = _serializedName(dec);

        if (   !data.containsKey(name)
            && !_hasMetadata(dec, Ignore)
            && (   (dec is VariableMirror && _isSerializableVariable(dec))
                || (dec is MethodMirror && dec.isGetter))) {
          _encodeMap(data, name, mir.invokeGetter(originalName));
        }
      });
      cm = cm?.superclass;
    }
    return data;
  }

  String _encode(Object obj) {
    if (obj == null) {
      return null;
    }
    if (obj is List) {
      return _codec.encode(_encodeList(obj));
    }
    return _codec.encode(_toMap(obj));
  }
}
