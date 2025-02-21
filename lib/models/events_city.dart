// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EventsVilles {
  String? idEventVille;
  String? idEvent;
  String? idLevel;
  String? libelle;
  String? dateEventByVille;

 EventsVilles({
 this.idEventVille,
 this.idEvent,
 this.idLevel,
 this.libelle,
 this.dateEventByVille
 });



  EventsVilles copyWith({
    String? idEventVille,
    String? idEvent,
    String? idLevel,
    String? libelle,
    String? dateEventByVille,
  }) {
    return EventsVilles(
      idEventVille: idEventVille ?? this.idEventVille,
      idEvent: idEvent ?? this.idEvent,
      idLevel: idLevel ?? this.idLevel,
      libelle: libelle ?? this.libelle,
      dateEventByVille: dateEventByVille ?? this.dateEventByVille,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idEventVille': idEventVille,
      'idEvent': idEvent,
      'idLevel': idLevel,
      'libelle': libelle,
      'dateEventByVille': dateEventByVille,
    };
  }

  factory EventsVilles.fromMap(Map<String, dynamic> map) {
    return EventsVilles(
      idEventVille: map['idEventVille'] != null ? map['idEventVille'] as String : null,
      idEvent: map['idEvent'] != null ? map['idEvent'] as String : null,
      idLevel: map['idLevel'] != null ? map['idLevel'] as String : null,
      libelle: map['libelle'] != null ? map['libelle'] as String : null,
      dateEventByVille: map['dateEventByVille'] != null ? map['dateEventByVille'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventsVilles.fromJson(String source) => EventsVilles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventsVilles(idEventVille: $idEventVille, idEvent: $idEvent, idLevel: $idLevel, libelle: $libelle, dateEventByVille: $dateEventByVille)';
  }

  @override
  bool operator ==(covariant EventsVilles other) {
    if (identical(this, other)) return true;
  
    return 
      other.idEventVille == idEventVille &&
      other.idEvent == idEvent &&
      other.idLevel == idLevel &&
      other.libelle == libelle &&
      other.dateEventByVille == dateEventByVille;
  }

  @override
  int get hashCode {
    return idEventVille.hashCode ^
      idEvent.hashCode ^
      idLevel.hashCode ^
      libelle.hashCode ^
      dateEventByVille.hashCode;
  }
}
