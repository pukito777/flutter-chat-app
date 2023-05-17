import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/services.dart';

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
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      socketService.connect();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => UsuariosScreen(),
            transitionDuration: const Duration(milliseconds: 0)),
      );
    } else {      
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginScreen(),
            transitionDuration: const Duration(milliseconds: 0)),
      );
    }
  }
}
