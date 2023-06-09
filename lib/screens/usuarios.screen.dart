import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/services/services.dart';

import 'package:chat/models/models.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final usuariosService = UsuariosService();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<UsuarioModel> usuarios = [];

/*
  final usuarios = [
    UsuarioModel(
        uid: '1', nombre: 'María', email: 'test1@test.com', online: true),
    UsuarioModel(
        uid: '2', nombre: 'Melissa', email: 'test2@test.com', online: false),
    UsuarioModel(
        uid: '3', nombre: 'Fernando', email: 'test3@test.com', online: true),
  ];
*/

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              usuario.nombre,
              style: const TextStyle(color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.blue[400],
                    )
                  : const Icon(
                      Icons.offline_bolt,
                      color: Colors.red,
                    ),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Colors.blue,
          ),
          child: _listViewUsuarios(),
        ));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(UsuarioModel usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[200],
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioDestino = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async {
    usuarios = await usuariosService.getUsuarios();
    setState(() {});
    //await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
