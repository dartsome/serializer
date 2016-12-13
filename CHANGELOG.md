# Changelog

## 0.5.1

- Fix int/double/num conversion

## 0.5.0

- Update `reflectable` to 1.0.0

**Breaking changes:**

- Split the serializer in 2 versions:
    + codegen
    + reflectable
- Add `@UseType` annotation only for codegen
- Same API, change import to switch mode

### Example
```dart
    import "package:serializer/serializer_codegen.dart";
    Serializer ser = new CodegenSerializer.json();
```
or
```dart
    import "package:serializer/serializer_reflectable.dart";
    Serializer ser = new ReflectableSerializer.json();
```
- [Example](https://github.com/walletek/serializer/tree/master/example/serializer_example.dart)

## 0.4.3

- Add DateTime codecs for seconds and milliseconds since epoch.
- Add dynamic type serialization.
- Add SerializedWithTypeInfo annotation to set typeInfo at the object's root.
- withTypeInfo flag into Serializer methods only sets typeInfo at the object's root. 

**Breaking changes:**

- Fix coding style for Serializer factories.

## 0.4.2

**Breaking changes:**

- Add useTypeInfo boolean to Serializer constructor.
- Replace optional parameters with named parameters into Serializer methods.
- useTypeInfo flag into Serializer methods could overidde the global useTypeInfo from instance. 

## 0.4.1+1

- fix decode when content is already decode.

## 0.4.1

- Add `toPrimaryObject` method
- fix some error with null

## 0.4.0+1

- Minor fix when some value are Null.
- Don't serialize static and const field

## 0.4.0

- Add DateTimeUtcCodec an UTC DateTime codec.
- Add ObjectId a simple ObjectId codec (for Mongo BSON).

**Breaking changes:**

- Move codecs/codec.dart to codecs.dart
- In class Serialize, serializer getter is no more static.
- Remove DateTimeCodec from Serializer.Json and Serializer.TypedJson factories

## 0.3.2
- Support cyclical objects (@referenceable & @reference annotations)
- Support SerializedName class inheritance

## 0.3.1
- Support mixins

## 0.3.0
- `type_info_key` is now optional

**Breaking changes:**

- no `initSerializer` function anymore, instead, you have to instanciate a serializer classe
    * `Serializer serializer = new Serializer.Json();`
- `toJson` and `fromJson` replace by `encode` and `decode`
    * see [doc](https://www.dartdocs.org/documentation/serializer/0.2.1/) for more infos

## 0.2.0
- `type_info_key` is now parametrable
- json output is now simpler

## 0.1.0
- Basic JSON serialization and desarialization
