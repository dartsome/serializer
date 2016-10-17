import 'serializer.dart';
import 'package:bson/bson.dart';
export 'package:bson/bson.dart';

@serializable
class ModelA {
    @SerializedName("_id")
    ObjectId id;

    String name;
    num age;

    @ignore
    String toto = "bidule";

    String plop = null;

    ModelA([this.id, this.name, this.age]);
}

@serializable
class ModelB {

    ModelA a;

    ModelB([this.a]);
}