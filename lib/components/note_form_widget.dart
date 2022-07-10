import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;

  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget(
      {Key? key,
      this.isImportant,
      this.number,
      this.title,
      this.description,
      required this.onChangedImportant,
      required this.onChangedNumber,
      required this.onChangedTitle,
      required this.onChangedDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Switch(
                  value: isImportant ?? false, onChanged: onChangedImportant),
              Expanded(
                child: Slider(
                  value: (number ?? 0).toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  onChanged: (number) => onChangedNumber(number.toInt()),
                ),
              )
            ],
          ),
          buildTitle(),
          const SizedBox(height: 8),
          buildDescription(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "제목",
        hintStyle: TextStyle(color: Colors.white70),
      ),
      validator: (title) => title != null && title.isEmpty ? "제목이 없습니다." : null,
      onChanged: onChangedTitle,
    );
  }

  Widget buildDescription() => TextFormField(
    maxLines: 5,
    initialValue: description,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: "내용",
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (title) => title != null && title.isEmpty ? "내용이 없습니다" : null,
    onChanged: onChangedDescription,
  );

}
