import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Services/AppBar/appbar_back.dart';
import '../../Services/Drawer/drawer.dart';

class OrdersDetails extends StatefulWidget {
  final id, f_code;
  OrdersDetails({Key? key, this.id, required this.f_code}) : super(key: key);

  @override
  State<OrdersDetails> createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {
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
            child: AppBarBack(
              title: "تفاصيل الطلبية",
            ),
            preferredSize: Size.fromHeight(50)),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 7,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Expanded(
                    //     flex: 1,
                    //     child: Center(
                    //         child: Text(
                    //       "رقم الصنف",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ))),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "رقم الصنف",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "أسم الصنف",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "لون الصنف",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "الكمية",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "السعر",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "المجموع الكلي",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: widget.f_code == "1" ? getOrders() : getKashf(),
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
                    var Customers = snapshot.data["orders_details"];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: Customers.length,
                      itemBuilder: (BuildContext context, int index) {
                        var discount =
                            double.parse(Customers[index]['discount'] ?? 0.0);
                        var init_total = double.parse(
                                Customers[index]['p_quantity'].toString()) *
                            double.parse(
                                Customers[index]['p_price'].toString()) *
                            (1 - (discount / 100));

                        if (Customers[index]['product'] == null) {
                          return order_card(
                            // product_id: Customers[index]['product_id'] ?? "-",
                            product_name:
                                Customers[index]['product_name'] ?? "-",
                            color_name: Customers[index]['color_name'] ?? "-",
                            // Customers[index]['product']["p_name"] ?? "-",
                            product_id: Customers[index]['product_id'] ?? "-",
                            qty: Customers[index]['p_quantity'] ?? "-",
                            price: Customers[index]['p_price'] ?? "-",
                            total: init_total.toString(),
                          );
                        } else {
                          return order_card(
                            // product_id: Customers[index]['product_id'] ?? "-",
                            product_name:
                                Customers[index]['product']["p_name"] ?? "-",
                            // Customers[index]['product']["p_name"] ?? "-",
                            product_id: Customers[index]['product_id'] ?? "-",
                            qty: Customers[index]['p_quantity'] ?? "-",
                            price: Customers[index]['p_price'] ?? "-",
                            color_name: Customers[index]['color_name'] ?? "-",
                            total: init_total.toString(),
                          );
                        }
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
        )),
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
        'https://aliexpress.ps/quds_laravel/api/orderdetails/${widget.id.toString()}/$company_id/$salesman_id';
    print("url");
    print(url);
    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body);
    return res;
  }

  getKashf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };
    var url =
        'https://aliexpress.ps/quds_laravel/api/getkashfs/${widget.id.toString()}/$company_id/$salesman_id/2';
    var response = await http.get(Uri.parse(url), headers: headers);

    var res = jsonDecode(response.body);
    return res;
  }

  Widget order_card(
      {String product_id = "",
      String product_name = "",
      String color_name = "",
      String name = "",
      String qty = "",
      String price = "",
      String total = ""}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 7,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            // Expanded(flex: 1, child: Center(child: Text(product_id))),
            Expanded(flex: 1, child: Center(child: Text(product_id))),
            Expanded(flex: 1, child: Center(child: Text(product_name))),
            Expanded(
              flex: 1,
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF$color_name')),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Expanded(flex: 1, child: Center(child: Text(qty))),
            Expanded(flex: 1, child: Center(child: Text("₪$price"))),
            Expanded(flex: 1, child: Center(child: Text("₪$total"))),
          ],
        ),
      ),
    );
  }
}
