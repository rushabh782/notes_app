import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/core/constants/routes.dart';
import 'package:notes_app/data/models/note_model.dart';
import 'package:notes_app/presentation/controllers/note_controller.dart';

class AddEditNotePage extends StatelessWidget {
  final NoteController _noteController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  AddEditNotePage({super.key}) {
    final Note? note = Get.arguments;
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments == null ? 'Add Note' : 'Edit Note'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some content';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final Note? note = Get.arguments;
      if (note == null) {
        // Add new note
        await _noteController.addNote(
          Note(title: _titleController.text, content: _contentController.text),
        );
      } else {
        // Update existing note
        await _noteController.updateNote(
          note.copyWith(
            title: _titleController.text,
            content: _contentController.text,
          ),
        );
      }
      Get.until((route) => route.settings.name == AppRoutes.home);
    }
  }
}

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }
// }
