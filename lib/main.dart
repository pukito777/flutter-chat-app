import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/services.dart';

import 'package:chat/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        title: 'Chat App',
        initialRoute: 'login',
        routes: appRoutes,
        theme: ThemeData(useMaterial3: true),
      ),
    );
  }
}
