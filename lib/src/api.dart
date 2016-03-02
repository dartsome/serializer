/**
 * Created by lejard_h on 29/01/16.
 */

part of serializer.base;

@serializable
abstract class Serialize {
  Map get toMap => Serializer.toMap(this);
  String toString() => toMap.toString();
  String toJson() => JSON.encode(toMap);
}

class Serializer {
  static final Map<String, ClassMirror> classes = <String, ClassMirror>{};
  static Type max_superclass_type = Serialize;
  static Map toMap(Object obj) => _toMap(obj);
  static String toJson(Object obj) => _toJson(obj);
  static Object fromJson(String json, Type type) => _fromJson(json, type);
  static Object fromMap(Map json, Type type) => _fromMap(json, type);
  static Object fromList(List json, Type type) => _fromList(json, type);
}
