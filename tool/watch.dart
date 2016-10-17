import 'package:serializer/build.dart' as serializer;
import 'files.dart';

main() async {
  await serializer.watch(library, files);
}
