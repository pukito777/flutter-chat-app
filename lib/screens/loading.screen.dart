import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';

import 'package:chat/screens/screens.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: CheckLoginState(context),
          builder: (context, snapshot) {
            return const Center(
              child: Text('Espere...'),
            );
          }),
    );
  }

  Future CheckLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      // TODO: conectar al socket server
      //Navigator.pushReplacementNamed(context, 'usuarios');
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => UsuariosScreen(),
            transitionDuration: const Duration(milliseconds: 0)),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginScreen(),
            transitionDuration: const Duration(milliseconds: 0)),
      );
    }
  }
}
