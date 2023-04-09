import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/kashf_hesab/kashf_card/kashf_card.dart';
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../Server/server.dart';
import '../../Services/Drawer/drawer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class KashfHesab extends StatefulWidget {
  final customer_id;
  final name;
  const KashfHesab({Key? key, this.customer_id, this.name}) : super(key: key);

  @override
  State<KashfHesab> createState() => _KashfHesabState();
}

class _KashfHesabState extends State<KashfHesab> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  final customersBalances = [];

  getCustomerBalance(int index) {
    double sum = 0.0;
    for (var i = 0; i < index + 1; i++) {
      sum += double.parse(customersBalances[i]);
    }
    return sum;
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
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () async {
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // int? company_id = prefs.getInt('company_id');
                          // var headers = {
                          //   "contentType":
                          //       "application/x-www-form-urlencoded; charset=UTF-8",
                          // };
                          // var url =
                          //     'https://jerusalemaccounting.yaghco.website/kashf/test.php';
                          // var response = await http.post(Uri.parse(url),
                          //     body: {
                          //       "cust": widget.customer_id.toString(),
                          //       "comp": "5",
                          //     },
                          //     headers: headers);
                          // var data = response.body;
                          // return data.outerHtml;
                          // launch(
                          //     "https://jerusalemaccounting.yaghco.website/kashf/test.php?cust=${widget.customer_id.toString()}&comp=${company_id.toString()}");
                          var arabicFont = pw.Font.ttf(await rootBundle
                              .load("assets/fonts/Hacen_Tunisia.ttf"));
                          List<pw.Widget> widgets = [];
                          final title = pw.Column(
                            children: [
                              pw.Center(
                                child: pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                    "كشف حساب",
                                    style: pw.TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Directionality(
                                      textDirection: pw.TextDirection.rtl,
                                      child: pw.Text(widget.name.toString())),
                                  pw.Directionality(
                                      textDirection: pw.TextDirection.rtl,
                                      child: pw.Text("السيد : ")),
                                ],
                              ),
                              pw.SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                          widgets.add(title);
                          final firstrow = pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              pw.Directionality(
                                textDirection: pw.TextDirection.rtl,
                                child: pw.Expanded(
                                  flex: 1,
                                  child: pw.Center(
                                    child: pw.Text(
                                      "رقم السند",
                                      style: pw.TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              pw.Directionality(
                                textDirection: pw.TextDirection.rtl,
                                child: pw.Expanded(
                                  flex: 2,
                                  child: pw.Center(
                                    child: pw.Text(
                                      "التاريخ",
                                      style: pw.TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              pw.Directionality(
                                textDirection: pw.TextDirection.rtl,
                                child: pw.Expanded(
                                  flex: 3,
                                  child: pw.Center(
                                    child: pw.Text(
                                      "البيان",
                                      style: pw.TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              pw.Directionality(
                                textDirection: pw.TextDirection.rtl,
                                child: pw.Expanded(
                                  flex: 1,
                                  child: pw.Center(
                                    child: pw.Text(
                                      "له",
                                      style: pw.TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              pw.Directionality(
                                textDirection: pw.TextDirection.rtl,
                                child: pw.Expanded(
                                  flex: 1,
                                  child: pw.Center(
                                    child: pw.Text(
                                      "منه",
                                      style: pw.TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              pw.Directionality(
                                textDirection: pw.TextDirection.rtl,
                                child: pw.Expanded(
                                  flex: 1,
                                  child: pw.Center(
                                    child: pw.Text(
                                      "الرصيد",
                                      style: pw.TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                          widgets.add(firstrow);
                          final firstpadding = pw.Padding(
                            padding: pw.EdgeInsets.only(top: 10),
                            child: pw.Container(
                              width: double.infinity,
                              height: 2,
                              color: PdfColors.grey,
                            ),
                          );
                          widgets.add(firstpadding);
                          final listview = pw.ListView.builder(
                            itemCount: listPDF.length,
                            itemBuilder: (context, index) {
                              customersBalances.clear();
                              for (var customer in listPDF) {
                                customersBalances
                                    .add(customer['money_amount'].toString());
                              }
                              return listPDF[index]["action_type"] != "مبيعات"
                                  ? firstrowPDF(index)
                                  : pw.Column(children: [
                                      firstrowPDF(index),
                                      pw.Padding(
                                        padding:
                                            const pw.EdgeInsets.only(top: 15),
                                        child: pw.Container(
                                          height: 40,
                                          width: double.infinity,
                                          child: pw.Padding(
                                            padding: const pw.EdgeInsets.only(
                                              right: 10,
                                              left: 10,
                                            ),
                                            child: pw.Row(
                                              mainAxisAlignment: pw
                                                  .MainAxisAlignment
                                                  .spaceAround,
                                              children: [
                                                pw.Directionality(
                                                  textDirection:
                                                      pw.TextDirection.rtl,
                                                  child: pw.Expanded(
                                                      flex: 1,
                                                      child: pw.Container(
                                                        child: pw.Center(
                                                            child: pw.Text(
                                                          "المجموع الكلي",
                                                        )),
                                                      )),
                                                ),
                                                pw.Directionality(
                                                  textDirection:
                                                      pw.TextDirection.rtl,
                                                  child: pw.Expanded(
                                                      flex: 1,
                                                      child: pw.Container(
                                                        child: pw.Center(
                                                            child: pw.Text(
                                                          "السعر",
                                                        )),
                                                      )),
                                                ),
                                                pw.Directionality(
                                                  textDirection:
                                                      pw.TextDirection.rtl,
                                                  child: pw.Expanded(
                                                      flex: 1,
                                                      child: pw.Container(
                                                        child: pw.Center(
                                                            child: pw.Text(
                                                          "الكمية",
                                                        )),
                                                      )),
                                                ),
                                                pw.Directionality(
                                                  textDirection:
                                                      pw.TextDirection.rtl,
                                                  child: pw.Expanded(
                                                      flex: 2,
                                                      child: pw.Container(
                                                        child: pw.Center(
                                                            child: pw.Text(
                                                          "أسم الصنف",
                                                        )),
                                                      )),
                                                ),
                                                pw.Directionality(
                                                  textDirection:
                                                      pw.TextDirection.rtl,
                                                  child: pw.Expanded(
                                                      flex: 1,
                                                      child: pw.Container(
                                                        child: pw.Center(
                                                            child: pw.Text(
                                                          "رقم الصنف",
                                                        )),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.only(
                                            bottom: 15),
                                        child: pw.ListView.builder(
                                          itemCount:
                                              listPDF[index]["action"].length,
                                          itemBuilder: (context, i) {
                                            if (listPDF[index]["action"] ==
                                                "[]") {
                                              print("hre");
                                              return order_card(
                                                // product_id: Customers[index]['product_id'] ?? "-",
                                                product_name: "-",
                                                // Customers[index]['product']["p_name"] ?? "-",
                                                product_id: listPDF[index]
                                                            ["action"][i]
                                                        ['product_id'] ??
                                                    "-",
                                                qty: listPDF[index]["action"][i]
                                                        ['p_quantity'] ??
                                                    "-",
                                                price: listPDF[index]["action"]
                                                        [i]['p_price'] ??
                                                    "-",
                                                total: listPDF[index]["action"]
                                                        [i]['total'] ??
                                                    "-",
                                              );
                                            } else {
                                              print("object");
                                              return order_card(
                                                // product_id: Customers[index]['product_id'] ?? "-",
                                                product_name: listPDF[index]
                                                        ["action"][i]
                                                    ['product_name'],
                                                // Customers[index]['product']["p_name"] ?? "-",
                                                product_id: listPDF[index]
                                                            ["action"][i]
                                                        ['product_id'] ??
                                                    "-",
                                                qty: listPDF[index]["action"][i]
                                                        ['p_quantity'] ??
                                                    "-",
                                                price: listPDF[index]["action"]
                                                        [i]['p_price'] ??
                                                    "-",
                                                total: listPDF[index]["action"]
                                                        [i]['total'] ??
                                                    "-",
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ]);
                            },
                          );
                          widgets.add(listview);
                          final totals = pw.Column(
                            children: [
                              pw.SizedBox(
                                height: 20,
                              ),
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Directionality(
                                      textDirection: pw.TextDirection.rtl,
                                      child: pw.Text(total_mnh.toString(),
                                          style: pw.TextStyle(fontSize: 18))),
                                  pw.Directionality(
                                      textDirection: pw.TextDirection.rtl,
                                      child: pw.Text("الرصيد المدين : ",
                                          style: pw.TextStyle(fontSize: 18))),
                                ],
                              ),
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Directionality(
                                      textDirection: pw.TextDirection.rtl,
                                      child: pw.Text(total_lah.toString(),
                                          style: pw.TextStyle(fontSize: 18))),
                                  pw.Directionality(
                                      textDirection: pw.TextDirection.rtl,
                                      child: pw.Text("الرصيد الدائن : ",
                                          style: pw.TextStyle(fontSize: 18))),
                                ],
                              ),
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                children: [
                                  pw.Directionality(
                                      textDirection: pw.TextDirection.rtl,
                                      child: pw.Text("${total_mnh - total_lah}",
                                          style: pw.TextStyle(fontSize: 18))),
                                  pw.Directionality(
                                      textDirection: pw.TextDirection.rtl,
                                      child: pw.Text("المجموع النهائي : ",
                                          style: pw.TextStyle(fontSize: 18))),
                                ],
                              ),
                            ],
                          );
                          widgets.add(totals);
                          final pdf = pw.Document();
                          pdf.addPage(
                            pw.MultiPage(
                              theme: pw.ThemeData.withFont(
                                base: arabicFont,
                              ),
                              pageFormat: PdfPageFormat.a4,
                              build: (context) =>
                                  widgets, //here goes the widgets list
                            ),
                          );
                          Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async =>
                                pdf.save(),
                          );
                        },
                        child: Container(
                            height: 40,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Main_Color),
                            child: Center(
                                child: Text(
                              "PDF",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "كشف حساب",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
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
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Main_Color,
                                border: Border.all(color: Color(0xffD6D3D3))),
                            child: Center(
                              child: Text(
                                "الرصيد",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Main_Color,
                                border: Border.all(color: Color(0xffD6D3D3))),
                            child: Center(
                              child: Text(
                                "منه",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Main_Color,
                                border: Border.all(color: Color(0xffD6D3D3))),
                            child: Center(
                              child: Text(
                                "له",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Main_Color,
                                border: Border.all(color: Color(0xffD6D3D3))),
                            child: Center(
                              child: Text(
                                "البيان",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Main_Color,
                                border: Border.all(color: Color(0xffD6D3D3))),
                            child: Center(
                              child: Text(
                                "التاريخ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Main_Color,
                                border: Border.all(color: Color(0xffD6D3D3))),
                            child: Center(
                              child: Text(
                                "رقم السند",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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
              FutureBuilder(
                future: getCustomers(),
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
                      var Customers = snapshot.data["statments"];
                      customersBalances.clear();
                      for (var customer in Customers) {
                        customersBalances
                            .add(customer['money_amount'].toString());
                      }

                      return ListView.builder(
                        itemCount: Customers.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return KashfCard(
                            action_id: Customers[index]['action_id'] ?? "-",
                            balance: getCustomerBalance(index),
                            bayan: Customers[index]['action_type'] ?? "",
                            mnh: double.parse(Customers[index]['money_amount']
                                        .toString()) >
                                    0
                                ? Customers[index]['money_amount'].toString()
                                : "0",
                            lah: double.parse(Customers[index]['money_amount']
                                        .toString()) <
                                    0
                                ? double.parse(Customers[index]['money_amount']
                                        .toString()) *
                                    -1
                                : "0",
                            date: Customers[index]['action_date'] ?? "",
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
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      )),
    );
  }

  pw.Padding firstrowPDF(int index) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(right: 15, left: 15, top: 15),
      child: pw.Container(
        child: pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Center(
                      child: pw.Text(
                        "${listPDF[index]['action_id'] ?? "-"}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 2,
                    child: pw.Center(
                      child: pw.Text(
                        "${listPDF[index]['action_date'] ?? ""}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 3,
                    child: pw.Center(
                      child: pw.Text(
                        "${listPDF[index]['action_type'] ?? ""}",
                        style: pw.TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Center(
                      child: pw.Text(
                        "${double.parse(listPDF[index]['money_amount'].toString()) < 0 ? double.parse(listPDF[index]['money_amount'].toString()) * -1 : "0"}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Center(
                      child: pw.Text(
                        "${double.parse(listPDF[index]['money_amount'].toString()) > 0 ? listPDF[index]['money_amount'].toString() : "0"}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Center(
                      child: pw.Text(
                        "${getCustomerBalance(index)}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 10),
              child: pw.Container(
                width: double.infinity,
                height: 2,
                color: PdfColors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  getCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? company_id = prefs.getInt('company_id');

    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };

    var url =
        'https://yaghco.website/quds_laravel/api/statments/${company_id.toString()}/${widget.customer_id.toString()}';
    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body);
    return res;
  }

  var listPDF = [];
  List array_mnh = [];
  List action_type = [];
  double total_mnh = 0.0;

  List array_lah = [];
  double total_lah = 0.0;
  getCustome1rs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');

    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };

    var url =
        'https://yaghco.website/quds_laravel/api/statments/${company_id.toString()}/${widget.customer_id.toString()}';

    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body)["statments"];
    setState(() {
      listPDF = res;
    });

    for (int i = 0; i < listPDF.length; i++) {
      if (double.parse(listPDF[i]['money_amount'].toString()) > 0) {
        var money = listPDF[i]['money_amount'].toString();
        setState(() {
          array_mnh.add(money);
        });
      } else {
        var money = double.parse(listPDF[i]['money_amount'].toString()) * -1;
        setState(() {
          array_lah.add(money);
        });
      }
    }
    for (int i = 0; i < array_mnh.length; i++) {
      setState(() {
        total_mnh = total_mnh + double.parse(array_mnh[i].toString());
      });
    }
    for (int i = 0; i < array_lah.length; i++) {
      setState(() {
        total_lah = total_lah + double.parse(array_lah[i].toString());
      });
    }
  }

  // getProductsDetails(i) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? company_id = prefs.getInt('company_id');
  //   int? salesman_id = prefs.getInt('salesman_id');
  //   var url =
  //       'https://yaghco.website/quds_laravel/api/getkashfs/${listPDF[i]['action_id'].toString()}/$company_id/$salesman_id/2';
  //   print("url");
  //   print(url);
  //   var headers = {'ContentType': 'application/json'};
  //   var response = await http.get(Uri.parse(url), headers: headers);
  //   var res = jsonDecode(response.body);
  //   print("res");
  //   print(res);
  //   return res;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustome1rs();
  }

  pw.Container order_card(
      {String product_id = "",
      String product_name = "",
      String name = "",
      String qty = "",
      String price = "",
      String total = ""}) {
    return pw.Container(
      width: double.infinity,
      height: 40,
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(left: 10, right: 10),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            // Expanded(flex: 1, child: Center(child: Text(product_id))),

            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    child: pw.Center(
                        child: pw.Text(
                      "$total",
                    )),
                  )),
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    child: pw.Center(
                        child: pw.Text(
                      "$price",
                    )),
                  )),
            ),

            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    child: pw.Center(
                        child: pw.Text(
                      qty,
                    )),
                  )),
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    child: pw.Center(
                        child: pw.Text(
                      product_name,
                    )),
                  )),
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    child: pw.Center(
                        child: pw.Text(
                      product_id == "" ? "-" : product_id,
                    )),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
