/**
 * Created by lejard_h on 29/01/16.
 */

part of serializer.base;

class Serializer {
  static final Map<String, ClassMirror> classes = <String, ClassMirror>{};
  static Map toMap(Object obj) => _toMap(obj);
  static String toJson(Object obj) => _toJson(obj);
  static Object fromJson(String json, Type type) => _fromJson(json, type);
  static Object fromMap(Map json, Type type) => _fromMap(json, type);
  static Object fromList(List json, Type type) => _fromList(json, type);
}
