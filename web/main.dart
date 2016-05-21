import 'dart:html';

import 'package:smartwatch/hello.dart';

void main() {
  querySelector('#output').text = say_hello('World');
}
