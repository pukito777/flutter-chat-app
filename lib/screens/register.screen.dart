import 'package:flutter/material.dart';

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
              height: MediaQuery.of(context).size.height * .9,
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
                    ruta: 'login',
                  ),
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
final _emailController = TextEditingController();
final _passController = TextEditingController();

class __FormState extends State<_Form> {
  @override
  Widget build(BuildContext context) {
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
            textController: _emailController,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: _passController,
            isPassword: true,
          ),
          BotonAzul(
            text: 'Ingrese',
            onPressed: () {
              print(_emailController);
              print(_passController);
            },
          )
        ],
      ),
    );
  }
}
