import 'package:bims/Screens/home.dart';
import 'package:bims/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const BIMSMain());
}

class BIMSMain extends StatelessWidget {
  const BIMSMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MaterialApp(
            theme: ThemeData(fontFamily: 'Playfair Display'),
            home: const BIMSHome()));
  }
}
