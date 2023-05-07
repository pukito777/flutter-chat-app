import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String texto;
  final Function() onPressed;

  const BotonAzul({super.key, required this.texto, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: Colors.blue,
          shape: const StadiumBorder()),
      onPressed: onPressed,
      child: SizedBox(
          width: double.infinity,
          height: 55,
          child: Center(
              child: Text(
            texto,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ))),
    );
  }
}
