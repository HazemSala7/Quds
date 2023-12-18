import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/orders_details/orders_details.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Services/AppBar/appbar_back.dart';
import '../../Services/Drawer/drawer.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  bool search = false;
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
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "الطلبيات",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25, left: 25, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: TextField(
                        onTap: setStart,
                        controller: start_date,
                        readOnly: true,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.center,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'من تاريخ',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Main_Color, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD6D3D3)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.center,
                        onTap: setEnd,
                        controller: end_date,
                        readOnly: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'الى تاريخ',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Main_Color, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD6D3D3)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "رقم الزبون",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "أسم الزبون",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "القيمه",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "ملاحظات",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "التاريخ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: start_date.text != "" ? filterOrders() : getOrders(),
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
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: Customers.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (Customers[index]["customer"].length == 0) {
                            return order_card(
                              customer: Customers[index]['customer_id'] ?? "",
                              customer_name: " - ",
                              value: Customers[index]['f_value'] ?? "",
                              notes: Customers[index]['notes'] ?? "",
                              fatora_id: Customers[index]['id'] ?? 1,
                              date: Customers[index]['f_date'] ?? "",
                            );
                          } else {
                            return order_card(
                              customer: Customers[index]['customer_id'] ?? "",
                              customer_name: Customers[index]['customer'][0]
                                      ['c_name'] ??
                                  "",
                              value: Customers[index]['f_value'] ?? "",
                              notes: Customers[index]['notes'] ?? "",
                              fatora_id: Customers[index]['id'] ?? 1,
                              date: Customers[index]['f_date'] ?? "",
                            );
                          }
                        },
                      ),
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

  TextEditingController start_date = TextEditingController();
  TextEditingController end_date = TextEditingController();
  setControllers() {
    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    String actualDate = formatterDate.format(now);
    setState(() {
      end_date.text = actualDate;
    });
  }

  @override
  void initState() {
    super.initState();
    setControllers();
  }

  setStart() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      // print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      // print(
      //     formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        start_date.text = formattedDate; //set output date to TextField value.
      });
    } else {
      // print("Date is not selected");
    }
  }

  setEnd() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      // print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      // print(
      //     formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        end_date.text = formattedDate; //set output date to TextField value.
      });
    } else {
      // print("Date is not selected");
    }
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
        'https://aliexpress.ps/quds_laravel/api/orders/$company_id/$salesman_id';
    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body);
    return res;
  }

  filterOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };
    var url =
        'https://aliexpress.ps/quds_laravel/api/filter_orders/$company_id/$salesman_id?start_date=${start_date.text}&end_date=${end_date.text}';
    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body);
    return res;
  }

  Widget order_card(
      {String date = "",
      String value = "",
      int fatora_id = 0,
      String customer = "",
      String customer_name = "",
      String notes = ""}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrdersDetails(
                        f_code: "1",
                        id: fatora_id,
                      )));
        },
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
              Expanded(flex: 1, child: Center(child: Text(customer))),
              Expanded(flex: 1, child: Center(child: Text(customer_name))),
              Expanded(flex: 1, child: Center(child: Text("₪$value"))),
              Expanded(flex: 1, child: Center(child: Text(notes))),
              Expanded(flex: 1, child: Center(child: Text(date))),
            ],
          ),
        ),
      ),
    );
  }
}
