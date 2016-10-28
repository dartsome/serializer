import 'serializer.dart';
import 'package:bson/bson.dart';
export 'package:bson/bson.dart';

/*@serializable
class ModelA {
  @SerializedName("_id")
  ObjectId id;

  String name;

  num _age;

  num get age => _age;
  set age(val) {
    _age = val;
  }

  @ignore
  String toto = "bidule";

  String plop = null;

  ModelA([this.id, this.name, this._age]);
}*/

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
  ObjectId id;

  @override
  ObjectId getId() => id;

  @override
  void setId(dynamic id) {
    if (id is String) {
      this.id = ObjectId.parse(id);
    } else {
      this.id = id;
    }
  }
}

@serializable
abstract class Identifiable {
  dynamic id;
  dynamic getId();
  void setId(dynamic id);
}

@serializable
abstract class Titi {
  String titi;
}

@serializable
abstract class Toto extends Titi with Id {
  String toto;
}

@serializable
abstract class Entity {
  @SerializedName("d")
  DateTime creationDate;
}


@serializable
abstract class CustomEntity extends Entity with Toto {
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
