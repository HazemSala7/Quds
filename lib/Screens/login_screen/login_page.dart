import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_application_1/Screens/customers/customers.dart';
import 'package:flutter_application_1/Screens/maintenance_page/maintenance_page.dart';
import 'package:flutter_application_1/Server/functions/functions.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_application_1/Services/AppBar/appbar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
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
          context,
          MaterialPageRoute(
              builder: (context) => AdminScreen(
                    admin: true,
                  )));
    } else if (idController.text == "100" &&
        passwordController.text == "123456789") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminScreen(
                    admin: false,
                  )));
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
      var url = 'https://aliexpress.ps/quds_laravel/api/customers/5/999';
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
      var url = 'https://aliexpress.ps/quds_laravel/api/login';
      var response = await http.post(Uri.parse(url), body: {
        "name": idController.text,
        "device_id": deviceId,
        "password": passwordController.text,
      });
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        if (data["status"] == "true") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = data["data"]['access_token'] ?? "";
          int id = data["data"]['id'] ?? 0;
          int companies_length =
              int.parse(data["data"]['companies_length'].toString());
          String company_id = data["data"]['company_id'] ?? "0";
          String salesman_id = data["data"]['salesman_id'] ?? "0";
          String salesman_id2 = data["data"]['salesman_id_2'] ?? "0";
          String salesman_id3 = data["data"]['salesman_id_3'] ?? "0";
          String roleID = data["data"]['role_id'] ?? "0";
          String just = data["data"]['just'] ?? "no";
          await prefs.setString('user_name', idController.text);
          await prefs.setString('password', passwordController.text);
          await prefs.setString('just', just);
          await prefs.setBool('login', true);
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
          await prefs.setString('role_id', roleID);
          await prefs.setInt('id', id);
          if (salesman_id != null && salesman_id != "") {
            await prefs.setInt('salesman_id1', int.parse(salesman_id));
          }
          if (salesman_id2 != null && salesman_id2 != "") {
            await prefs.setInt('salesman_id2', int.parse(salesman_id2));
          }
          if (salesman_id3 != null && salesman_id3 != "") {
            await prefs.setInt('salesman_id3', int.parse(salesman_id3));
          }

          if (companies_length == 1) {
            await prefs.setInt('company_id', int.parse(company_id.toString()));
            await prefs.setInt(
                'salesman_id', int.parse(salesman_id.toString()));
            var headers = {'ContentType': 'application/json'};
            var url =
                'https://aliexpress.ps/quds_laravel/api/customers/$company_id/$salesman_id';
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
            List<String> Companies = [];
            if (companies_length == 2) {
              Companies.add(company_id);
              Companies.add(data["data"]['company_id_2'].toString());
            } else if (companies_length == 3) {
              Companies.add(company_id);
              Companies.add(data["data"]['company_id_2'].toString());
              Companies.add(data["data"]['company_id_3'].toString());
            }
            Navigator.of(context, rootNavigator: true).pop();
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
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 35, left: 35),
                        child: ListView.builder(
                          itemCount: Companies.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
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
                                  await Future.delayed(
                                      Duration(milliseconds: 300));
                                  await prefs.setInt('company_id',
                                      int.parse(Companies[index].toString()));
                                  await prefs.setStringList(
                                      'companiesList', Companies);
                                  await prefs.setInt(
                                      'salesman_id',
                                      int.parse(index == 0
                                          ? salesman_id
                                          : index == 1
                                              ? salesman_id2
                                              : salesman_id3));
                                  var headers = {
                                    'ContentType': 'application/json'
                                  };
                                  var url =
                                      'https://aliexpress.ps/quds_laravel/api/customers/${Companies[index].toString()}/${index == 0 ? salesman_id : index == 1 ? salesman_id2 : salesman_id3}';
                                  var response = await http.get(Uri.parse(url),
                                      headers: headers);
                                  var res =
                                      jsonDecode(response.body)['customers'];

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Customers(
                                        CustomersArray: res,
                                        companiesArray: Companies,
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
                                      Color.fromRGBO(32, 39, 160, 0.6),
                                    ]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      Companies[index],
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
          }
        } else {
          Navigator.pop(context);
          NavigatorFunction(context, MaintenancePage());
        }
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
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(83, 89, 219, 1),
                          Color.fromRGBO(32, 39, 160, 0.6),
                        ])),
                    child: Center(
                      child: Text(
                        'حسنا',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
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
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(83, 89, 219, 1),
                          Color.fromRGBO(32, 39, 160, 0.6),
                        ])),
                    child: Center(
                      child: Text(
                        'حسنا',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e}';
        print("e");
        print(e);
      });
      return;
    }
    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    });
    if (authenticated) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? login = await prefs.getBool('login') ?? false;
      String? id = prefs.getString('user_name');
      if (login) {
        String? id = prefs.getString('user_name');
        String? password = prefs.getString('password');
        setState(() {
          idController.text = id.toString();
          passwordController.text = password.toString();
        });
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
        loginFunction();
      } else {
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
        loginFunction();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Main_Color,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Scaffold(
                body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/background.png'),
                              fit: BoxFit.fill)),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 30,
                            width: 80,
                            height: 200,
                            child: FadeInUp(
                                duration: Duration(seconds: 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/light-1.png'))),
                                )),
                          ),
                          Positioned(
                            left: 140,
                            width: 80,
                            height: 150,
                            child: FadeInUp(
                                duration: Duration(milliseconds: 1200),
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/light-2.png'))),
                                )),
                          ),
                          Positioned(
                            right: 40,
                            top: 40,
                            width: 80,
                            height: 150,
                            child: FadeInUp(
                                duration: Duration(milliseconds: 1300),
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/clock.png'))),
                                )),
                          ),
                          Positioned(
                            child: FadeInUp(
                                duration: Duration(milliseconds: 1600),
                                child: Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: Center(
                                    child: Text(
                                      "تسجيل دخول",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          FadeInUp(
                              duration: Duration(milliseconds: 1800),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color:
                                            Color.fromRGBO(143, 148, 251, 1)),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(143, 148, 251, .2),
                                          blurRadius: 20.0,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color.fromRGBO(
                                                      143, 148, 251, 1)))),
                                      child: TextField(
                                        controller: idController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "أسم المستخدم",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[700])),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "كلمة المرور",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[700])),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          // Text('Biometric authentication: $_authorized'),
                          // SizedBox(height: 20),
                          // _isAuthenticating
                          //     ? CircularProgressIndicator()
                          //     : ElevatedButton(
                          //         onPressed: _authenticate,
                          //         child: Text('Authenticate'),
                          //       ),
                          FadeInUp(
                              duration: Duration(milliseconds: 1900),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: InkWell(
                                      onTap: () {
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

                                        loginFunction();
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(83, 89, 219, 1),
                                              Color.fromRGBO(32, 39, 160, 0.6),
                                            ])),
                                        child: Center(
                                          child: Text(
                                            "تسجيل الدخول",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: InkWell(
                                    onTap: _authenticate,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(colors: [
                                            Color.fromRGBO(83, 89, 219, 1),
                                            Color.fromRGBO(32, 39, 160, 0.6),
                                          ])),
                                      child: Center(
                                          child: Image.asset(
                                        "assets/images/biometric.png",
                                        height: 40,
                                        width: 40,
                                        color: Colors.white,
                                      )),
                                    ),
                                  ))
                                ],
                              )),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
            Material(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "1.1.0+2",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
