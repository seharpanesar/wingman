import 'package:flutter/material.dart';
import 'package:wingman/screens/home_screen.dart';

class ResponseScreen extends StatelessWidget {
  const ResponseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_outlined),
      //     onPressed: () => 
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Response here")),
          ElevatedButton(
            onPressed: () =>  Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false
            ), 
            child: Text("Try again!")
          )
        ],
      ),
    );
  }
}