import 'package:flutter/material.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_application_1/main.dart';

class AppBarBack extends StatefulWidget {
  const AppBarBack({Key? key}) : super(key: key);

  @override
  State<AppBarBack> createState() => _AppBarBackState();
}

class _AppBarBackState extends State<AppBarBack> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Main_Color,
      title: Text(
        'برنامج القدس للمحاسبة',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            scanBarcode = '';
          });
        },
        icon: Icon(Icons.arrow_back),
        iconSize: 25,
      ),
    );
  }
}
