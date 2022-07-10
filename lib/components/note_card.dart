import 'package:flutter/material.dart';
import 'package:note_app_sqlite/models/note.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({Key? key, required this.note, required this.index}) : super(key: key);
  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
