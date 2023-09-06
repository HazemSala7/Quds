import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_application_1/Screens/customers/customers.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_application_1/Services/AppBar/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Services/Drawer/drawer.dart';
import '../admin_screen/admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  loginFunction() async {
    if (idController.text == "98" && passwordController.text == "yagh2255") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminScreen()));
    } else if (idController.text == '' || passwordController.text == '') {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('الرجاء تعبئه جميع الفراغات'),
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
    } else if (idController.text == "app" &&
        passwordController.text == "store") {
      var headers = {'ContentType': 'application/json'};
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('company_id', 5);
      await prefs.setInt('salesman_id', 999);
      await prefs.setBool('login', true);
      await prefs.setString('just', "true");
      setState(() {
        JUST = true;
      });
      var url = 'https://yaghco.website/quds_laravel/api/customers/5/999';
      var response = await http.get(Uri.parse(url), headers: headers);
      var res = jsonDecode(response.body)['customers'];
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Customers(
            CustomersArray: res,
          ),
        ),
        (route) => false,
      );

      Fluttertoast.showToast(
        msg: 'تم تسجيل الدخول بنجاح',
      );
    } else {
      String? deviceId = await _getId();
      var url = 'https://yaghco.website/quds_laravel/api/login';
      var response = await http.post(Uri.parse(url), body: {
        "name": idController.text,
        "device_id": deviceId,
        "password": passwordController.text,
      });
      var data = jsonDecode(response.body.toString());

      if (data['status'] == 'true') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = data["data"]['access_token'] ?? "";
        int id = data["data"]['id'] ?? 0;
        String company_id = data["data"]['company_id'] ?? "0";
        String salesman_id = data["data"]['salesman_id'] ?? "0";
        String just = data["data"]['just'] ?? "no";
        if (just == "no") {
          setState(() {
            JUST = true;
          });
        } else {
          setState(() {
            JUST = false;
          });
        }
        await prefs.setString('access_token', token);
        await prefs.setInt('id', id);
        await prefs.setInt('company_id', int.parse(company_id));
        await prefs.setInt('salesman_id', int.parse(salesman_id));
        await prefs.setString('password', passwordController.text);
        await prefs.setString('just', just);
        await prefs.setBool('login', true);
        var headers = {'ContentType': 'application/json'};
        var url =
            'https://yaghco.website/quds_laravel/api/customers/$company_id/$salesman_id';
        var response = await http.get(Uri.parse(url), headers: headers);
        var res = jsonDecode(response.body)['customers'];
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Customers(
              CustomersArray: res,
            ),
          ),
          (route) => false,
        );
        Fluttertoast.showToast(
          msg: 'تم تسجيل الدخول بنجاح',
        );
      } else if (data['message'] == 'Invalid login details') {
        Navigator.of(context, rootNavigator: true).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('الرجاء التأكد من البيانات المدخله'),
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
        Navigator.of(context, rootNavigator: true).pop();
        print('sdfsd');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Main_Color,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Main_Color,
            title: Text(
              'برنامج القدس للمحاسبة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width - 80,
                      child: Image.asset(
                        'assets/quds_logo.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "أسم المستخدم",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                        controller: idController,
                        obscureText: false,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 50,
                                child: Icon(Icons.person, size: 25)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color(0xff34568B), width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD6D3D3)),
                          ),
                          hintText: "أسم المستخدم",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "كلمه المرور",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: InkWell(
                              onTap: () {
                                toggle();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                  'assets/view.jpeg',
                                  height: 25,
                                  width: 25,
                                  fit: BoxFit.fitWidth,
                                  color: Color(0xffB1B1B1),
                                ),
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Color(0xff34568B), width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD6D3D3)),
                          ),
                          hintText: "كلمه المرور",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 15, left: 15, top: 35),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 50,
                      minWidth: double.infinity,
                      color: Color(0xff34568B),
                      textColor: Colors.white,
                      child: Text(
                        AppLocalizations.of(context)!.login,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            );
                          },
                        );

                        loginFunction();
                      },
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(right: 15, left: 15, top: 35),
                  //   child: MaterialButton(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(10))),
                  //     height: 50,
                  //     minWidth: double.infinity,
                  //     color: Color(0xff34568B),
                  //     textColor: Colors.white,
                  //     child: Text(
                  //       "Saver",
                  //       style: TextStyle(
                  //           fontSize: 22, fontWeight: FontWeight.bold),
                  //     ),
                  //     onPressed: () async {
                  //       await GallerySaver.saveImage(
                  //           "https://cdn.pixabay.com/photo/2015/04/19/08/32/marguerite-729510_1280.jpg");
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
