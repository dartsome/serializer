import 'package:serializer_generator/serializer_generator.dart' as serializer;
import 'files.dart';

main() async {
  await serializer.build(library, files);
}
