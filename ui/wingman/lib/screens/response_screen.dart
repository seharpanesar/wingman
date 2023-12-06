import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:wingman/screens/home_screen.dart';

class ResponseScreen extends StatelessWidget {
  const ResponseScreen(this.futureResponse, {super.key});

  final Future<Response> futureResponse; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: futureResponse, 
            builder:(context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Text(
                    snapshot.data.toString()
                  )
                );
              }
              else {
                return CircularProgressIndicator();
              }
              
            },
          ),
          
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