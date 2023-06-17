import 'dart:math';
import 'dart:io';

enum Action { 
  add('ADD','\x1B[0;32m' ), 
  remove('REM', '\x1B[0;31m'), 
  ignore('IGN', '\x1B[0;37m'); 

  final String str; 
  final String ansii; 
  const Action(this.str, this.ansii);
}

class Step {
  final Action action;
  final int distance;
  final String letter;

  const Step(this.action, this.distance, this.letter);

  @override
  String toString() {
    return '${action.ansii}$letter';
  }
}

void printc(List<List<Step?>> cache) {
  for (final row in cache) {
    stdout.write('[ ');
    for(final col in row) {
      stdout.write('${col.toString().padLeft(6)} ');
    }
    stdout.write(']\n');
  }
}


List<String> levenshtein(String s1,String s2) {
  final m1 = s1.length;
  final m2 = s2.length;

  final cache= List<List<Step?>>.generate(
    m1 + 1, 
    (_) => List<Step?>.generate(m2 + 1, (__) => null, growable: false),
    growable: false,
  );

  cache[0][0] = Step(Action.ignore, 0, "-");

  for(int n2 = 1; n2 <= m2; n2++){
    cache[0][n2] = Step(Action.remove, n2, s2[n2-1]);
  }
  for(int n1 = 1; n1 <= m1; n1++){
    cache[n1][0] = Step(Action.add, n1, s1[n1-1]);
  }

  for(int n1 = 1; n1 <= m1; n1++){
    for(int n2 = 1; n2 <= m2; n2++){
      final l1 = s1[n1-1];
      final l2 = s2[n2-1];

      if(l1 == l2) { 
        cache[n1][n2] = Step(Action.ignore, cache[n1-1][n2-1]!.distance, l1);
        continue;
      }

      final add = cache[n1-1][n2]!.distance;
      final remove = cache[n1][n2-1]!.distance;
      final replace = cache[n1-1][n2-1]!.distance;

      var distance = add;
      var action = Action.add;
      var letter = l1;

      if(remove < distance) {
        distance = remove;
        action = Action.remove;
        letter = l2;
      } 

      cache[n1][n2] = Step(action, distance + 1, letter);
      continue;
    }
  }

  int n1 = m1;
  int n2 = m2;

  final steps = <String>[];

  while(n1 != 0 || n2 != 0) {
    final step = cache[n1][n2]!; 
    if(step.action == Action.add) {
      n1--;
    }
    else if(step.action == Action.remove) {
      n2--;
    }
    else{
      n1--;
      n2--;
    }
    steps.add("$step");
  }

  return steps;
}
