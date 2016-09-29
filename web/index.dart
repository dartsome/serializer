import 'dart:async';
import 'package:serializer/serializer.dart';


@serializable
class Model extends TypedJsonObject {
  String foo = "bar";

  Model();
}

//Test type with minified javascript
Future<Null> main() async {
  Serializer serializer = new Serializer.typedJson();

  print((new Model()).toJson());
  print(serializer.fromMap({'@type': 'Model', 'foo': 'test'}));
  print(serializer.decode('{"@type":"Model","foo":"toto"}'));
}
