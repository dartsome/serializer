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
class Serializer {
  static final Map<String, ClassMirror> classes = <String, ClassMirror>{};
  //static Type max_superclass_type = Serialize;

  /// Convert the object to a Map<String, dynamic>
  static Map toMap(Object obj) => _toMap(obj);

  /// Convert the object to JSON
  static String toJson(Object obj) => _toJson(obj);

  /// Convert a JSON String to the given Type
  static Object fromJson(String json, Type type) => _fromJson(json, type);

  /// Convert a Map<String, dynamic> to the given Type
  static Object fromMap(Map json, Type type) => _fromMap(json, type);

  /// Convert a JSON String list to a List of the given Type
  static Object fromList(List json, Type type) => _fromList(json, type);
}

/**
 * Init the Serializer by mapping every class annotated with @serializable
 *
 * [type_info_key] define the key use to store the type of the Dart Object inside JSON and Map
 */
initSerializer({String type_info_key: "@type"}) {
  _type_info_key = type_info_key;
  for (ClassMirror classMirror in serializable.annotatedClasses) {
    if (classMirror != null
        && classMirror.simpleName != null
        && classMirror.metadata.contains(serializable)) {
      Serializer.classes[classMirror.simpleName] = classMirror;
    }
  }
}