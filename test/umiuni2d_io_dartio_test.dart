import 'package:umiuni2d_io_dartio/umiuni2d_io.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {

    setUp(() {
    });

    test('First Test', () async {
      FileSystem fs = new FileSystem();
      Directory d = await fs.getHomeDirectory();
      print(d.path);
    });
  });
}
