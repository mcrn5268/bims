import 'package:flutter/material.dart';

class AddPersonScreen extends StatelessWidget {
  const AddPersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Text(
          'AddPersonScreen Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}


// ColorFiltered(
//           colorFilter: ColorFilter.mode(Colors.white, BlendMode.modulate),
//           child: Image.asset(
//             "assets/black_image.png",
//             width: 200,
//             height: 200,
//           ),
//         ),