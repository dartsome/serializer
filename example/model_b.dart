import 'serializer.dart';
import 'package:bson/bson.dart';
export 'package:bson/bson.dart';
export 'model.dart';

import 'model.dart';

@serializable
class ModelB {

    Map<String, ModelC> C;
    List<ModelA> A;
    ModelA a;

    ModelB();
}

@serializable
abstract class ModelD {
    String foo;
}

@serializable
class ModelC extends ModelB with ModelD {
    ModelC([ModelA a]);
}