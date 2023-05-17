// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromJson(jsonString);

import 'dart:convert';
import 'package:chat/models/usuario.model.dart';

UsuariosResponse usuariosResponseFromJson(String str) => UsuariosResponse.fromJson(json.decode(str));

String usuariosResponseToMap(UsuariosResponse data) => json.encode(data.toJson());

class UsuariosResponse {   
    UsuariosResponse({
        required this.ok,
        required this.usuarios,
    });

    bool ok;
    List<UsuarioModel> usuarios;

    factory UsuariosResponse.fromJson(Map<String, dynamic> json) => UsuariosResponse(
        ok: json["ok"],
        usuarios: List<UsuarioModel>.from(json["usuarios"].map((x) => UsuarioModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}

