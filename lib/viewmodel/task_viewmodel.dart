import 'package:flutter/cupertino.dart';
import 'package:persistencia_local/data/interfaces/persistence_strategy.dart';
import 'package:persistencia_local/model/task.dart';

class TaskViewModel extends ChangeNotifier {
  final PersistenceStrategy _strategy;
  List<Task> _tasks = [];
  bool _isLoading = false;

  TaskViewModel(this._strategy) {
    loadTasks();
  }

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String get strategyName => _strategy.getName();

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners(); // Notifica para mostrar loading se quiser

    _tasks = await _strategy.loadTasks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isDone: false,
    );

    // Atualiza UI otimista
    _tasks.add(newTask);
    notifyListeners();

    // Persiste
    await _strategy.saveTask(newTask);
  }

  Future<void> toggleTask(Task task) async {
    task.isDone = !task.isDone;
    notifyListeners();
    await _strategy.saveTask(task);
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    await _strategy.deleteTask(id);
  }
}