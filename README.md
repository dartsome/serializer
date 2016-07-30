[![Build Status](https://travis-ci.org/dartsome/serializer.svg?branch=master)](https://travis-ci.org/dartsome/serializer?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/dartsome/serializer/badge.svg?branch=master)](https://coveralls.io/github/dartsome/serializer?branch=master)
[![Pub version](https://img.shields.io/pub/v/serializer.svg)](https://pub.dartlang.org/packages/serializer)

# Serializer

Serialize and Deserialize Dart Object with reflectable

## Codecs supported:
- Json

## [Example](https://github.com/walletek/serializer/tree/master/example)

```dart
import 'package:serializer/serializer.dart';

@serializable
class MyModel {
    String name;

    //constructor need to be without parameters or with optional or positional.
    MyModel([this.name]);
}

main() {
    Serializer serializer = new Serializer.Json();
    
    //serialize
    MyModel model = new MyModel("John", 24);
    String json = serializer.encode(model);
    Map jsonMap = serializer.toMap(model);

    //deserialize
    model = serializer.decode(json, MyModel);
    model = serializer.fromMap(jsonMap, MyModel);
 }
 ```
 
## [Documentations](https://github.com/walletek/serializer/wiki)
- [Getting Started](https://github.com/walletek/serializer/wiki/Getting-Started)
- [Object Definition](https://github.com/walletek/serializer/wiki/Define-your-objects)
- [Complexe objects (Map, List ...)](https://github.com/walletek/serializer/wiki/Complexe-Object)
- [JSON](https://github.com/walletek/serializer/wiki/Json)
- [More docs](https://www.dartdocs.org/documentation/serializer/0.3.0/)





