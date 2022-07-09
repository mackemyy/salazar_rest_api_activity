// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      noteID: json['noteID'] as String,
      noteTitle: json['noteTitle'] as String,
      noteContent: json['noteContent'] as String,
      createDateTime: DateTime.parse(json['createDateTime'] as String),
      latestEditDateTime: json['latestEditDateTime'] == null
          ? null
          : DateTime.parse(json['latestEditDateTime'] as String),
    );

