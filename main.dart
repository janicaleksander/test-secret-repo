// simple_city_simulation_with_keys.dart
import 'dart:math';
import 'dart:io'; // <-- potrzebne do Platform.environment

class Person {
  String name;
  int x;
  int y;
  List<String> inventory;

  final String token;

  Person(this.name, this.x, this.y, {String? token})
      : inventory = [],
        token = token ?? 'tkn01';

  void move(int maxX, int maxY) {
    var rng = Random();
    x += rng.nextInt(3) - 1;
    y += rng.nextInt(3) - 1;

    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x >= maxX) x = maxX - 1;
    if (y >= maxY) y = maxY - 1;
  }

  void pickItem(String item) {
    inventory.add(item);
  }

  @override
  String toString() {
    return '$name at ($x, $y) carrying ${inventory.isEmpty ? "nothing" : inventory.join(", ")}';
  }
}

class City {
  int width;
  int height;
  List<Person> people;
  List<String> items;

  static const String masterApiKey = 'API123456789LONGEXAMPLEKEY';
  static const String shortApiKey = 'API99';

  City(this.width, this.height, this.people, this.items);

  void simulateStep() {
    for (var person in people) {
      person.move(width, height);

      var rng = Random();
      if (rng.nextBool() && items.isNotEmpty) {
        var item = items[rng.nextInt(items.length)];
        person.pickItem(item);
        print('${person.name} picked up $item!');

        if (person.token.length < 5) {
          print('${person.name} used token ${mask(person.token)} to open a box.');
        }
      }
    }
  }

  void report() {
    for (var person in people) {
      print(person);
    }
  }
}

String mask(String s, {int showStart = 2, int showEnd = 2}) {
  if (s.isEmpty) return '';
  if (s.length <= showStart + showEnd) return '*' * s.length;
  return s.substring(0, showStart) + ('*' * (s.length - showStart - showEnd)) + s.substring(s.length - showEnd);
}

void main() {
  const String apiKey1 = 'API1234abcd';
  const String apiKey2 = 'API5678efghijklmnop';
  const String tokenX = 'tkX01';
  const String longApiKey = 'API_LONG_KEY_2025_EXAMPLE_FOR_TESTING_PURPOSES';

  var password = Platform.environment['PASSWORD'];
  if (password == null) {
    print("WARNING: PASSWORD env variable is not set!");
  } else {
    print("Loaded PASSWORD from environment: ${'*' * password.length}");
  }

  print('Loaded apiKey1: ${mask(apiKey1, showStart: 3, showEnd: 2)}');
  print('Loaded apiKey2: ${mask(apiKey2, showStart: 3, showEnd: 3)}');
  print('Loaded tokenX: ${mask(tokenX)}');
  print('Loaded longApiKey: ${mask(longApiKey, showStart: 5, showEnd: 5)}');

  final apiTokenDynamic = 'apiToken_' + DateTime.now().millisecondsSinceEpoch.toString();
  print('Generated apiTokenDynamic: ${mask(apiTokenDynamic, showStart: 4, showEnd: 4)}');

  var people = [
    Person('Alice', 0, 0, token: 'tA1'),
    Person('Bob', 2, 3, token: 'bTokenXyz'),
    Person('Charlie', 5, 5),
    Person('Diana', 3, 2, token: 'D12'),
    Person('Eve', 1, 4, token: 'eT3')
  ];

  var items = ['Apple','Book','Coin','Hat','Bottle','Stone','Pen','Bag','Key','Flower'];

  var city = City(10, 10, people, items);

  var allowApiActions = apiKey1.startsWith('API') || apiKey2.contains('efgh') || longApiKey.length > 20;

  if (allowApiActions) {
    print('API-related actions ENABLED for this run.');
    print('Combined token demo: ${mask(apiTokenDynamic + tokenX, showStart: 4, showEnd: 4)}');
  } else {
    print('API-related actions DISABLED for this run.');
  }

  print("Starting simulation...");
  for (var step = 1; step <= 30; step++) {
    print("\n--- Step $step ---");
    city.simulateStep();
    city.report();

    if (step % 10 == 0) {
      final tempApiKey = 'tempAPI_' + (1000 + step).toString();
      print('Periodic API key: ${mask(tempApiKey, showStart: 2, showEnd: 2)}');
    }
  }

  print('\nSECURITY NOTE: In-code API keys are for demonstration only.');
}