/**
 * Created by lejard_h on 29/01/16.
 */

part of serializer.base;

/**
 * Utility class for a Serializable object
 */
@serializable
abstract class Serialize {

  /// Convert the object to a Map<String, dynamic>
  Map toMap() => Serializer.toMap(this);

  /// Override the toString method to show a Stringify map of the object
  String toString() => toMap().toString();

  /// Convert the object to JSON
  String toJson() => Serializer.toJson(this);
}

/**
 * Utility class to access to the serializer api
 */
abstract class Serializer {
  static final Map<String, ClassMirror> classes = <String, ClassMirror>{};
  //static Type max_superclass_type = Serialize;

  /// Convert the object to a Map<String, dynamic>
  static Map toMap(Object obj) => _toMap(obj);

  /// Convert the object to JSON
  static String toJson(Object obj) => _toJson(obj);

  /// Convert a JSON String
  static Object fromJson(String json, [Type type]) => _fromJson(json, type);

  /// Convert a Map<String, dynamic>
  static Object fromMap(Map map, [Type type, List<Type> mapOf]) => _fromMap(map, type, mapOf);

  /// Convert a JSON String list to a List of the given Type
  static Object fromList(List list, Type type) => _fromList(list, type);
}

/**
 * Init the Serializer by mapping every class annotated with @serializable
 */
initSerializer() {
  for (ClassMirror classMirror in serializable.annotatedClasses) {
    if (classMirror != null
        && classMirror.simpleName != null
        && classMirror.metadata.contains(serializable)) {
      Serializer.classes[classMirror.simpleName] = classMirror;
    }
  }
}