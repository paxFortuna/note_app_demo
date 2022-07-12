import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app_sqlite/components/note_card.dart';
import 'package:note_app_sqlite/database/note_db_helper.dart';
import 'package:note_app_sqlite/models/note.dart';
import 'package:note_app_sqlite/screens/edit_screen.dart';
import 'package:note_app_sqlite/screens/note_detail.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      primary: true,
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 100,
          centerTitle: true,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('Reminder'),
            // background:
            //     Image.asset("assets/images/wheel.png", fit: BoxFit.fill),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: '입력',
              onPressed: () async {
                await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EditNoteScreen()));
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        SliverFillRemaining(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : notes.isEmpty
                  ? const Text('내용이 없습니다',
                      style: TextStyle(color: Colors.white, fontSize: 25))
                  : buildNotes(),
        ),
      ],
    ));  }

  // StaggeredGridView version down ^0.4.0 : error 제거
  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8),
        // physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: notes.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailScreen(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );

// Widget buildNotes() =>
//     ListView.builder(
//       itemCount: notes.length,
//       itemBuilder: (context, index) {
//         final note = notes[index];
//         return GestureDetector(
//           onTap: () async {
//             await Navigator.of(context).push(MaterialPageRoute(
//               builder: (_) => NoteDetailScreen(noteId: note.id!),
//             ));
//             refreshNotes();
//           },
//           child: NoteCardWidget(note: note, index: index),
//         );
//       },
//     );

// Widget buildNotes() => GridView.builder(
//       itemCount: notes.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 2.0,
//         mainAxisSpacing: 2.0,
//         childAspectRatio: 1/2,
//       ),
//       itemBuilder: (context, index) {
//         final note = notes[index];
//         return GestureDetector(
//           onTap: () async {
//             await Navigator.of(context).push(MaterialPageRoute(
//               builder: (_) => NoteDetailScreen(noteId: note.id!),
//             ));
//             refreshNotes();
//           },
//           child: NoteCardWidget(note: note, index: index),
//         );
//       },
//     );


  @override
  void dispose() {
    super.dispose();
    NotesDatabase.instance.close();
  }
}
