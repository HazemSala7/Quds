import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/kashf_hesab/kashf_card/kashf_card.dart';
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  pdfPrinter(bool withproduct) async {
    var arabicFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Hacen_Tunisia.ttf"));
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
          customersBalances.add(customer['money_amount'].toString());
        }
        return listPDF[index]["action_type"] != "مبيعات"
            ? firstrowPDF(index)
            : pw.Column(children: [
                firstrowPDF(index),
                withproduct
                    ? pw.Column(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 15),
                            child: pw.Container(
                              height: 40,
                              width: double.infinity,
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                ),
                                child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceAround,
                                  children: [
                                    pw.Directionality(
                                      textDirection: pw.TextDirection.rtl,
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
                                      textDirection: pw.TextDirection.rtl,
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
                                      textDirection: pw.TextDirection.rtl,
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
                                      textDirection: pw.TextDirection.rtl,
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
                                      textDirection: pw.TextDirection.rtl,
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
                          listPDF[index]["action"].length == 0
                              ? pw.Text(
                                  "لا يوجد منتجات",
                                )
                              : pw.Padding(
                                  padding: const pw.EdgeInsets.only(bottom: 15),
                                  child: pw.ListView.builder(
                                    itemCount:
                                        listPDF[index]["action"].length > 15
                                            ? 15
                                            : listPDF[index]["action"].length,
                                    itemBuilder: (context, i) {
                                      return order_card(
                                        product_name: listPDF[index]["action"]
                                                [i]['product_name'] ??
                                            "-",
                                        product_id: listPDF[index]["action"][i]
                                                ['product_id'] ??
                                            "-",
                                        qty: listPDF[index]["action"][i]
                                                ['p_quantity'] ??
                                            "-",
                                        price: listPDF[index]["action"][i]
                                                ['p_price'] ??
                                            "-",
                                        total: listPDF[index]["action"][i]
                                                ['total'] ??
                                            "-",
                                      );
                                    },
                                  ),
                                )
                        ],
                      )
                    : pw.Container()
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
        maxPages: 20,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context) => widgets, //here goes the widgets list
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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
        body: _isFirstLoadRunning
            ? Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                child: SpinKitPulse(
                  color: Main_Color,
                  size: 60,
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () async {
                              try {
                                pdfPrinter(true);
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg: "عدد المنتجات كبير جدا");
                              }
                            },
                            child: Container(
                                height: 40,
                                width: 130,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Main_Color),
                                child: Center(
                                    child: Text(
                                  "طباعه مع منتجات",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )))),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                            onTap: () async {
                              try {
                                pdfPrinter(false);
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg:
                                        "حدث خطأ ما , الرجاء المحاوله فيما بعد");
                              }
                            },
                            child: Container(
                                height: 40,
                                width: 130,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Main_Color),
                                child: Center(
                                    child: Text(
                                  "طباعه بدون منتجات",
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                    border:
                                        Border.all(color: Color(0xffD6D3D3))),
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
                                    border:
                                        Border.all(color: Color(0xffD6D3D3))),
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
                                    border:
                                        Border.all(color: Color(0xffD6D3D3))),
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
                                    border:
                                        Border.all(color: Color(0xffD6D3D3))),
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
                                    border:
                                        Border.all(color: Color(0xffD6D3D3))),
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
                                    border:
                                        Border.all(color: Color(0xffD6D3D3))),
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
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: listPDF.length,
                      itemBuilder: (context, index) {
                        for (var customer in listPDF) {
                          customersBalances
                              .add(customer['money_amount'].toString());
                        }
                        return KashfCard(
                          actions: listPDF[index]['action'] ?? [],
                          action_id: listPDF[index]['action_id'] ?? "-",
                          balance: getCustomerBalance(index),
                          bayan: listPDF[index]['action_type'] ?? "",
                          mnh: double.parse(listPDF[index]['money_amount']
                                      .toString()) >
                                  0
                              ? listPDF[index]['money_amount'].toString()
                              : "0",
                          lah: double.parse(listPDF[index]['money_amount']
                                      .toString()) <
                                  0
                              ? double.parse(listPDF[index]['money_amount']
                                      .toString()) *
                                  -1
                              : "0",
                          date: listPDF[index]['action_date'] ?? "",
                        );
                      },
                    ),
                  ),
                  // when the _loadMore function is running
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  // When nothing else to load
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 40),
                      color: Main_Color,
                      child: const Center(
                        child: Text('You have fetched all of the products'),
                      ),
                    ),
                ],
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


  var listPDF = [];
  List array_mnh = [];
  List action_type = [];
  double total_mnh = 0.0;

  List array_lah = [];
  double total_lah = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  // At the beginning, we fetch the first 20 posts
  int _page = 0;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    String? code_price = prefs.getString('price_code');
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var url =
          "https://yaghco.website/quds_laravel/api/statments/${company_id.toString()}/${widget.customer_id.toString()}?page=$_page";
      final res = await http.get(Uri.parse(url));
      setState(() {
        listPDF = json.decode(res.body)["statments"]["data"];
        for (int i = 0; i < listPDF.length; i++) {
          if (double.parse(listPDF[i]['money_amount'].toString()) > 0) {
            var money = listPDF[i]['money_amount'].toString();
            setState(() {
              array_mnh.add(money);
            });
          } else {
            var money =
                double.parse(listPDF[i]['money_amount'].toString()) * -1;
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
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    print("loaded");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    String? code_price = prefs.getString('price_code');
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1

      try {
        var url =
            "https://yaghco.website/quds_laravel/api/statments/${company_id.toString()}/${widget.customer_id.toString()}?page=$_page";

        final res = await http.get(Uri.parse(url));

        final List fetchedPosts = json.decode(res.body)["statments"]["data"];
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            listPDF.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  ScrollController? _controller;

  @override
  void dispose() {
    _controller?.removeListener(_loadMore);
    super.dispose();
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
