
class UserModel {
  final int idAgent;
  final String username;
  final String nom;
  final String prenom;
  final String? authKey;
  final String telephone;
  final String adresse;

  UserModel({
    required this.idAgent,
    required this.username,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.adresse,
    this.authKey,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idAgent: json['idAgent'],
      username: json['username'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      adresse: json['adresse'],
      authKey: json['auth_key'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idAgent': idAgent,
      'username': username,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'adresse': adresse,
      'auth_key': authKey,
    };
  }
}
