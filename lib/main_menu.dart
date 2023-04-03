import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/nfc/write');
              },
              child: Text('Ecriture NFC')),
          MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/nfc/read');
              },
              child: Text('Lecture NFC')),
        ],
      ),
    );
  }
}
