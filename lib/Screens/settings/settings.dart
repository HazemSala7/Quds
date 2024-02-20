import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/settings/settings_card/setting_Card.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/AppBar/appbar_back.dart';
import '../../Services/Drawer/drawer.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setSettings();
  }

  setSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? store_id_order = prefs.getString('store_id');
    String? store_name = prefs.getString('store_name');
    if (store_id_order.toString() == "null") {
      idController.text = "1";
      await prefs.setString('store_id', idController.text);
    } else {
      setState(() {
        idController.text = store_id_order.toString();
      });
    }
    if (store_name.toString() == "null") {
      nameController.text = "";
      await prefs.setString('store_name', nameController.text);
    } else {
      setState(() {
        nameController.text = store_name.toString();
      });
    }
  }

  Widget build(BuildContext context) {
    return Container(
      color: Main_Color,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldState,
          drawer: DrawerMain(),
          appBar: PreferredSize(
              child: AppBarBack(), preferredSize: Size.fromHeight(50)),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Visibility(
                visible: JUST,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, right: 15, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "رقم المخزن",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: JUST,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: TextField(
                      controller: idController,
                      obscureText: false,
                      onChanged: (_) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('store_id', idController.text);
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Color(0xff34568B), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                        ),
                        hintText: "رقم المخزن",
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: JUST,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, right: 15, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "أسم الشركه",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: JUST,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: TextField(
                      controller: nameController,
                      obscureText: false,
                      onChanged: (_) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString(
                            'store_name', nameController.text);
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Color(0xff34568B), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                        ),
                        hintText: "أسم الشركه",
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 25, left: 25),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 7,
                            blurRadius: 5,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Visibility(
                          visible: JUST,
                          child: Column(
                            children: [
                              SettingsCard(
                                status: ponus1,
                                Status: () async {
                                  setState(() {
                                    ponus1 = !ponus1;
                                  });
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('ponus1', ponus1);
                                },
                                name: "اظهار بونص 1",
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              SettingsCard(
                                status: ponus2,
                                name: "اظهار بونص 2",
                                Status: () async {
                                  setState(() {
                                    ponus2 = !ponus2;
                                  });
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('ponus2', ponus2);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              SettingsCard(
                                status: discount,
                                Status: () async {
                                  setState(() {
                                    discount = !discount;
                                  });
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('discount', discount);
                                },
                                name: "اظهار الخصم",
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              SettingsCard(
                                status: notes,
                                Status: () async {
                                  setState(() {
                                    notes = !notes;
                                  });
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('notes', notes);
                                },
                                name: "اظهار الملاحظات",
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              SettingsCard(
                                status: existed_qty,
                                Status: () async {
                                  setState(() {
                                    existed_qty = !existed_qty;
                                  });
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool(
                                      'existed_qty', existed_qty);
                                },
                                name: "اظهار الكميه الموجوده",
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SettingsCard(
                          status: order_kashf_from_new_to_old,
                          Status: () async {
                            setState(() {
                              order_kashf_from_new_to_old =
                                  !order_kashf_from_new_to_old;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('order_kashf_from_new_to_old',
                                order_kashf_from_new_to_old);
                          },
                          name: "ترتيب كشف الحساب من الأحدث الى الأقدم",
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Visibility(
                          visible: JUST,
                          child: Column(
                            children: [
                              SettingsCard(
                                status: desc,
                                Status: () async {
                                  setState(() {
                                    desc = !desc;
                                  });
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('desc', desc);
                                },
                                name: "اظهار الوصف",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
