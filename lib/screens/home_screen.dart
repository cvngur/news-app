import 'package:flutter/material.dart';
import 'package:news_app/screens/home_body.dart';
import 'package:news_app/screens/settings.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('News App'),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      backgroundColor: Colors.amber,
      body: HomeBody(),
    );
  }
}