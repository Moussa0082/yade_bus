// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:yade_bus/models/categorie.dart';

class Evenement {
  int? idEvent;
  String? nom;
  String? lieu;
  String? localisation;
  String? organisateur;
  String? dateDebut;
  String? heure;
  int? tarif;
  String? dateFin;
  String? tel;
  String? email;
  int? nbPlaces;
  CategoriesEvent? categoriesEvent;
  String? tags;
  String? ideventImg;
  String? idevent;
  String? img;
  String? category;
  

  Evenement({
    this.idEvent,
    this.nom,
    this.lieu,
    this.localisation,
    this.organisateur,
    this.dateDebut,
    this.heure,
    this.tarif,
    this.dateFin,
    this.tel,
    this.email,
    this.nbPlaces,
    this.categoriesEvent,
    this.tags,
    this.ideventImg,
    this.idevent,
    this.img, 
    this.category
  });
  


  Evenement copyWith({
    int? idEvent,
    String? nom,
    String? lieu,
    String? localisation,
    String? organisateur,
    String? dateDebut,
    String? heure,
    int? tarif,
    String? dateFin,
    String? tel,
    String? email,
    int? nbPlaces,
    CategoriesEvent? categoriesEvent,
    String? tags,
    String? ideventImg,
    String? idevent,
    String? img,
    String? category,
  }) {
    return Evenement(
      idEvent: idEvent ?? this.idEvent,
      nom: nom ?? this.nom,
      lieu: lieu ?? this.lieu,
      localisation: localisation ?? this.localisation,
      organisateur: organisateur ?? this.organisateur,
      dateDebut: dateDebut ?? this.dateDebut,
      heure: heure ?? this.heure,
      tarif: tarif ?? this.tarif,
      dateFin: dateFin ?? this.dateFin,
      tel: tel ?? this.tel,
      email: email ?? this.email,
      nbPlaces: nbPlaces ?? this.nbPlaces,
      categoriesEvent: categoriesEvent ?? this.categoriesEvent,
      tags: tags ?? this.tags,
      ideventImg: ideventImg ?? this.ideventImg,
      idevent: idevent ?? this.idevent,
      img: img ?? this.img,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idEvent': idEvent,
      'nom': nom,
      'lieu': lieu,
      'localisation': localisation,
      'organisateur': organisateur,
      'dateDebut': dateDebut,
      'heure': heure,
      'tarif': tarif,
      'dateFin': dateFin,
      'tel': tel,
      'email': email,
      'nbPlaces': nbPlaces,
      'categoriesEvent': categoriesEvent?.toMap(),
      'tags': tags,
      'ideventImg': ideventImg,
      'idevent': idevent,
      'img': img,
      'category': category,
    };
  }

  factory Evenement.fromMap(Map<String, dynamic> map) {
    return Evenement(
      idEvent: map['idEvent'] != null ? map['idEvent'] as int : null,
      nom: map['nom'] != null ? map['nom'] as String : null,
      lieu: map['lieu'] != null ? map['lieu'] as String : null,
      localisation: map['localisation'] != null ? map['localisation'] as String : null,
      organisateur: map['organisateur'] != null ? map['organisateur'] as String : null,
      dateDebut: map['dateDebut'] != null ? map['dateDebut'] as String : null,
      heure: map['heure'] != null ? map['heure'] as String : null,
      tarif: map['tarif'] != null ? map['tarif'] as int : null,
      dateFin: map['dateFin'] != null ? map['dateFin'] as String : null,
      tel: map['tel'] != null ? map['tel'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      nbPlaces: map['nbPlaces'] != null ? map['nbPlaces'] as int : null,
      categoriesEvent: map['categoriesEvent'] != null ? CategoriesEvent.fromMap(map['categoriesEvent'] as Map<String,dynamic>) : null,
      tags: map['tags'] != null ? map['tags'] as String : null,
      ideventImg: map['ideventImg'] != null ? map['ideventImg'] as String : null,
      idevent: map['idevent'] != null ? map['idevent'] as String : null,
      img: map['img'] != null ? map['img'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Evenement.fromJson(String source) => Evenement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Evenement(idEvent: $idEvent, nom: $nom, lieu: $lieu, localisation: $localisation, organisateur: $organisateur, dateDebut: $dateDebut, heure: $heure, tarif: $tarif, dateFin: $dateFin, tel: $tel, email: $email, nbPlaces: $nbPlaces, categoriesEvent: $categoriesEvent, tags: $tags, ideventImg: $ideventImg, idevent: $idevent, img: $img, category: $category)';
  }

  @override
  bool operator ==(covariant Evenement other) {
    if (identical(this, other)) return true;
  
    return 
      other.idEvent == idEvent &&
      other.nom == nom &&
      other.lieu == lieu &&
      other.localisation == localisation &&
      other.organisateur == organisateur &&
      other.dateDebut == dateDebut &&
      other.heure == heure &&
      other.tarif == tarif &&
      other.dateFin == dateFin &&
      other.tel == tel &&
      other.email == email &&
      other.nbPlaces == nbPlaces &&
      other.categoriesEvent == categoriesEvent &&
      other.tags == tags &&
      other.ideventImg == ideventImg &&
      other.idevent == idevent &&
      other.img == img &&
      other.category == category;
  }

  @override
  int get hashCode {
    return idEvent.hashCode ^
      nom.hashCode ^
      lieu.hashCode ^
      localisation.hashCode ^
      organisateur.hashCode ^
      dateDebut.hashCode ^
      heure.hashCode ^
      tarif.hashCode ^
      dateFin.hashCode ^
      tel.hashCode ^
      email.hashCode ^
      nbPlaces.hashCode ^
      categoriesEvent.hashCode ^
      tags.hashCode ^
      ideventImg.hashCode ^
      idevent.hashCode ^
      img.hashCode ^
      category.hashCode;
  }
}
