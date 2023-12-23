import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/api_service.dart';

class NotesProvider with ChangeNotifier {
  bool isLoading = true;
  List<Note> notes = [];

  NotesProvider() {
    fecthNotes();
  }

  List<Note> getFilteredNotes(String searchQuery) {
    return notes.where((element) => element.title!.toLowerCase().contains(searchQuery.toLowerCase()) 
    || element.content!.toLowerCase().contains(searchQuery.toLowerCase()) ).toList();
  }

  sortNotes() {
    notes.sort((a, b) => b.dateAdded!.compareTo(a.dateAdded!));
  }

  addNote(Note note) {
    notes.add(note);
    sortNotes();
    notifyListeners();

    ApiService.addNote(note);
  }

  updateNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote] = note;
    sortNotes();

    notifyListeners();

    ApiService.addNote(note);
  }

  deleteNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    sortNotes();

    notifyListeners();
    ApiService.deleteNote(note);
  }

  void fecthNotes() async {
    notes = await ApiService.fetchNotes("zoro");
    sortNotes();
    isLoading = false;
    notifyListeners();
  }
}
