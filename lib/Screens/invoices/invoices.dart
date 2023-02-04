import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/invoice/invoice_card/invoice_card.dart';
import 'package:flutter_application_1/Screens/total_receivables/total_card/total_card.dart';
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Server/server.dart';
import '../../Services/Drawer/drawer.dart';
import 'invoice_card/invoice_card.dart';

class Invoices extends StatefulWidget {
  const Invoices({Key? key}) : super(key: key);

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "الفواتير",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 30),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                "الرقم",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "الرصيد",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "أسم الزبون",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "رقم الهاتف",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: double.infinity,
                          height: 2,
                          color: Color(0xffD6D3D3),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                future: getOrders(),
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
                      var Customers = snapshot.data["orders"];
                      return ListView.builder(
                        itemCount: Customers.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return FatoraCard(
                            id: Customers[index]['id'] ?? 0,
                            balance: Customers[index]['customers']
                                    ['c_balance'] ??
                                "",
                            name:
                                Customers[index]['customers']['c_name'] ?? 0.0,
                            phone:
                                Customers[index]['customers']['phone1'] ?? "",
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
              ),
            ],
          ),
        ),
      )),
    );
  }

  getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };

    var url =
        'https://yaghco.website/quds_laravel/api/orders/${company_id.toString()}/${salesman_id.toString()}';
    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body);
    return res;
  }
}
