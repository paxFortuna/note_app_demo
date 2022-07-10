import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:note_app_sqlite/components/note_form_widget.dart';
import 'package:note_app_sqlite/database/note_db_helper.dart';
import 'package:note_app_sqlite/models/note.dart';
import 'package:note_app_sqlite/screens/note_screen..dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({Key? key, this.note}) : super(key: key);
  final Note? note;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formkey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? "";
    description = widget.note?.description ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      body: Form(
        key: _formkey,
        child: NoteFormWidget(
          isImportant: isImportant,
          number: number,
          title: title,
          description: description,
          onChangedImportant: (bool isImportant) {
            setState(() => this.isImportant = isImportant);
          },
          onChangedNumber: (int value) {
            setState(() => number = value);
          },
          onChangedTitle: (String text) {
            setState(() => title = text);
          },
          onChangedDescription: (String content) {
            setState(() => description = content);
          },

        ),
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ElevatedButton(
        onPressed: addOrUpdateNote,
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        child: const Text('저장'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );
    await NotesDatabase.instance.update(note);
    // await NotesDatabase.instance.readAllNotes();
  }

  Future addNote() async {
  final note = Note(
    title: title,
    isImportant: true,
    number: number,
    description: description,
    createdTime: DateTime.now(),
  );
  await NotesDatabase.instance.create(note);
  // await NotesDatabase.instance.readAllNotes();
}}
