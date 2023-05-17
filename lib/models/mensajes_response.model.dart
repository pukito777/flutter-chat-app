// To parse this JSON data, do
//
//     final mensajesResponse = mensajesResponseFromJson(jsonString);

import 'dart:convert';

MensajesResponse mensajesResponseFromJson(String str) =>
    MensajesResponse.fromJson(json.decode(str));

String mensajesResponseToJson(MensajesResponse data) =>
    json.encode(data.toJson());

class MensajesResponse {
  bool ok;
  List<Mensaje> mensajes;
  String msg;

  MensajesResponse({
    required this.ok,
    required this.mensajes,
    required this.msg,
  });

  factory MensajesResponse.fromJson(Map<String, dynamic> json) =>
      MensajesResponse(
        ok: json["ok"],
        mensajes: List<Mensaje>.from(
            json["mensajes"].map((x) => Mensaje.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
        "msg": msg,
      };
}

class Mensaje {
  String origen;
  String destino;
  String mensaje;
  DateTime createdAt;
  DateTime updatedAt;

  Mensaje({
    required this.origen,
    required this.destino,
    required this.mensaje,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        origen: json["origen"],
        destino: json["destino"],
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "origen": origen,
        "destino": destino,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
