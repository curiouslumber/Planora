import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planora/models/notes_model.dart';
import 'base_repository.dart';

class NotesRepository extends BaseRepository<NotesModel, String> {
  NotesRepository() : super(boxName: 'notes', collectionName: 'notes');

  @override
  NotesModel fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotesModel(
      id: doc.id,
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toMap(NotesModel note) {
    return {
      'id': note.id,
      'title': note.title,
      'text': note.text,
      'createdAt': note.createdAt,
    };
  }

  @override
  String getId(NotesModel item) => item.id;

  /// Searches notes by title or content
  Future<List<NotesModel>> searchNotes(String query) async {
    final notes = await getAll();
    final lowercaseQuery = query.toLowerCase();
    
    return notes.where((note) {
      return note.title.toLowerCase().contains(lowercaseQuery) ||
          note.text.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Gets notes sorted by creation date (newest first)
  Future<List<NotesModel>> getNotesSortedByDate() async {
    final notes = await getAll();
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }
}
