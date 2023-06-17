import 'package:ddiff/ddiff.dart' as ddiff;

void main(List<String> args) {
  assert(args.length == 2, "There must be two string to compare.");

  final result = ddiff.levenshtein(args[1], args[0]).reversed.join('');
  print(result);
}
