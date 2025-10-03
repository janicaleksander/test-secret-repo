// simple_city_simulation.dart
import 'dart:math';
import 'dart:io'; // <-- potrzebne do Platform.environment

class Person {
  String name;
  int x;
  int y;
  List<String> inventory;

  Person(this.name, this.x, this.y) : inventory = [];

  void move(int maxX, int maxY) {
    var rng = Random();
    x += rng.nextInt(3) - 1; // -1, 0, or 1
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

  City(this.width, this.height, this.people, this.items);

  void simulateStep() {
    for (var person in people) {
      person.move(width, height);

      var rng = Random();
      if (rng.nextBool() && items.isNotEmpty) {
        var item = items[rng.nextInt(items.length)];
        person.pickItem(item);
        print('${person.name} picked up $item!');
      }
    }
  }

  void report() {
    for (var person in people) {
      print(person);
    }
  }
}

void main() {
  // --- NOWOŚĆ: Odczyt zmiennej środowiskowej ---
  var password = Platform.environment['PASSWORD'];
  if (password == null) {
    print("WARNING: PASSWORD env variable is not set!");
  } else {
    print("Successfully loaded PASSWORD from environment: ${'*' * password.length}");
  }

  var items = [
    "Apple", "Book", "Coin", "Hat", "Bottle", "Stone", "Pen", "Bag", "Key", "Flower"
  ];

  var people = [
    Person("Alice", 0, 0),
    Person("Bob", 2, 3),
    Person("Charlie", 5, 5),
    Person("Diana", 3, 2),
    Person("Eve", 1, 4)
  ];

  var city = City(10, 10, people, items);

  print("Starting simulation...");
  for (var step = 1; step <= 100; step++) {
    print("\n--- Step $step ---");
    city.simulateStep();
    city.report();
  }
}
