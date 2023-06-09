// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromJson(jsonString);

import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  String nombre;
  String email;
  bool online;
  String uid;

  UsuarioModel({
    required this.nombre,
    required this.email,
    required this.online,
    required this.uid,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        nombre: json["nombre"],
        email: json["email"],
        online: json["online"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "online": online,
        "uid": uid,
      };
}
