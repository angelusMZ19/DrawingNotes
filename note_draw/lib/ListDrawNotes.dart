import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'drawScreen.dart';
import 'DrawNote.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<DrawingNote> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/notes.json');
    if (await file.exists()) {
      final data = await file.readAsString();
      final List<dynamic> jsonNotes = jsonDecode(data);
      setState(() {
        notes = jsonNotes.map((e) => DrawingNote.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/notes.json');
    final data = jsonEncode(notes.map((e) => e.toJson()).toList());
    await file.writeAsString(data);
  }

  void _createNewNote() {
    final newNote = DrawingNote(
      id: DateTime.now().toString(),
      strokes: [],
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DrawScreen(
          note: newNote,
          onSave: (updatedNote) {
            setState(() {
              notes.add(updatedNote);
              _saveNotes();
            });
          },
        ),
      ),
    );
  }

  void _editNote(DrawingNote note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DrawScreen(
          note: note,
          onSave: (updatedNote) {
            setState(() {
              final index = notes.indexWhere((n) => n.id == updatedNote.id);
              notes[index] = updatedNote;
              _saveNotes();
            });
          },
        ),
      ),
    );
  }

  void _deleteNote(String id) {
    setState(() {
      notes.removeWhere((note) => note.id == id);
      _saveNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing Notes'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text('Note ${note.id}'),
            onTap: () => _editNote(note),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteNote(note.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
