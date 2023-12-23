import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/notes_provider.dart';

class AddNewNote extends StatefulWidget {
  bool isUpdate;
  final Note? note;

  AddNewNote({
    Key? key,
    required this.isUpdate,
    this.note,
  }) : super(key: key);

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  @override
  void initState() {
    // TODO: implement initState
    if (widget.isUpdate == true) {
      titleController.text = widget.note!.title!;
      noteController.text = widget.note!.content!;
    }

    super.initState();
  }

  FocusNode nodeFocus = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  void addnewnote() {
    Note newNote = Note(
        id: Uuid().v1(),
        userid: "zoro",
        title: titleController.text,
        content: noteController.text,
        dateAdded: DateTime.now());

    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  void updatenote() {
    widget.note?.title = titleController.text;
    widget.note?.content = noteController.text;
    widget.note?.dateAdded = DateTime.now();
    Provider.of<NotesProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (widget.isUpdate == false) {
                addnewnote();
              } else {
                updatenote();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                autofocus: (widget.isUpdate == true) ? false : true,
                onSubmitted: (val) {
                  if (val != "") {
                    nodeFocus.requestFocus();
                  }
                },
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: noteController,
                  focusNode: nodeFocus,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Note",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
