import 'dart:io';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

void main() {
  int position;
  bool _isMenu = true;
  final ToDoList toDoList = ToDoList();
  Reader reader = Reader();
  // String cls = "\x1B[2J\x1B[0;0H"; // clear screen

  while (_isMenu) {
    position = PrintInfo.printMenu();
    switch (position) {
      case 1:
        print("1 - Add simple tasks");
        print("2 - Add recurrent tasks");
        print("\nInput:");
        var typeTask = int.parse(stdin.readLineSync()!);
        if (typeTask == 1) {
          PrintInfo.printDays();
          print("\nChoose day:");
          Days day = Days.values[int.parse(stdin.readLineSync()!) - 1];
          toDoList.addSimpleTasks(reader.readSimpleTasks(), day);
        } else if (typeTask == 2) {
          toDoList.addRecurrentTasks(reader.readRecurrentTasks());
        }
        break;
      case 2:
        toDoList.showTask();
        stdin.readLineSync()!;
        break;
      case 3:
        print("1 - Remove simple tasks");
        print("2 - Remove recurrent tasks");
        print("\nInput:");
        var typeTask = int.parse(stdin.readLineSync()!);
        if (typeTask == 1) {
          PrintInfo.printDays();
          print("\nChoose day:");
          Days day = Days.values[int.parse(stdin.readLineSync()!) - 1];
          print("\nInput Id:");
          var id = int.parse(stdin.readLineSync()!);
          toDoList.removeSimpleTask(day, id);
        } else if (typeTask == 2) {
          print("\nInput Id:");
          var id = int.parse(stdin.readLineSync()!);
          toDoList.removeRecurrentTask(id);
        }
        break;
      case 4:
        toDoList.summaryTask();
        break;
      case 0:
        _isMenu = false;
        break;
      default:
        break;
    }
  }
}

abstract class ReadInformation {
  List readSimpleTasks();
  List readRecurrentTasks();
}

class PrintInfo {
  static void printDays() {
    int i = 1;
    Days.values.forEach((element) {
      print(i.toString() + " - " + element.toString());
      i++;
    });
  }

  static int printMenu() {
    print("1. Add task");
    print("2. Show task");
    print("3. Delete task");
    print("4. Summary task");
    print("0. Exit");

    print("\nInput:");
    return int.parse(stdin.readLineSync()!);
  }
}

class Reader extends ReadInformation {
  List<SimpleTask> readSimpleTasks() {
    List<SimpleTask> tempList = [];
    int id;
    String name;
    String categorie;
    while (true) {
      print("Add task\n");
      print("Input Id\n");
      id = int.parse(stdin.readLineSync()!);
      print("Input Name\n");
      name = stdin.readLineSync()!;
      print("Input Categorie\n");
      categorie = stdin.readLineSync()!;
      tempList.add(SimpleTask(id, name, categorie));
      print("Add more tasks for this day Yes - 1/No - 0\n");
      if (int.parse(stdin.readLineSync()!) == 0) {
        break;
      }
    }
    return tempList;
  }

  List<RecurrentTask> readRecurrentTasks() {
    List<RecurrentTask> tempList = [];
    int id;
    String name;
    String categorie;
    Days day;
    while (true) {
      print("Add task\n");
      print("Input Id\n");
      id = int.parse(stdin.readLineSync()!);
      print("Input Name\n");
      name = stdin.readLineSync()!;
      print("Input Categorie\n");
      categorie = stdin.readLineSync()!;
      PrintInfo.printDays();
      print("\nChoose day:");
      day = Days.values[int.parse(stdin.readLineSync()!) - 1];
      tempList.add(RecurrentTask(id, day, name, categorie));
      print("Add more Yes - 1/No - 0\n");
      if (int.parse(stdin.readLineSync()!) == 0) {
        break;
      }
    }
    return tempList;
  }
}

class ToDoList {
  late Map<Days, List<SimpleTask>> _simpleTasks;
  late List<RecurrentTask> _recurrentTasks;

  ToDoList() {
    _simpleTasks = {};
    _recurrentTasks = [];
  }

  void addSimpleTasks(List<SimpleTask> tasks, Days day) {
    bool isDayExist = false;
    _simpleTasks.forEach((key, value) {
      if (key == day) {
        isDayExist = true;
      }
    });
    if (!isDayExist) {
      _simpleTasks.addAll({day: []});
    }
    tasks.forEach((element) {
      _simpleTasks[day]?.add(element);
    });
  }

  void addRecurrentTasks(List<RecurrentTask> tasks) {
    tasks.forEach((task) => this._recurrentTasks.add(task));
  }

  void showTask() {
    for (int i = 0; i < 7; i++) {
      print(Days.values[i]);
      _simpleTasks[Days.values[i]]?.forEach((element) {
        element.printTask();
      });
      _recurrentTasks.forEach((element) {
        if (element.day == Days.values[i]) {
          element.printTask();
        }
      });
    }
  }

  void removeSimpleTask(Days day, int id) {
    var deletedElement;
    _simpleTasks[day]?.forEach((element) {
      if (element.id == id) {
        deletedElement = element;
      }
    });
    if (deletedElement != null) {
      _simpleTasks[day]!.remove(deletedElement);
    }
  }

  void removeRecurrentTask(int id) {
    var deletedElement;
    _recurrentTasks.forEach((element) {
      if (element.id == id) {
        deletedElement = element;
      }
    });
    if (deletedElement != null) {
      _recurrentTasks.remove(deletedElement);
    }
  }

  void summaryTask() {
    Map<String, int> summary = {};

    for (int i = 0; i < 7; i++) {
      _simpleTasks[Days.values[i]]?.forEach((element) {
        if (summary.containsKey(element.categorie)) {
          summary[element.categorie] = summary[element.categorie]! + 1;
        } else {
          summary.addAll({element.categorie: 1});
        }
      });
    }
    _recurrentTasks.forEach((element) {
      if (summary.containsKey(element.categorie)) {
        summary[element.categorie] = summary[element.categorie]! + 1;
      } else {
        summary.addAll({element.categorie: 1});
      }
    });
    summary.forEach((key, value) {
      print(key + " - " + value.toString() + "\n");
    });
  }
}

class Task {
  late int id;
  late String name;
  late String categorie;

  void printTask() {}
}

class SimpleTask implements Task {
  @override
  late String categorie;
  late int id;
  late String name;

  SimpleTask(this.id, this.name, this.categorie);

  @override
  void printTask() {
    print(id.toString() + ".\t" + name + "\t" + categorie);
  }
}

class RecurrentTask implements Task {
  late Days day;
  @override
  late String categorie;
  late int id;
  late String name;

  RecurrentTask(this.id, this.day, this.name, this.categorie);

  @override
  void printTask() {
    print(id.toString() +
        ".\t" +
        day.toString() +
        "\t" +
        name +
        "\t" +
        categorie);
  }
}
