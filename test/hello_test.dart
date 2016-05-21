import 'package:test/test.dart';

import 'package:smartwatch/hello.dart';

void main() {
  group('say_hello()', () {
    test('result is in form \'Hello \$name! From Dart.\'', () {
      expect(say_hello('Foo'), equals('Hello Foo! From Dart.'));
      expect(say_hello('Baz'), equals('Hello Baz! From Dart.'));
    });
    test('null throws ArgumentError', () {
      expect(() => say_hello(null), throwsArgumentError);
    });
  });
}