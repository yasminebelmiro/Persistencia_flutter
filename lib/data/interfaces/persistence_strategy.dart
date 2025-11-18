import 'package:persistencia_local/model/task.dart';

abstract class PersistenceStrategy {
  Future<List<Task>> loadTasks();
  Future<void> saveTask(Task task); // Create / Update
  Future<void> deleteTask(String id);
  String getName(); // Apenas para exibição na UI
}
