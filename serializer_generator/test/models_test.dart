import 'package:serializer/serializer.dart';

@serializable
class M1 {
    String m1;
}

@serializable
class M2 {
    String m2;
}

@referenceable
@serializable
class Employee {
    @reference
    int id;
    String name;
    Address address;
    Employee manager;
}

@referenceable
@serializable
class Address {
    @reference
    int id;
    String location;
    Employee owner;
}

@serializable
class WithStaticConst {
    static const String GLOBAL = "GLOBAL";
    String other;
}

@serializable
class WithStatic {
    static String global = "GLOBAL";
    String other;
}

@serializable
class Pet {
    String  name;
    dynamic animal;
}

@serializable
abstract class Animal {}

@serializable
class Dog extends Animal {
    String name;
    bool bark;
}

@serializable
class Cat extends Animal {
    String name;
    bool mew;
}

@serializable
class PetWithTypeInfo {
    String name;

    @serializedWithTypeInfo
    Animal animal;
}
