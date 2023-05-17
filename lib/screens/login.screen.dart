import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat/helpers/mostrar_alerta.helper.dart';
import 'package:chat/services/services.dart';
import 'package:chat/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Logo(
                    titulo: 'Messenger',
                  ),
                  _Form(),
                  Labels(
                      titulo: '¿No tienes cuenta?',
                      subtitulo: '¡Crea una ahora!',
                      ruta: 'register'),
                  Text('Términos y condiciones de uso',
                      style: TextStyle(fontWeight: FontWeight.w200))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => __FormState();
}

final emailController = TextEditingController();
final passController = TextEditingController();

class __FormState extends State<_Form> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passController,
            isPassword: true,
          ),
          BotonAzul(
              texto: 'Ingrese',
              onPressed: authService.autenticando
                  ? () => Null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final loginOk = await authService.login(
                          emailController.text, passController.text);

                      if (loginOk) {
                        socketService.connect();
                        Navigator.pushReplacementNamed(context, 'usuarios');
                      } else {
                        //Mostrar alerta
                        mostrarAlerta(context, 'Login incorrecto',
                            'Revise sus crendenciales nuevamente');
                      }
                    }),
        ],
      ),
    );
  }
}
