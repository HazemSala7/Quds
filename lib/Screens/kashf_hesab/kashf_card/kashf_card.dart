import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/orders_details/orders_details.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class KashfCard extends StatefulWidget {
  final mnh, lah, balance, bayan, date, action_id;
  var actions;

  KashfCard({
    Key? key,
    required this.action_id,
    this.mnh,
    this.lah,
    required this.date,
    required this.bayan,
    required this.balance,
    required this.actions,
  }) : super(key: key);

  @override
  State<KashfCard> createState() => _KashfCardState();
}

class _KashfCardState extends State<KashfCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffDFDFDF),
                        border: Border.all(color: Color(0xffD6D3D3))),
                    child: Center(
                      child: Text(
                        widget.balance.toString().length > 15
                            ? widget.balance.toString().substring(0, 15) + '...'
                            : widget.balance.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffD6D3D3))),
                    child: Center(
                      child: Text(
                        "${widget.mnh}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffDFDFDF),
                        border: Border.all(color: Color(0xffD6D3D3))),
                    child: Center(
                      child: Text(
                        "${widget.lah}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      widget.bayan == "مبيعات"
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrdersDetails(
                                        f_code: "2",
                                        id: widget.action_id,
                                      )))
                          : print("");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xffD6D3D3))),
                      child: Center(
                        child: Text(
                          "${widget.bayan}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffDFDFDF),
                        border: Border.all(color: Color(0xffD6D3D3))),
                    child: Center(
                      child: Text(
                        "${widget.date}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffD6D3D3))),
                    child: Center(
                      child: Text(
                        "${widget.action_id}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.bayan == "مبيعات" ? true : false,
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffD6D3D3))),
                          child: Center(
                              child: Text(
                            "رقم الصنف",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Main_Color),
                          )),
                        )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xffF8F8F8),
                              border: Border.all(color: Color(0xffD6D3D3))),
                          child: Center(
                              child: Text(
                            "أسم الصنف",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Main_Color),
                          )),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffD6D3D3))),
                          child: Center(
                              child: Text(
                            "الكمية",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Main_Color),
                          )),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xffF8F8F8),
                              border: Border.all(color: Color(0xffD6D3D3))),
                          child: Center(
                              child: Text(
                            "السعر",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Main_Color),
                          )),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffD6D3D3))),
                          child: Center(
                              child: Text(
                            "المجموع الكلي",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Main_Color),
                          )),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.bayan == "مبيعات" ? true : false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: widget.actions.length,
              itemBuilder: (BuildContext context, int index) {
                return order_card(
                  // product_id: Customers[index]['product_id'] ?? "-",
                  product_name: widget.actions[index]['product_name'] ?? "-",
                  // Customers[index]['product']["p_name"] ?? "-",
                  product_id: widget.actions[index]['product_id'] ?? "-",
                  qty: widget.actions[index]['p_quantity'] ?? "-",
                  price: widget.actions[index]['p_price'] ?? "-",
                  total: widget.actions[index]['total'] ?? "-",
                );
              },
            ),
          ),
        ),
      ],
    );
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
        'https://yaghco.website/quds_laravel/api/getkashfs/${widget.action_id.toString()}/$company_id/$salesman_id/2';
    print("|");
    print(url);
    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body);
    return res;
  }

  Widget order_card(
      {String product_id = "",
      String product_name = "",
      String name = "",
      String qty = "",
      String price = "",
      String total = ""}) {
    return Container(
      width: double.infinity,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            // Expanded(flex: 1, child: Center(child: Text(product_id))),
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffD6D3D3))),
                  child: Center(
                      child: Text(
                    product_id == "" ? "-" : product_id,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Main_Color),
                  )),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffF8F8F8),
                      border: Border.all(color: Color(0xffD6D3D3))),
                  child: Center(
                      child: Text(
                    product_name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Main_Color),
                  )),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffD6D3D3))),
                  child: Center(
                      child: Text(
                    qty,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Main_Color),
                  )),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffF8F8F8),
                      border: Border.all(color: Color(0xffD6D3D3))),
                  child: Center(
                      child: Text(
                    "₪$price",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Main_Color),
                  )),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffD6D3D3))),
                  child: Center(
                      child: Text(
                    "₪$total",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Main_Color),
                  )),
                )),
          ],
        ),
      ),
    );
  }
}
