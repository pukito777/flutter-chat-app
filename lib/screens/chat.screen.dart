import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/services.dart';

import 'package:chat/models/models.dart';
import 'package:chat/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  void initState() {
    super.initState();
    //No se puede redibujar en initState por eso listen es falso
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService.usuarioDestino.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await chatService.getChat(usuarioID);
    final history = chat.map((m) => ChatMessage(
        texto: m.mensaje,
        uid: m.origen,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 0))
          ..forward()));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
        texto: payload['mensaje'],
        uid: payload['origen'],
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioDestino = chatService.usuarioDestino;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Column(children: <Widget>[
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 187, 222, 251),
              maxRadius: 14,
              child: Center(
                child: Text(
                  usuarioDestino.nombre.substring(0, 2),
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              usuarioDestino.nombre,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            )
          ]),
          centerTitle: true,
          elevation: 1,
        ),
        body: Column(children: <Widget>[
          Flexible(
              child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _messages.length,
            itemBuilder: (_, i) => _messages[i],
            reverse: true,
          )),
          const Divider(
            height: 1,
          ),
          //TODO: Caja de texto
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ]));
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: <Widget>[
          Flexible(
              child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmit,
            onChanged: (String texto) {
              setState(() {
                if (texto.trim().isNotEmpty) {
                  _isWriting = true;
                } else {
                  _isWriting = false;
                }
              });
            },
            decoration:
                const InputDecoration.collapsed(hintText: 'Envia mensaje'),
            focusNode: _focusNode,
          )),

          //Botón de enviar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _isWriting
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                    child: const Text('Enviar'),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
                        onPressed: _isWriting
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      ),
                    ),
                  ),
          )
        ]),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService.usuario.uid,
      texto: texto,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });

    socketService.emit('mensaje-personal', {
      'origen': authService.usuario.uid,
      'destino': chatService.usuarioDestino.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off(
      'mensaje-personal',
    );
    super.dispose();
  }
}
