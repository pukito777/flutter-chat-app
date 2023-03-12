import 'package:chat/screens/screens.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> appRoutes = {
  'usuarios': (_) => UsuariosScreen(),
  'chat': (_) => ChatScreen(),
  'login': (_) => LoginScreen(),
  'register': (_) => RegisterScreen(),
  'loading': (_) => LoadingScreen()
};
