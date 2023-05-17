import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/services.dart';

import 'package:chat/helpers/mostrar_alerta.helper.dart';
import 'package:chat/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .99,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Logo(
                    titulo: 'Registro',
                  ),
                  _Form(),
                  Labels(
                      titulo: '¿Ya tienes una cuenta?',
                      subtitulo: '¡Ingresa ahora!',
                      ruta: 'login'),
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

final nameController = TextEditingController();
final correoController = TextEditingController();
final passwordController = TextEditingController();

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
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameController,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: correoController,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passwordController,
            isPassword: true,
          ),
          BotonAzul(
              texto: 'Crear Cuenta',
              onPressed: authService.autenticando
                  ? () => Null
                  : () async {
                      final registroOk = await authService.register(
                          nameController.text.trim(),
                          correoController.text.trim(),
                          passwordController.text.trim());
                      if (registroOk == true) {
                        socketService.connect();
                        Navigator.pushReplacementNamed(context, 'usuarios');
                      } else {
                        mostrarAlerta(
                            context, 'Registro incorrecto', registroOk);
                      }
                    })
        ],
      ),
    );
  }
}
