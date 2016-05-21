import 'package:serializer/type_codec.dart';

/// A simple DateTime codec
class DateTimeCodec extends TypeCodec<DateTime> {
  DateTime decode(dynamic value) => DateTime.parse(value);
  dynamic encode(DateTime value) => value.toIso8601String();
}
