import 'package:flutter/material.dart';
import 'package:flutter_application_1/Server/server.dart';

class AppBarMain extends StatefulWidget {
  const AppBarMain({Key? key}) : super(key: key);

  @override
  State<AppBarMain> createState() => _AppBarMainState();
}

class _AppBarMainState extends State<AppBarMain> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(83, 89, 219, 1),
          Color.fromRGBO(32, 39, 160, 0.6),
        ])),
      ),
      title: Text(
        'برنامج القدس للمحاسبة',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(Icons.menu),
        iconSize: 25,
      ),
    );
  }
}
