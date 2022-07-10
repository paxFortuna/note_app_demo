import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app_sqlite/database/note_db_helper.dart';
import 'package:note_app_sqlite/models/note.dart';
import 'package:note_app_sqlite/screens/edit_screen.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({Key? key, required this.noteId}) : super(key: key);
  final int noteId;

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.all(12),
            child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: const TextStyle(color: Colors.white38),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
          ),
    );
  }

  editButton() {
    return IconButton(
        onPressed: () async {
          if (isLoading) return;
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EditNoteScreen(note: note)));
          refreshNotes();
        },
        icon: const Icon(Icons.edit_outlined));
  }

  deleteButton() {
    return IconButton(
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);
          if (!mounted) return;
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.delete));
  }
}
