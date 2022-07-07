import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/api_response.dart';
import '../models/note_for_listing.dart';
import '../services/notes_service.dart';
import 'note_delete.dart';
import 'note_modify.dart';

// ignore: use_key_in_widget_constructors
class NoteList extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.I<NotesService>();

  late APIResponse<List<NoteForListing>> _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
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
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator());
            }
            if (_apiResponse.error) {
              return Center(
                child: Text(_apiResponse.errorMessage!),
              );
            }

            return ListView.separated(
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Colors.green,
              ),
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data![index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => const NoteDelete(),
                    );
                    //print(result);
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
                      _apiResponse.data![index].noteTitle,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text(
                        'Last edited on ${formatDateTime(_apiResponse.data![index].latestEditDateTime ?? _apiResponse.data![index].createDateTime)}'),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => NoteModify(
                            noteID: _apiResponse.data![index].noteID))),
                  ),
                );
              },
              itemCount: _apiResponse.data!.length,
            );
          },
        ));
  }
}
