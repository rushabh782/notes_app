import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/core/constants/routes.dart';
import 'package:notes_app/data/models/note_model.dart';
import 'package:notes_app/presentation/controllers/note_controller.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final NoteController _noteController = Get.find();

  NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Delete Note'),
                content: const Text(
                  'Are you sure you want to delete this note?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
        );
      },
      onDismissed: (direction) async {
        final deletedNote = note;
        await _noteController.deleteNote(note.id!);

        Get.snackbar(
          'Note Deleted',
          'The note has been deleted',
          duration: const Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () async {
              await _noteController.addNote(deletedNote);
              Get.closeCurrentSnackbar();
            },
            child: const Text('UNDO'),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          title: Text(note.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(
                _noteController.formatDate(note.updatedAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          onTap: () => Get.toNamed(AppRoutes.editNote, arguments: note),
        ),
      ),
    );
  }
}
