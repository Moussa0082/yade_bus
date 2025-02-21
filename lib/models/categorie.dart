
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoriesEvent {
    String? nom;
    int? idCategory;

    CategoriesEvent({
         this.nom,
         this.idCategory,
    });




  CategoriesEvent copyWith({
    String? nom,
    int? idCategory,
  }) {
    return CategoriesEvent(
      nom: nom ?? this.nom,
      idCategory: idCategory ?? this.idCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nom': nom,
      'idCategory': idCategory,
    };
  }

  factory CategoriesEvent.fromMap(Map<String, dynamic> map) {
    return CategoriesEvent(
      nom: map['nom'] != null ? map['nom'] as String : null,
      idCategory: map['idCategory'] != null ? map['idCategory'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoriesEvent.fromJson(String source) => CategoriesEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CategoriesEvent(nom: $nom, idCategory: $idCategory)';

  @override
  bool operator ==(covariant CategoriesEvent other) {
    if (identical(this, other)) return true;
  
    return 
      other.nom == nom &&
      other.idCategory == idCategory;
  }

  @override
  int get hashCode => nom.hashCode ^ idCategory.hashCode;
}
