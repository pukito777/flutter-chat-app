import 'package:http/http.dart' as http;

import 'package:chat/models/models.dart';
import 'package:chat/global/environment.dart';

import 'package:chat/services/services.dart';


class UsuariosService {
  Future<List<UsuarioModel>> getUsuarios() async {
    try {
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );
      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
