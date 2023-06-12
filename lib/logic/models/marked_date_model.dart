// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MarkedDateEvent {
  const MarkedDateEvent({
    required this.id,
    required this.dateTime,
    required this.title,
    this.description,
  });
  final String id;
  final DateTime dateTime;
  final String title;
  final String? description;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'title': title,
      'description': description,
    };
  }

  factory MarkedDateEvent.fromMap(Map<String, dynamic> map) {
    return MarkedDateEvent(
      id: map['id'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      title: map['title'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MarkedDateEvent.fromJson(String source) =>
      MarkedDateEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  MarkedDateEvent copyWith({
    String? id,
    DateTime? dateTime,
    String? title,
    String? description,
  }) {
    return MarkedDateEvent(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
