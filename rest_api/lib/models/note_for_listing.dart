// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'note_for_listing.g.dart';

@JsonSerializable()
class NoteForListing {
  String noteID;
  String noteTitle;
  DateTime createDateTime;
  DateTime? latestEditDateTime;

  NoteForListing(
      {required this.noteID,
      required this.noteTitle,
      required this.createDateTime,
      required this.latestEditDateTime});

  factory NoteForListing.fromJson(Map<String, dynamic> item) =>
      _$NoteForListingFromJson(item);
}
