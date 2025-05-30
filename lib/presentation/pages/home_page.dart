// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:notes_app/core/constants/routes.dart';
// import 'package:notes_app/presentation/controllers/note_controller.dart';
// import 'package:notes_app/presentation/controllers/theme_controller.dart';
// import 'package:notes_app/presentation/widgets/note_card.dart';

// class HomePage extends StatelessWidget {
//   final NoteController _noteController = Get.find();
//   final ThemeController _themeController = Get.find();

//   HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notes'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showSearch(context: context, delegate: NotesSearchDelegate());
//             },
//           ),
//           IconButton(
//             icon: Obx(
//               () => Icon(
//                 _themeController.isDarkMode.value
//                     ? Icons.light_mode
//                     : Icons.dark_mode,
//               ),
//             ),
//             onPressed: _themeController.toggleTheme,
//           ),
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'sortByTitle') {
//                 _noteController.sortBy.value = 'title';
//               } else if (value == 'sortByDate') {
//                 _noteController.sortBy.value = 'updatedAt';
//               } else if (value == 'sortAscending') {
//                 _noteController.isAscending.toggle();
//               }
//             },
//             itemBuilder:
//                 (context) => [
//                   const PopupMenuItem(
//                     value: 'sortByTitle',
//                     child: Text('Sort by Title'),
//                   ),
//                   const PopupMenuItem(
//                     value: 'sortByDate',
//                     child: Text('Sort by Date'),
//                   ),
//                   const PopupMenuItem(
//                     value: 'sortAscending',
//                     child: Text('Toggle Sort Order'),
//                   ),
//                 ],
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (_noteController.filteredNotes.isEmpty) {
//           return const Center(
//             child: Text('No notes found. Add a new note to get started!'),
//           );
//         }
//         return ListView.builder(
//           itemCount: _noteController.filteredNotes.length,
//           itemBuilder: (context, index) {
//             final note = _noteController.filteredNotes[index];
//             return NoteCard(note: note);
//           },
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Get.toNamed(AppRoutes.addNote),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class NotesSearchDelegate extends SearchDelegate<String> {
//   final NoteController _noteController = Get.find();

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           showSuggestions(context);
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, '');
//         _noteController.searchQuery.value = '';
//         _noteController.filterNotes();
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildSearchResults();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return _buildSearchResults();
//   }

//   Widget _buildSearchResults() {
//     // Debounce the search to avoid rapid rebuilds
//     debounce(
//       _noteController.searchQuery,
//       (_) => _noteController.searchQuery.value = query,
//       time: const Duration(milliseconds: 300),
//     );

//     return Obx(() {
//       if (_noteController.filteredNotes.isEmpty && query.isNotEmpty) {
//         return const Center(child: Text('No notes found matching your search'));
//       }
//       return ListView.builder(
//         itemCount: _noteController.filteredNotes.length,
//         itemBuilder: (context, index) {
//           final note = _noteController.filteredNotes[index];
//           return NoteCard(note: note);
//         },
//       );
//     });
//   }

//   @override
//   void close(BuildContext context, String result) {
//     _noteController.searchQuery.value = '';
//     _noteController.filterNotes();
//     super.close(context, result);
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/core/constants/routes.dart';
import 'package:notes_app/presentation/controllers/note_controller.dart';
import 'package:notes_app/presentation/controllers/theme_controller.dart';
import 'package:notes_app/presentation/widgets/note_card.dart';

class HomePage extends StatelessWidget {
  final NoteController _noteController = Get.find();
  final ThemeController _themeController = Get.find();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              // Clear any previous search
              _noteController.searchQuery.value = '';
              _noteController.filterNotes();

              // Show search
              await showSearch(
                context: context,
                delegate: NotesSearchDelegate(),
              );

              // Reset after search is closed
              _noteController.searchQuery.value = '';
              _noteController.filterNotes();
            },
          ),
          IconButton(
            icon: Obx(
              () => Icon(
                _themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
            onPressed: _themeController.toggleTheme,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'sortByTitle') {
                _noteController.sortBy.value = 'title';
              } else if (value == 'sortByDate') {
                _noteController.sortBy.value = 'updatedAt';
              } else if (value == 'sortAscending') {
                _noteController.isAscending.toggle();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'sortByTitle',
                    child: Text('Sort by Title'),
                  ),
                  const PopupMenuItem(
                    value: 'sortByDate',
                    child: Text('Sort by Date'),
                  ),
                  const PopupMenuItem(
                    value: 'sortAscending',
                    child: Text('Toggle Sort Order'),
                  ),
                ],
          ),
        ],
      ),
      body: Obx(() {
        if (_noteController.filteredNotes.isEmpty) {
          return const Center(
            child: Text('No notes found. Add a new note to get started!'),
          );
        }
        return ListView.builder(
          itemCount: _noteController.filteredNotes.length,
          itemBuilder: (context, index) {
            final note = _noteController.filteredNotes[index];
            return NoteCard(note: note);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addNote),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NotesSearchDelegate extends SearchDelegate<String> {
  final NoteController _noteController = Get.find();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
        _noteController.searchQuery.value = '';
        _noteController.filterNotes();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    // Debounce the search to avoid rapid rebuilds
    debounce(
      _noteController.searchQuery,
      (_) => _noteController.searchQuery.value = query,
      time: const Duration(milliseconds: 300),
    );

    return Obx(() {
      if (_noteController.filteredNotes.isEmpty && query.isNotEmpty) {
        return const Center(child: Text('No notes found matching your search'));
      }
      return ListView.builder(
        itemCount: _noteController.filteredNotes.length,
        itemBuilder: (context, index) {
          final note = _noteController.filteredNotes[index];
          return NoteCard(note: note);
        },
      );
    });
  }

  @override
  void close(BuildContext context, String result) {
    _noteController.searchQuery.value = '';
    _noteController.filterNotes();
    super.close(context, result);
  }
}
