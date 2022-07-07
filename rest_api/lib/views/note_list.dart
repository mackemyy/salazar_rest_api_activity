import 'package:flutter/material.dart';
import 'package:rest_api/models/note_for_listing.dart';
import 'package:rest_api/views/note_delete.dart';

import 'note_modify.dart';

class NoteList extends StatelessWidget {
  NoteList({Key? key}) : super(key: key);

  final notes = [
    NoteForListing(
      noteID: "1",
      noteTitle: "Note 1",
      createDateTime: DateTime.now(),
      latestEditDateTime: DateTime.now(),
    ),
    NoteForListing(
      noteID: "2",
      noteTitle: "Note 2",
      createDateTime: DateTime.now(),
      latestEditDateTime: DateTime.now(),
    ),
    NoteForListing(
      noteID: "3",
      noteTitle: "Note 3",
      createDateTime: DateTime.now(),
      latestEditDateTime: DateTime.now(),
    ),
  ];

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const NoteModify()));
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: Colors.green,
        ),
        itemBuilder: (_, index) {
          return Dismissible(
            key: ValueKey(notes[index].noteID),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {

            },
            confirmDismiss: (direction) async {
              final result = await showDialog(
                context: context, 
                builder: (_) => const NoteDelete(),
              );
              print(result);
              return result;
            },
            background: Container(
              color: Colors.red,
              padding: const EdgeInsets.only(left: 16),
              child: const Align(
                alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
              ),
            ),
            child: ListTile(
              title: Text(
                notes[index].noteTitle,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              subtitle: Text(
                  'Last edited on ${formatDateTime(notes[index].latestEditDateTime)}'),
              onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => NoteModify(noteID: notes[index].noteID))),
            ),
          );
        },
        itemCount: notes.length,
      ),
    );
  }
}
