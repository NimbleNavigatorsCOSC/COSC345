library hello;

String say_hello (String name) {
  if (name == null) throw new ArgumentError('name cannot be null');
  return 'Hello $name! From Dart.';
}