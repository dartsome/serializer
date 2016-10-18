import 'serializer.dart';
import 'package:bson/bson.dart';
export 'package:bson/bson.dart';

@serializable
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
}