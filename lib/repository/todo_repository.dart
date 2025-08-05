import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planora/models/todo_model.dart';
import 'package:planora/utils/app_config.dart';
import 'base_repository.dart';

class TodoRepository extends BaseRepository<TodoModel, String> {
  TodoRepository() : super(boxName: 'todos', collectionName: 'todos');

  late final CollectionReference _collection;

  @override
  TodoModel fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TodoModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      todo: data['todo'] ?? '',
      doesRepeat: data['doesRepeat'] ?? false,
      repeatOption: data['repeatOption'] ?? '',
      selectedDays: data['selectedDays'] as List<String>,
      todoStatus: data['todoStatus'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      priority: data['priority'] ?? 'None',
    );
  }

  @override
  Map<String, dynamic> toMap(TodoModel todo) {
    return {
      'id': todo.id,
      'userId': todo.userId,
      'todo': todo.todo,
      'doesRepeat': todo.doesRepeat,
      'repeatOption': todo.repeatOption,
      'selectedDays': todo.selectedDays,
      'todoStatus': todo.todoStatus,
      'createdAt': todo.createdAt,
      'updatedAt': DateTime.now(),
      'priority': todo.priority,
    };
  }

  @override
  String getId(TodoModel item) => item.id;

  Future<List<TodoModel>> getTodos({String? todoStatus}) async {
    if (todoStatus == null) {
      return await getAll();
    }

    if (AppConfig.isCloudSyncEnabled) {
      try {
        final query = _collection.where('todoStatus', isEqualTo: todoStatus);
        final snapshot = await query.get();
        return snapshot.docs.map((doc) => fromDocument(doc)).toList();
      } catch (e) {
        debugPrint('Error filtering todos from cloud: $e');
      }
    }

    final todos = await getAll();
    return todos.where((todo) => todo.todoStatus == todoStatus).toList();
  }

  Future<void> toggleComplete(String id, String todoStatus) async {
    final todo = await get(id);
    if (todo != null) {
      final updatedTodo = todo.copyWith(
        todoStatus: todoStatus,
        todo: todo.todo,
        doesRepeat: todo.doesRepeat,
        repeatOption: todo.repeatOption,
        selectedDays: todo.selectedDays,
        createdAt: todo.createdAt,
        updatedAt: DateTime.now(),
        priority: todo.priority,
      );
      await save(updatedTodo);
    }
  }
}
