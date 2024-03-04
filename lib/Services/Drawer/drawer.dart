import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/catches/catches.dart';
import 'package:flutter_application_1/Screens/login_screen/login_page.dart';
import 'package:flutter_application_1/Screens/sarf/sarf.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_application_1/Services/Drawer/card_drawer/card_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Screens/money_movements/money_movements.dart';
import '../../Screens/orders/orders.dart';
import '../../Screens/settings/settings.dart';
import '../../Screens/total_receivables/total_receivables.dart';

bool mylang = false;

class DrawerMain extends StatefulWidget {
  const DrawerMain({Key? key}) : super(key: key);

  @override
  _DrawerMainState createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              DrawerHeader(
                padding: EdgeInsets.all(0),
                child: Image.asset(
                  'assets/images/logo.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ],
          ),
          DrawerCard(
              navi: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TotalReceivables()));
              },
              name: "مجمل الذمم",
              myicon: Icon(Icons.money)),
          Visibility(
            visible: JUST,
            child: Padding(
              padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
              child: Container(
                  width: double.infinity, height: 2, color: Color(0xffC6C5C5)),
            ),
          ),
          DrawerCard(
              navi: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MoneyMovement()));
              },
              name: "مجمل الحركات",
              myicon: Icon(Icons.move_up)),
          Padding(
            padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
            child: Container(
                width: double.infinity, height: 2, color: Color(0xffC6C5C5)),
          ),
          Visibility(
            visible: JUST,
            child: DrawerCard(
                navi: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Catches()));
                },
                name: "سندات القبض",
                myicon: Icon(Icons.receipt)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
            child: Container(
                width: double.infinity, height: 2, color: Color(0xffC6C5C5)),
          ),
          Visibility(
            visible: JUST,
            child: DrawerCard(
                navi: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Sarf()));
                },
                name: "سندات الصرف",
                myicon: Icon(Icons.receipt)),
          ),
          Visibility(
            visible: JUST,
            child: Padding(
              padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
              child: Container(
                  width: double.infinity, height: 2, color: Color(0xffC6C5C5)),
            ),
          ),
          Visibility(
            visible: JUST,
            child: DrawerCard(
                navi: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Orders()));
                },
                name: "الطلبيات",
                myicon: Icon(Icons.request_quote_sharp)),
          ),
          Visibility(
            visible: JUST,
            child: Padding(
              padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
              child: Container(
                  width: double.infinity, height: 2, color: Color(0xffC6C5C5)),
            ),
          ),
          DrawerCard(
              navi: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
              name: "تعريفات أوليه",
              myicon: Icon(Icons.perm_device_information)),
          Padding(
            padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
            child: Container(
                width: double.infinity, height: 2, color: Color(0xffC6C5C5)),
          ),
          DrawerCard(
              navi: () async {
                Navigator.of(context, rootNavigator: true).pop();
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()),
                    (Route<dynamic> route) => false);
                Fluttertoast.showToast(msg: "تم تسجيل الخروج بنجاح");
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       content: Text("هل تريد بالتأكيد تسجيل الخروج ؟"),
                //       actions: <Widget>[
                //         FlatButton(
                //           child: Text(
                //             "نعم",
                //             style: TextStyle(color: Main_Color),
                //           ),
                //           onPressed: () async {
                //             await logoutFunction();
                //           },
                //         ),
                //         FlatButton(
                //           child: Text(
                //             "لا",
                //             style: TextStyle(color: Main_Color),
                //           ),
                //           onPressed: () {
                //             Navigator.pop(context);
                //           },
                //         ),
                //       ],
                //     );
                //   },
                // );
              },
              name: "تسجيل خروج",
              myicon: Icon(Icons.logout)),
          Padding(
            padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
            child: Container(
                width: double.infinity, height: 2, color: Color(0xffC6C5C5)),
          ),
        ],
      ),
    );
  }
}
