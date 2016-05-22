[![Build Status](https://travis-ci.org/walletek/serializer.svg?branch=master)](https://travis-ci.org/walletek/serializer?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/walletek/serializer/badge.svg?branch=master)](https://coveralls.io/github/walletek/serializer?branch=master)
[![Pub version](https://img.shields.io/pub/v/serializer.svg)](https://pub.dartlang.org/packages/serializer)

# serializer

Serializer to JSON using reflectable.

##Example

### Import the library

    import 'package:serializer/serializer.dart';

### Define your model

    @serializable
    class MyModel {
        String name;
        
        @ignore //ignore this attribute during serialization
        num age;
    
        //constructor need to be without parameters or with optional or positional.
        MyModel([this.name, this.age]);
    }
    
### Serialize

     main() async {
        await initSerializer(
            type_info_key: "@dart_type" // add a field "@dart_type" to the json, storing the type of the type of the Dart Object, default: "@type"
        ); // initSerializer will map every class annotated with @serializable
        
        MyModel model = new MyModel("John", 24);
        String json = Serializer.toJson(model);
        Map jsonMap = Serializer.toMap(model);
        print(json);
        
     }
    
### Deserialize

    model = Serializer.fromJson(json, MyModel);
    model = Serializer.fromMap(jsonMap, MyModel);

You can extend you Model with the class `Serialize` to inherit of basic convert method.

     Map toMap();
     String toString();
     String toJson();
     
### Work with List

     String jsonList = Serializer.toJson(listModel);
     List<MyModel> list =  Serializer.fromList(jsonList, MyModel) as List<MyModel>;

[Example](https://github.com/walletek/serializer/tree/master/example)

