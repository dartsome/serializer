/// The interface for creating new codecs
abstract class TypeCodec<T> {
  /// Convert a serialized [value] to a value of type [T]
  T decode(dynamic value) => value as T;

  /// Convert a [value] of type [T] to serializabled value
  dynamic encode(T value) => value;

  /// Get [T] type
  Type get type => T;
}
