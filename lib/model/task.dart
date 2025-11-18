class Task {
  final String id;
  String title;
  bool isDone;

  Task({required this.id, required this.title, this.isDone = false});

  // Converte para Map (usado no JSON e SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0, // SQLite não tem bool, usamos 0 ou 1
    };
  }

  // Constrói a partir de Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'].toString(),
      title: map['title'],
      isDone: (map['isDone'] is int)
          ? map['isDone'] == 1
          : map['isDone'], // Trata compatibilidade JSON (bool) vs SQLite (int)
    );
  }
}
