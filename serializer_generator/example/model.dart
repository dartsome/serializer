import 'serializer.dart';
import 'package:bson/bson.dart';

export 'package:bson/bson.dart';

@serializable
class User {
  String login;
  @ignore
  String password;

  final String toto = "truc";

  @ignore
  bool get isAdmin => true;
}

@serializable
class Id implements Identifiable {
  @SerializedName("_id")
  @UseType(ObjectId)
  dynamic id;

  @override
  ObjectId getId() => id as ObjectId;

  @override
  void setId(ObjectId id) {
    this.id = id;
  }
}

@serializable
abstract class Identifiable {
  dynamic id;
  ObjectId getId();
  void setId(ObjectId id);
}

@serializable
abstract class Entity {
  @SerializedName("d")
  DateTime creationDate;
}

@serializable
abstract class CustomEntity extends Entity with Id {
  String entity;
}

@serializable
abstract class CustomUserEntity extends CustomEntity {
  @SerializedName("n")
  String name;
}

@serializable
class Model {
  String foo = "bar";
}

@serializable
class CustomUser extends CustomUserEntity with User {
  String test;
  Map<String, Model> models;
}
