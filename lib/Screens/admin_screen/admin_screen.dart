import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_application_1/Server/server.dart';

import '../../Services/Drawer/drawer.dart';
import '../login_screen/login_page.dart';
import '../settings/settings_card/setting_Card.dart';

class AdminScreen extends StatefulWidget {
  bool admin;
  AdminScreen({
    Key? key,
    required this.admin,
  }) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  Widget build(BuildContext context) {
    return Container(
      color: Main_Color,
      child: SafeArea(
          child: Scaffold(
        key: _scaffoldState,
        drawer: DrawerMain(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                "اضافه مستخدم",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "أسم المستخدم",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  controller: nameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff34568B), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "أسم المستخدم",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "كلمه المرور",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  controller: passwordController,
                  obscureText: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff34568B), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "كلمه المرور",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "تأكيد كلمه المرور",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  controller: repasswordController,
                  obscureText: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff34568B), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "تأكيد كلمه المرور",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "رقم الشركه",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  controller: companyIDController,
                  obscureText: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff34568B), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "رقم الشركه",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "رقم المندوب",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  controller: salesmanIDController,
                  obscureText: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff34568B), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "رقم المندوب",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "رقم الشركه الثاني",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  controller: companyID2Controller,
                  obscureText: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff34568B), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "رقم الشركه الثاني",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "رقم المندوب الثاني",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  controller: salesmanID2Controller,
                  obscureText: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff34568B), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "رقم المندوب الثاني",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "رقم الشركة الثالث",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  controller: companyID3Controller,
                  obscureText: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff34568B), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "رقم الشركة الثالث",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "رقم المندوب الثالث",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  controller: salesmanID3Controller,
                  obscureText: false,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff34568B), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "رقم المندوب الثالث",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, right: 15, left: 15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 7,
                    blurRadius: 5,
                  ),
                ], borderRadius: BorderRadius.circular(4), color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      // SettingsCard(
                      //   status: orders,
                      //   Status: () async {
                      //     setState(() {
                      //       orders = !orders;
                      //     });
                      //   },
                      //   name: "اظهار الطلبيات",
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10),
                      //   child: Container(
                      //     width: double.infinity,
                      //     height: 1,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      // SettingsCard(
                      //   status: orders,
                      //   Status: () async {
                      //     setState(() {
                      //       orders = !orders;
                      //     });
                      //   },
                      //   name: "اظهار سندات القبض",
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 10),
                      //   child: Container(
                      //     width: double.infinity,
                      //     height: 1,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      SettingsCard(
                        status: orders,
                        Status: () {
                          setState(() {
                            orders = !orders;
                          });
                        },
                        name: "فقط كشف حساب",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 25, left: 25, top: 35, bottom: 20),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 50,
                minWidth: double.infinity,
                color: Color(0xff34568B),
                textColor: Colors.white,
                child: Text(
                  "اضافه مستخدم",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SizedBox(
                            height: 100,
                            width: 100,
                            child: Center(child: CircularProgressIndicator())),
                      );
                    },
                  );
                  send();
                },
              ),
            ),
          ],
        )),
      )),
    );
  }

  bool orders = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController companyIDController = TextEditingController();
  TextEditingController companyID2Controller = TextEditingController();
  TextEditingController companyID3Controller = TextEditingController();
  TextEditingController salesmanIDController = TextEditingController();
  TextEditingController salesmanID2Controller = TextEditingController();
  TextEditingController salesmanID3Controller = TextEditingController();

  send() async {
    if (companyIDController.text == '' ||
        passwordController.text == '' ||
        repasswordController.text == '' ||
        salesmanIDController.text == '' ||
        nameController.text == '') {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("الرجاء تعبئه جمبع الفراغات"),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'حسنا',
                  style: TextStyle(color: Color(0xff34568B)),
                ),
              ),
            ],
          );
        },
      );
    } else if (passwordController.text != repasswordController.text) {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("كلمه المرور غير متطابقه"),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'حسنا',
                  style: TextStyle(color: Color(0xff34568B)),
                ),
              ),
            ],
          );
        },
      );
    } else {
      String companyId = companyIDController.text;
      String companyId2 = companyID2Controller.text;
      String companyId3 = companyID3Controller.text;
      Map<String, dynamic> requestData = {
        'company_id': companyId,
        'company_id_2': companyId2,
        'company_id_3': companyId3,
      };
      if (companyId.isNotEmpty ||
          companyId2.isNotEmpty ||
          companyId3.isNotEmpty) {
        // Add 'companies_length' if at least one company field is non-empty
        requestData['companies_length'] = [companyId, companyId2, companyId3]
            .where((element) => element.isNotEmpty)
            .length
            .toString();
      }
      String salesManID = salesmanIDController.text;
      String salesManID2 = salesmanID2Controller.text;
      String salesManID3 = salesmanID3Controller.text;
      Map<String, dynamic> requestDataSalesMaxIDs = {
        'salesman_id': salesManID,
        'salesman_id_2': salesManID2,
        'salesman_id_3': salesManID3,
      };
      if (salesManID.isNotEmpty ||
          salesManID2.isNotEmpty ||
          salesManID3.isNotEmpty) {
        requestDataSalesMaxIDs['salesman_ids_length'] = [
          salesManID,
          salesManID2,
          salesManID3
        ].where((element) => element.isNotEmpty).length.toString();
      }
      String? deviceId = await _getId();
      var url = 'https://aliexpress.ps/quds_laravel/api/register';
      var headers = {"Accept": "application/json"};
      final response = await http.post(Uri.parse(url),
          body: {
            'password': passwordController.text,
            'device_id': deviceId.toString(),
            'name': nameController.text,
            'just': orders ? "yes" : "no",
            'company_id': companyIDController.text,
            'company_id_2': companyID2Controller.text,
            'company_id_3': companyID3Controller.text,
            'companies_length': requestData["companies_length"],
            'salesman_id_2': salesmanID2Controller.text,
            'salesman_id_3': salesmanID3Controller.text,
            'salesman_ids_length':
                requestDataSalesMaxIDs["salesman_ids_length"],
            'salesman_id': salesmanIDController.text,
            'active': widget.admin ? "yes" : "no",
          },
          headers: headers);

      var data = jsonDecode(response.body);
      if (data['status'] == 'true') {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: "تم اضافه المستخدم بنجاح");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else if (response.statusCode != 200) {
        editUser();
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        print("failed");
      }
    }
  }

  editUser() async {
    String? deviceId = await _getId();
    var url = 'https://aliexpress.ps/quds_laravel/api/delete_user/$deviceId';
    var headers = {"Accept": "application/json"};
    final response = await http.post(Uri.parse(url), headers: headers);

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      String companyId = companyIDController.text;
      String companyId2 = companyID2Controller.text;
      String companyId3 = companyID3Controller.text;
      Map<String, dynamic> requestData = {
        'company_id': companyId,
        'company_id_2': companyId2,
        'company_id_3': companyId3,
      };
      if (companyId.isNotEmpty ||
          companyId2.isNotEmpty ||
          companyId3.isNotEmpty) {
        // Add 'companies_length' if at least one company field is non-empty
        requestData['companies_length'] = [companyId, companyId2, companyId3]
            .where((element) => element.isNotEmpty)
            .length
            .toString();
      }
      String salesManID = salesmanIDController.text;
      String salesManID2 = salesmanID2Controller.text;
      String salesManID3 = salesmanID3Controller.text;
      Map<String, dynamic> requestDataSalesMaxIDs = {
        'salesman_id': salesManID,
        'salesman_id_2': salesManID2,
        'salesman_id_3': salesManID3,
      };
      if (salesManID.isNotEmpty ||
          salesManID2.isNotEmpty ||
          salesManID3.isNotEmpty) {
        requestDataSalesMaxIDs['salesman_ids_length'] = [
          salesManID,
          salesManID2,
          salesManID3
        ].where((element) => element.isNotEmpty).length.toString();
      }
      Navigator.of(context, rootNavigator: true).pop();

      var url = 'https://aliexpress.ps/quds_laravel/api/register';
      var headers = {"Accept": "application/json"};
      final response = await http.post(Uri.parse(url),
          body: {
            'password': passwordController.text,
            'device_id': deviceId.toString(),
            'name': nameController.text,
            'just': orders ? "yes" : "no",
            'company_id': companyIDController.text,
            'company_id_2': companyID2Controller.text,
            'company_id_3': companyID3Controller.text,
            'companies_length': requestData['companies_length'],
            'salesman_id_2': salesmanID2Controller.text,
            'salesman_id_3': salesmanID3Controller.text,
            'salesman_ids_length':
                requestDataSalesMaxIDs["salesman_ids_length"],
            'salesman_id': salesmanIDController.text,
            'active': widget.admin ? "yes" : "no",
          },
          headers: headers);

      var data = jsonDecode(response.body);
      if (data['status'] == 'true') {
        // Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: "تم تعديل المستخدم بنجاح");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: "فشلت عمليه التعديل الرجاء المحاوله مجددا");
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(msg: "فشلت عمليه التعديل الرجاء المحاوله مجددا");
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
