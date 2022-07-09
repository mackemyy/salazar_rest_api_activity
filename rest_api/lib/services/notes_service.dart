import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/api_response.dart';
import '../models/note_for_listing.dart';
import 'package:http/http.dart' as http;

class NotesService {
  static const api = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app/';
  static const headers = {'apiKey': '5ff96607-6835-41d9-8fce-a08ac005e51c'};

  Future<APIResponse<List<NoteForListing>>> getNotesList() async {
    return http.get(Uri.parse('$api/notes'), headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for (var item in jsonData) {
          final note = NoteForListing(
            noteID: item['noteID'],
            noteTitle: item['noteTitle'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditDateTime'] != null
                ? DateTime.parse(item['latestEditDateTime'])
                : null,
          );
          notes.add(note);
        }
        return APIResponse<List<NoteForListing>>(
          data: notes,
        );
      }
      return APIResponse<List<NoteForListing>>(
        error: true,
        errorMessage: 'An error occured',
      );
    }).catchError((_) => APIResponse<List<NoteForListing>>(
        error: true,
        errorMessage: 'An error occured',
      ));
  }
}
