# Changelog

## 0.4.0

- Add DateTimeUtcCodec an UTC DateTime codec.
- Add ObjectId A simple ObjectId codec (for Mongo BSON).

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
