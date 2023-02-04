import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/show_order/order_card/order_card.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/Drawer/drawer.dart';
import '../add_order/add_order.dart';

class ShowOrder extends StatefulWidget {
  final id, name;
  const ShowOrder({Key? key, this.id, this.name}) : super(key: key);

  @override
  State<ShowOrder> createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrder> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  Widget build(BuildContext context) {
    return Container(
      color: Main_Color,
      child: SafeArea(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Scaffold(
            key: _scaffoldState,
            drawer: DrawerMain(),
            appBar: PreferredSize(
                child: AppBarBack(), preferredSize: Size.fromHeight(50)),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 15, left: 15, top: 15, bottom: 15),
                    child: Row(
                      children: [
                        Text(
                          "أسم الزبون : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Main_Color),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: getInvoices(),
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
                          var Incoices = snapshot.data["invoiceproducts"];
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: Incoices.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (Incoices[index]["product"] != null) {
                                return OrderCard(
                                  ponus_one: Incoices[index]['bonus1'] ?? " - ",
                                  notes: Incoices[index]['notes'] ?? " - ",
                                  product_id:
                                      Incoices[index]['product_id'] ?? " - ",
                                  id: Incoices[index]['id'] ?? 0,
                                  invoice_id: Incoices[index]['fatora_id'] ?? 0,
                                  ponus_two: Incoices[index]['bonus2'] ?? " - ",
                                  discount:
                                      Incoices[index]['discount'] ?? " - ",
                                  total: Incoices[index]['total'] ?? " - ",
                                  price: Incoices[index]['p_price'] ?? " - ",
                                  name: Incoices[index]['product']['p_name'] ??
                                      " - ",
                                  qty: Incoices[index]['p_quantity'] ?? " - ",
                                  removeProduct: () {
                                    removeProduct(Incoices[index]['id']);

                                    setState(() {});
                                  },
                                  image: Incoices[index]['product']['images'] ??
                                      " - ",
                                );
                              } else {
                                return OrderCard(
                                  notes: Incoices[index]['notes'] ?? " - ",
                                  product_id:
                                      Incoices[index]['product_id'] ?? " - ",
                                  invoice_id: Incoices[index]['fatora_id'] ?? 0,
                                  id: Incoices[index]['id'] ?? 0,
                                  ponus_one: Incoices[index]['bonus1'] ?? " - ",
                                  ponus_two: Incoices[index]['bonus2'] ?? " - ",
                                  removeProduct: () {
                                    removeProduct(Incoices[index]['id']);

                                    setState(() {});
                                  },
                                  discount:
                                      Incoices[index]['discount'] ?? " - ",
                                  total: Incoices[index]['total'] ?? " - ",
                                  price: Incoices[index]['p_price'] ?? " - ",
                                  name: "-",
                                  qty: Incoices[index]['p_quantity'] ?? " - ",
                                  image: "",
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
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: getInvoices(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return BottomContainer(total: 0, fatora_id: "0");
              } else {
                if (snapshot.data != null) {
                  if (snapshot.data["invoiceproducts"].length == 0) {
                    return BottomContainer(total: 0, fatora_id: "0");
                  } else {
                    var tot = snapshot.data["total"];
                    var fatora_id =
                        snapshot.data["invoiceproducts"][0]["fatora_id"] ?? "0";
                    return BottomContainer(total: tot, fatora_id: fatora_id);
                  }
                } else {
                  return BottomContainer(total: 0);
                }
              }
            },
          ),
        ],
      )),
    );
  }

  removeProduct(id) async {
    var url = 'https://yaghco.website/quds_laravel/api/remove_fatora';
    var response = await http.post(Uri.parse(url), body: {"id": id.toString()});
    var data = jsonDecode(response.body);

    if (data['status'] == 'true') {
      Fluttertoast.showToast(msg: "تم حذف المنتج بنجاح");
    } else {
      Fluttertoast.showToast(msg: "حصل خطأ في عمليه الحذف");
    }
  }

  Widget BottomContainer({var total, var fatora_id}) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "المجموع : ",
                  style: GoogleFonts.cairo(
                      fontSize: 17,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                ),
                Text(
                  "₪$total",
                  style: GoogleFonts.cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Main_Color,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddOrder(
                                total: total.toString(),
                                id: widget.id,
                                fatora_id: fatora_id,
                              )));
                },
                child: Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Main_Color),
                  child: Center(
                    child: Text(
                      "حفظ الطلبيه",
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getInvoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var url =
        'https://yaghco.website/quds_laravel/api/invoiceproducts/${company_id.toString()}/${salesman_id.toString()}';
    print("url");
    print(url);
    var response = await http.get(Uri.parse(url));
    var res = jsonDecode(response.body);
    return res;
  }
}
