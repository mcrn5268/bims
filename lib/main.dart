import 'package:bims/Screens/auth.dart';
import 'package:bims/Screens/home.dart';
import 'package:bims/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const BIMSMain());
}

class BIMSMain extends StatelessWidget {
  const BIMSMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return MaterialApp(
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                color: Colors.blueGrey,
              ),
              fontFamily: 'Playfair Display',
            ),
            home: userProvider.user != null
                ? const BIMSHome()
                : const AuthScreen(),
          );
        },
      ),
    );
  }
}
