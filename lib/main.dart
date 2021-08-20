import 'package:flutter/material.dart';

import 'db.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

final db = MyDatabase();

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await db.populate();
            print(await db.query(Status.red)); // ok
            print(await db.query(Status.green)); // ok
            print(await db.query(null)); // error
          },
          child: Text('TEST'),
        ),
      ),
    );
  }
}
