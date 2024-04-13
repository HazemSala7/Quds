import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/customers/customer_card/customer_card.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_application_1/Services/AppBar/appbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/Drawer/drawer.dart';

class Customers extends StatefulWidget {
  List CustomersArray;
  Customers({
    Key? key,
    required this.CustomersArray,
  }) : super(key: key);

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  @override
  bool search = false;
  var filteredCustomers = [];
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  Widget build(BuildContext context) {
    return Container(
      color: Main_Color,
      child: SafeArea(
          child: Scaffold(
        key: _scaffoldState,
        drawer: DrawerMain(),
        appBar: PreferredSize(
            child: AppBarMain(), preferredSize: Size.fromHeight(50)),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 25),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  onChanged: (searchInput) {
                    if (searchInput.isEmpty) {
                      setState(() {
                        filteredCustomers = widget.CustomersArray;
                      });
                    } else {
                      setState(() {
                        filteredCustomers = widget.CustomersArray;
                        filteredCustomers = filteredCustomers
                            .where((customer) =>
                                customer['c_name']
                                    .toLowerCase()
                                    .contains(searchInput.toLowerCase()) ||
                                customer['c_name'].contains(searchInput))
                            .toList();
                      });
                    }
                  },
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'بحث عن أسم الزبون',
                    hintStyle:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Main_Color, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                height: 40,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(83, 89, 219, 1),
                                Color.fromRGBO(32, 39, 160, 0.6),
                              ]),
                              border: Border.all(color: Colors.white)),
                          child: Center(
                            child: Text(
                              "الرقم",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(83, 89, 219, 1),
                                Color.fromRGBO(32, 39, 160, 0.6),
                              ]),
                              border: Border.all(color: Colors.white)),
                          child: Center(
                            child: Text(
                              "أسم الزبون",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(83, 89, 219, 1),
                                Color.fromRGBO(32, 39, 160, 0.6),
                              ]),
                              border: Border.all(color: Colors.white)),
                          child: Center(
                            child: Text(
                              "رقم الهاتف",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: filteredCustomers.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomerCard(
                  index: index,
                  id: filteredCustomers[index]['id'] ?? 0,
                  name: filteredCustomers[index]['c_name'] ?? "",
                  balance: filteredCustomers[index]['c_balance'].toString(),
                  price_code: filteredCustomers[index]['price_code'] ?? "",
                  phone: filteredCustomers[index]['phone1'] ?? " - ",
                );
              },
            ),
          ],
        )),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    setsettings();
  }

  setsettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? test_ponus1 = prefs.getBool('ponus1');
    bool? test_desc = prefs.getBool('desc');
    bool? test_ponus2 = prefs.getBool('ponus2');
    bool? test_discount = prefs.getBool('discount');
    // bool? test_notes = prefs.getBool('notes');
    bool? test_existed_qty = prefs.getBool('existed_qty');
    bool? _order_kashf_from_new_to_old =
        prefs.getBool('order_kashf_from_new_to_old');
    String? store_id_new = prefs.getString('store_id');
    filteredCustomers = widget.CustomersArray;
    if (store_id_new == null) {
      setState(() {
        store_id = "";
      });
    } else {
      setState(() {
        store_id = store_id_new;
      });
    }

    if (test_ponus1 == true) {
      setState(() {
        ponus1 = true;
      });
    } else {
      setState(() {
        ponus1 = false;
      });
    }
    if (_order_kashf_from_new_to_old == true) {
      setState(() {
        order_kashf_from_new_to_old = true;
      });
    } else {
      setState(() {
        order_kashf_from_new_to_old = false;
      });
    }
    if (test_desc == true) {
      setState(() {
        desc = true;
      });
    } else {
      setState(() {
        desc = false;
      });
    }
    if (test_ponus2 == true) {
      setState(() {
        ponus2 = true;
      });
    } else {
      setState(() {
        ponus2 = false;
      });
    }
    if (test_discount == true) {
      setState(() {
        discount = true;
      });
    } else {
      setState(() {
        discount = false;
      });
    }
    // if (test_notes == true) {
    //   setState(() {
    //     notes = true;
    //   });
    // } else {
    //   setState(() {
    //     notes = false;
    //   });
    // }
    if (test_existed_qty == true) {
      setState(() {
        existed_qty = true;
      });
    } else {
      setState(() {
        existed_qty = false;
      });
    }
  }
}
