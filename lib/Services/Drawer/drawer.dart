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

import '../../Screens/customers/customers.dart';
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
  bool moreComanies = false;
  bool showMoneyMovments = false;
  var roleID;
  setConrollers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _roleID = prefs.getString('role_id');
    List<String>? _companies =
        await prefs.getStringList("companiesList") ?? [""];
    int? salesmanID = await prefs.getInt("salesman_id");
    if (salesmanID.toString() == "999") {
      showMoneyMovments = true;
    } else {
      showMoneyMovments = false;
    }
    if (_companies!.length == 1) {
      moreComanies = false;
    } else {
      moreComanies = true;
    }

    roleID = _roleID.toString();

    setState(() {});
    print("showMoneyMovments");
    print(showMoneyMovments);
  }

  @override
  void initState() {
    setConrollers();
    super.initState();
  }

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
          Visibility(
            visible: roleID.toString() == "4" ? false : true,
            child: DrawerCard(
                navi: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TotalReceivables()));
                },
                name: "مجمل الذمم",
                myicon: Icon(Icons.money)),
          ),
          Visibility(
            visible: roleID.toString() == "4" ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
              child: Container(
                  width: double.infinity, height: 2, color: Color(0xffC6C5C5)),
            ),
          ),
          Visibility(
            visible: roleID.toString() == "4" ? false : showMoneyMovments,
            child: Column(
              children: [
                DrawerCard(
                    navi: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoneyMovement()));
                    },
                    name: "مجمل الحركات",
                    myicon: Icon(Icons.move_up)),
                Padding(
                  padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
                  child: Container(
                      width: double.infinity,
                      height: 2,
                      color: Color(0xffC6C5C5)),
                ),
              ],
            ),
          ),
          Visibility(
            visible: roleID.toString() == "3" || roleID.toString() == "4"
                ? false
                : true,
            child: DrawerCard(
                navi: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Catches()));
                },
                name: "سندات القبض",
                myicon: Icon(Icons.receipt)),
          ),
          Visibility(
            visible: roleID.toString() == "3" || roleID.toString() == "4"
                ? false
                : true,
            child: Padding(
              padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
              child: Container(
                  width: double.infinity, height: 2, color: Color(0xffC6C5C5)),
            ),
          ),
          Visibility(
            visible: roleID.toString() == "3" || roleID.toString() == "4"
                ? false
                : true,
            child: DrawerCard(
                navi: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Sarf()));
                },
                name: "سندات الصرف",
                myicon: Icon(Icons.receipt)),
          ),
          Visibility(
            visible: roleID.toString() == "3" || roleID.toString() == "4"
                ? false
                : true,
            child: Padding(
              padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
              child: Container(
                  width: double.infinity, height: 2, color: Color(0xffC6C5C5)),
            ),
          ),
          Visibility(
            visible: roleID.toString() == "3" ? false : true,
            child: DrawerCard(
                navi: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Orders()));
                },
                name: "الطلبيات",
                myicon: Icon(Icons.request_quote_sharp)),
          ),
          Visibility(
            visible: roleID.toString() == "3" ? false : true,
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
          Visibility(
            visible: moreComanies,
            child: Column(
              children: [
                DrawerCard(
                    navi: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      List<String>? _companies =
                          await prefs.getStringList("companiesList");
                      int? salesman_id1 = await prefs.getInt("salesman_id1");
                      int? salesman_id2 = await prefs.getInt("salesman_id2");
                      int? salesman_id3 = await prefs.getInt("salesman_id3");
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "الرجاء اختر رقم الشركة",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 35, left: 35),
                                  child: ListView.builder(
                                    itemCount: _companies!.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: SizedBox(
                                                      height: 100,
                                                      width: 100,
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator())),
                                                );
                                              },
                                            );
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            await Future.delayed(
                                                Duration(milliseconds: 300));
                                            await prefs.setInt(
                                                'company_id',
                                                int.parse(_companies[index]
                                                    .toString()));
                                            await prefs.setStringList(
                                                'companiesList', _companies);
                                            await prefs.setInt(
                                                'salesman_id',
                                                int.parse(index == 0
                                                    ? salesman_id1.toString()
                                                    : index == 1
                                                        ? salesman_id2
                                                            .toString()
                                                        : salesman_id3
                                                            .toString()));
                                            var headers = {
                                              'ContentType': 'application/json'
                                            };
                                            var url =
                                                'https://aliexpress.ps/quds_laravel/api/customers/${_companies[index].toString()}/${index == 0 ? salesman_id1.toString() : index == 1 ? salesman_id2 : salesman_id3}';
                                            var response = await http.get(
                                                Uri.parse(url),
                                                headers: headers);
                                            var res = jsonDecode(
                                                response.body)['customers'];

                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Customers(
                                                  CustomersArray: res,
                                                  companiesArray: _companies,
                                                ),
                                              ),
                                              (route) => false,
                                            );
                                            Fluttertoast.showToast(
                                              msg: 'تم تسجيل الدخول بنجاح',
                                            );
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Color.fromRGBO(83, 89, 219, 1),
                                                Color.fromRGBO(
                                                    32, 39, 160, 0.6),
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                _companies[index],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    name: "اختيار الشركة",
                    myicon: Icon(Icons.store)),
                Padding(
                  padding: const EdgeInsets.only(right: 35, left: 35, top: 10),
                  child: Container(
                      width: double.infinity,
                      height: 2,
                      color: Color(0xffC6C5C5)),
                ),
              ],
            ),
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
