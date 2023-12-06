import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:wingman/screens/home_screen.dart';

import 'package:flutter/services.dart';
import 'package:wingman/shared/server_helper.dart';

class ResponseScreen extends StatelessWidget {
  const ResponseScreen(this.futureResponse, {super.key});

  final Future<Response> futureResponse; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),
        
            // title
            const Text("Wingman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
      
            // gap
            const SizedBox(height: 50,),
            FutureBuilder(
              future: futureResponse, 
              builder:(context, snapshot) {
                if (snapshot.hasData) {
                  String response = ServerHelper.parseResponse(snapshot.data!);
                  return Column(
                    children: [
                      Text("Your response:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          color: Colors.blue[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              response,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                         
                        onPressed: () async {
                          // copied text
                          await Clipboard.setData(ClipboardData(text: response));
                        }, 
                        child: Text("Copy text")
                      )
                    ],
                  );
                }
                else {
                  return Center(child: CircularProgressIndicator());
                }
                
              },
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Note: for best results, crop out irrelevant text (such as keyboard). App works best on photos with a white background",
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity, // Makes the FAB wide
          child: FloatingActionButton.extended(
            onPressed: () =>  Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false
            ), 
            icon: const Icon(Icons.refresh),
            label: const Text('Try new screenshot'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}