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
  const Customers({Key? key}) : super(key: key);

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  @override
  bool search = false;
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
                  controller: searchController,
                  onChanged: (_) {
                    if (searchController.text != "") {
                      setState(() {
                        search = true;
                      });
                    } else {
                      setState(() {
                        search = false;
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
                              color: Main_Color,
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
                              color: Main_Color,
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
                              color: Main_Color,
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
            search
                ? FutureBuilder(
                    future: searchFunction(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: SpinKitPulse(
                            color: Main_Color,
                            size: 60,
                          ),
                        );
                      } else {
                        if (snapshot.data != null) {
                          var Customers = snapshot.data["customers"];
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: Customers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CustomerCard(
                                index: index,
                                id: Customers[index]['id'] ?? 0,
                                name: Customers[index]['c_name'] ?? "",
                                price_code:
                                    Customers[index]['price_code'] ?? "",
                                phone: Customers[index]['phone1'] ?? " - ",
                              );
                            },
                          );
                        } else {
                          return Center(
                              child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator()));
                        }
                      }
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: AllCustomres.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CustomerCard(
                        index: index,
                        id: AllCustomres[index]['id'] ?? 0,
                        name: AllCustomres[index]['c_name'] ?? "",
                        price_code: AllCustomres[index]['price_code'] ?? "",
                        phone: AllCustomres[index]['phone1'] ?? " - ",
                      );
                    },
                  ),
            SizedBox(
              height: 30,
            )
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
    String? store_id_new = prefs.getString('store_id');
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

  TextEditingController searchController = TextEditingController();

  searchFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var url =
        'https://yaghco.website/quds_laravel/api/search/${searchController.text}/$company_id/$salesman_id';
    var response = await http.get(Uri.parse(url));
    var res = jsonDecode(response.body);
    return res;
  }
}
