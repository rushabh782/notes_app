import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/note_model.dart';
import '../../data/services/database_service.dart';

class NoteController extends GetxController {
  final DatabaseService _databaseService = Get.find();

  final RxList<Note> notes = <Note>[].obs;
  final RxList<Note> filteredNotes = <Note>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'updatedAt'.obs; // 'title' or 'updatedAt'
  final RxBool isAscending = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
    ever(searchQuery, (_) => filterNotes());
    ever(sortBy, (_) => sortNotes());
    ever(isAscending, (_) => sortNotes());
  }

  Future<void> loadNotes() async {
    notes.value = await _databaseService.getAllNotes();
    filterNotes();
  }

  Future<void> searchNotes(String query) async {
    try {
      if (query.isEmpty) {
        filteredNotes.assignAll(notes);
      } else {
        final results = await _databaseService.searchNotes(query);
        filteredNotes.assignAll(results);
      }
      sortNotes();
    } catch (e) {
      Get.snackbar('Error', 'Failed to search notes: ${e.toString()}');
    }
  }

  void filterNotes() {
    if (searchQuery.value.isEmpty) {
      filteredNotes.assignAll(notes);
    } else {
      searchNotes(searchQuery.value);
    }
  }

  void sortNotes() {
    filteredNotes.sort((a, b) {
      int compare;
      if (sortBy.value == 'title') {
        compare = a.title.compareTo(b.title);
      } else {
        compare = a.updatedAt.compareTo(b.updatedAt);
      }
      return isAscending.value ? compare : -compare;
    });
  }

  Future<void> addNote(Note note) async {
    await _databaseService.insertNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await _databaseService.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await _databaseService.deleteNote(id);
    await loadNotes();
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }
}
