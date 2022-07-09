import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/models/note_insert.dart';
import 'package:rest_api/services/notes_service.dart';
import '../models/note.dart';

// ignore: must_be_immutable
class NoteModify extends StatefulWidget {
  String? noteID;
  NoteModify({Key? key, this.noteID}) : super(key: key);

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NotesService get notesService => GetIt.I<NotesService>();
  String? errorMessage;
  Note? note;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      notesService.getNote(widget.noteID!).then((response) {
        setState(() {
          _isLoading = false;
        });
        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occurred';
        }
        note = response.data;
        _titleController.text = note!.noteTitle;
        _contentController.text = note!.noteContent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Note' : 'Create Note')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Note Title'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(hintText: 'Note Content'),
                  ),
                  Container(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      child: const Text('Submit'),
                      onPressed: () async {
                        if (isEditing) {
                          setState(() {
                            _isLoading = true;
                          });

                          final note = NoteManipulation(
                            noteTitle: _titleController.text,
                            noteContent: _contentController.text,
                          );
                          final result = await notesService.updateNote(widget.noteID!, note);

                          setState(() {
                            _isLoading = false;
                          });

                          const title = 'Done';
                          final text = result.error ? (result.errorMessage ?? 'An error occured') : 'Your note was updated.';

                          showDialog(
                            context: context, 
                            builder: (_) => AlertDialog(
                              title: const Text(title),
                              content: Text(text),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }, 
                                ),
                              ],
                            )
                          ).then((data) {
                            if(result.data!) {
                              Navigator.of(context).pop();
                            }
                          });
                        } else {

                          setState(() {
                            _isLoading = true;
                          });

                          final note = NoteManipulation(
                            noteTitle: _titleController.text,
                            noteContent: _contentController.text,
                          );
                          final result = await notesService.createNote(note);

                          setState(() {
                            _isLoading = false;
                          });

                          const title = 'Done';
                          final text = result.error ? (result.errorMessage ?? 'An error occured') : 'Your note was created.';

                          showDialog(
                            context: context, 
                            builder: (_) => AlertDialog(
                              title: const Text(title),
                              content: Text(text),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }, 
                                ),
                              ],
                            )
                          ).then((data) {
                            if(result.data!) {
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
