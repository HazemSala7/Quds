import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
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

  pdfPrinter8CM(bool withproduct) async {
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
              style: pw.TextStyle(fontSize: 15),
            ),
          ),
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Text(widget.name.toString(),
                    style: pw.TextStyle(fontSize: 8))),
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
                style: pw.TextStyle(fontSize: 5),
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
                style: pw.TextStyle(fontSize: 5),
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
                style: pw.TextStyle(fontSize: 5),
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
                style: pw.TextStyle(fontSize: 5),
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
                style: pw.TextStyle(fontSize: 5),
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
                style: pw.TextStyle(fontSize: 5),
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
      itemCount: listPDFAll.length,
      itemBuilder: (context, index) {
        customersBalances.clear();
        for (var customer in listPDFAll) {
          customersBalances.add(customer['money_amount'].toString());
        }
        return listPDFAll[index]["action_type"] != "مبيعات"
            ? firstrowPDF(index, false)
            : pw.Column(children: [
                firstrowPDF(index, false),
                withproduct
                    ? pw.Column(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 15),
                            child: pw.Container(
                              height: 40,
                              width: double.infinity,
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
                                              child: pw.Text("المجموع الكلي",
                                                  style: pw.TextStyle(
                                                      fontSize: 4))),
                                        )),
                                  ),
                                  pw.Directionality(
                                    textDirection: pw.TextDirection.rtl,
                                    child: pw.Expanded(
                                        flex: 1,
                                        child: pw.Container(
                                          child: pw.Center(
                                              child: pw.Text("السعر",
                                                  style: pw.TextStyle(
                                                      fontSize: 4))),
                                        )),
                                  ),
                                  pw.Directionality(
                                    textDirection: pw.TextDirection.rtl,
                                    child: pw.Expanded(
                                        flex: 1,
                                        child: pw.Container(
                                          child: pw.Center(
                                              child: pw.Text("الكمية",
                                                  style: pw.TextStyle(
                                                      fontSize: 4))),
                                        )),
                                  ),
                                  pw.Directionality(
                                    textDirection: pw.TextDirection.rtl,
                                    child: pw.Expanded(
                                        flex: 3,
                                        child: pw.Container(
                                          child: pw.Center(
                                              child: pw.Text("أسم الصنف",
                                                  style: pw.TextStyle(
                                                      fontSize: 4))),
                                        )),
                                  ),
                                  pw.Directionality(
                                    textDirection: pw.TextDirection.rtl,
                                    child: pw.Expanded(
                                        flex: 1,
                                        child: pw.Container(
                                          child: pw.Center(
                                              child: pw.Text("رقم الصنف",
                                                  style: pw.TextStyle(
                                                      fontSize: 4))),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          listPDFAll[index]["action"].length == 0
                              ? pw.Text(
                                  "لا يوجد منتجات",
                                )
                              : pw.Padding(
                                  padding: const pw.EdgeInsets.only(bottom: 15),
                                  child: pw.ListView.builder(
                                    itemCount:
                                        listPDFAll[index]["action"].length > 15
                                            ? 15
                                            : listPDFAll[index]["action"]
                                                .length,
                                    itemBuilder: (context, i) {
                                      return order_card(
                                        fat8cm: true,
                                        product_name: listPDFAll[index]
                                                ["action"][i]['product_name'] ??
                                            "-",
                                        product_id: listPDFAll[index]["action"]
                                                [i]['product_id'] ??
                                            "-",
                                        qty: listPDFAll[index]["action"][i]
                                                ['p_quantity'] ??
                                            "-",
                                        price: listPDFAll[index]["action"][i]
                                                ['p_price'] ??
                                            "-",
                                        total: listPDFAll[index]["action"][i]
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
                    style: pw.TextStyle(fontSize: 12))),
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Text("الرصيد المدين : ",
                    style: pw.TextStyle(fontSize: 12))),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Text(total_lah.toString(),
                    style: pw.TextStyle(fontSize: 12))),
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Text("الرصيد الدائن : ",
                    style: pw.TextStyle(fontSize: 12))),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Text("${LastBalanceValue}",
                    style: pw.TextStyle(fontSize: 12))),
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Text("المجموع النهائي : ",
                    style: pw.TextStyle(fontSize: 12))),
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
        pageFormat: PdfPageFormat(
          4 * PdfPageFormat.cm,
          20 * PdfPageFormat.cm,
        ),
        build: (context) => widgets, //here goes the widgets list
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> pdfPrinterA4(bool withproduct) async {
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
                child: pw.Text(widget.name.toString(),
                    style: pw.TextStyle(fontSize: 15))),
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
    final itemsPerPage = 20;
    for (int i = 0; i < listPDFAll.length; i++) {
      List<pw.Widget> currentPageWidgets = [];
      customersBalances.clear();
      for (var customer in listPDFAll) {
        customersBalances.add(customer['money_amount'].toString());
      }
      currentPageWidgets.add(listPDFAll[i]["action_type"] != "مبيعات"
          ? firstrowPDF(i, true)
          : pw.Column(children: [
              firstrowPDF(i, true),
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
                        listPDFAll[i]["action"].length == 0
                            ? pw.Text(
                                "لا يوجد منتجات",
                              )
                            : pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 15),
                                child: pw.ListView.builder(
                                  itemCount: listPDFAll[i]["action"].length >
                                          itemsPerPage
                                      ? itemsPerPage
                                      : listPDFAll[i]["action"].length,
                                  itemBuilder: (context, j) {
                                    return order_card(
                                      fat8cm: false,
                                      product_name: listPDFAll[i]["action"][j]
                                              ['product_name'] ??
                                          "-",
                                      product_id: listPDFAll[i]["action"][j]
                                              ['product_id'] ??
                                          "-",
                                      qty: listPDFAll[i]["action"][j]
                                              ['p_quantity'] ??
                                          "-",
                                      price: listPDFAll[i]["action"][j]
                                              ['p_price'] ??
                                          "-",
                                      total: listPDFAll[i]["action"][j]
                                              ['total'] ??
                                          "-",
                                    );
                                  },
                                ),
                              )
                      ],
                    )
                  : pw.Container()
            ]));
      widgets.addAll(currentPageWidgets);
    }
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
                child: pw.Text("${LastBalanceValue}",
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

  setStart() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        start_date.text = formattedDate;
      });
      if (start_date.text != "") {
        _pageFilter = 1;
        filterStatmentsFirstCall();
      } else {
        _page = 1;
        _firstLoad();
      }
    } else {
      // print("Date is not selected");
    }
  }

  setEnd() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        end_date.text = formattedDate;
      });
      if (end_date.text != "") {
        filterStatmentsFirstCall();
      } else {
        _firstLoad();
      }
    } else {
      // print("Date is not selected");
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
            child: AppBarBack(
              title: "كشف حساب",
            ),
            preferredSize: Size.fromHeight(50)),
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator())),
                                    );
                                  },
                                );
                                getAllStatments(true);
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator())),
                                    );
                                  },
                                );
                                getAllStatments(false);
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
                    padding:
                        const EdgeInsets.only(right: 25, left: 25, top: 15),
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
                    padding: const EdgeInsets.only(top: 20),
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
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(83, 89, 219, 1),
                                      Color.fromRGBO(32, 39, 160, 0.6),
                                    ]),
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
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(83, 89, 219, 1),
                                      Color.fromRGBO(32, 39, 160, 0.6),
                                    ]),
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
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(83, 89, 219, 1),
                                      Color.fromRGBO(32, 39, 160, 0.6),
                                    ]),
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
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(83, 89, 219, 1),
                                      Color.fromRGBO(32, 39, 160, 0.6),
                                    ]),
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
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(83, 89, 219, 1),
                                      Color.fromRGBO(32, 39, 160, 0.6),
                                    ]),
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
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(83, 89, 219, 1),
                                      Color.fromRGBO(32, 39, 160, 0.6),
                                    ]),
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
                        customersBalances.clear();
                        for (var customer in listPDF) {
                          customersBalances
                              .add(customer['money_amount'].toString());
                        }
                        return KashfCard(
                          actions: listPDF[index]['action'] ?? [],
                          action_id: listPDF[index]['action_id'] ?? "-",
                          balance: listPDF[index]['balance'].toString(),
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
                ],
              ),
      )),
    );
  }

  pw.Padding firstrowPDF(int index, bool A4) {
    return pw.Padding(
      padding: A4
          ? pw.EdgeInsets.only(right: 15, left: 15, top: 15)
          : pw.EdgeInsets.only(top: 15),
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
                        "${listPDFAll[index]['action_id'] ?? "-"}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: A4 ? 14 : 5),
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
                        "${listPDFAll[index]['action_date'] ?? ""}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: A4 ? 14 : 5),
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
                        "${listPDFAll[index]['action_type'] ?? ""}",
                        style: pw.TextStyle(fontSize: A4 ? 14 : 5),
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
                        "${double.parse(listPDFAll[index]['money_amount'].toString()) < 0 ? double.parse(listPDFAll[index]['money_amount'].toString()) * -1 : "0"}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: A4 ? 14 : 5),
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
                        "${double.parse(listPDFAll[index]['money_amount'].toString()) > 0 ? listPDFAll[index]['money_amount'].toString() : "0"}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: A4 ? 14 : 5),
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
                        "${listPDFAll[index]['balance'].toString()}",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: A4 ? 14 : 5),
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

  var listPDFAll = [];
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
    setControllers();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  // At the beginning, we fetch the first 20 posts
  int _page = 1;
  int _pageFilter = 1;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  filterStatmentsFirstCall() async {
    setState(() {
      _isFirstLoadRunning = true;
      listPDF = [];
      listPDFAll = [];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };
    var url =
        'https://aliexpress.ps/quds_laravel/api/filter_statments/$company_id/$salesman_id/${widget.customer_id.toString()}/${start_date.text}/${end_date.text}/${order_kashf_from_new_to_old ? "desc" : "asc"}?page=$_pageFilter';
    print("url");
    print(url);
    var response = await http.get(Uri.parse(url), headers: headers);
    try {
      setState(() {
        listPDF = json.decode(response.body)["statments"]["data"];
        listPDFAll = json.decode(response.body)["statments"]["data"];
        _isFirstLoadRunning = false;
      });
    } catch (e) {
      setState(() {
        var responseData = json.decode(response.body);
        if (responseData.containsKey("statments")) {
          listPDF = responseData["statments"]["data"];
          listPDFAll = responseData["statments"]["data"];
        } else if (responseData.containsKey("statement")) {
          listPDF = [responseData["statement"]];
          listPDFAll = [responseData["statement"]];
        }
        _isFirstLoadRunning = false;
      });
    }
  }

  filterStatmentsSecondCall() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 300) {
      print("10");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      int? company_id = prefs.getInt('company_id');
      int? salesman_id = prefs.getInt('salesman_id');
      var headers = {
        'Authorization': 'Bearer $token',
        'ContentType': 'application/json'
      };
      setState(() {
        _isLoadMoreRunning = true;
      });
      _pageFilter += 1;
      var url =
          'https://aliexpress.ps/quds_laravel/api/filter_statments/$company_id/$salesman_id/${widget.customer_id.toString()}/${start_date.text}/${end_date.text}/${order_kashf_from_new_to_old ? "desc" : "asc"}?page=$_pageFilter';
      print("url");
      print(url);
      var response = await http.get(Uri.parse(url), headers: headers);
      final List fetchedPosts = json.decode(response.body)["statments"]["data"];
      if (fetchedPosts.isNotEmpty) {
        // Filter out duplicates based on unique identifiers
        final uniqueFetchedPosts = fetchedPosts
            .where((newPost) => !listPDF
                .any((existingPost) => newPost['id'] == existingPost['id']))
            .toList();

        setState(() {
          listPDF.addAll(uniqueFetchedPosts);
        });
      } else {
        Fluttertoast.showToast(msg: "نهاية الكشف");
        Timer(Duration(milliseconds: 300), () {
          Fluttertoast.cancel();
        });
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  var LastBalanceValue;

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
          "https://aliexpress.ps/quds_laravel/api/statments/${company_id.toString()}/${widget.customer_id.toString()}/${order_kashf_from_new_to_old ? "desc" : "asc"}?page=$_page";
      final res = await http.get(Uri.parse(url));
      setState(() {
        listPDF = json.decode(res.body)["statments"]["data"];
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

  getAllStatments(bool? withPro) async {
    setState(() {
      total_lah = 0.0;
      total_mnh = 0.0;
      listPDFAll.clear();
      array_mnh.clear();
      array_lah.clear();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    String? code_price = prefs.getString('price_code');
    try {
      if (start_date.text == "" || end_date.text == "") {
        var url =
            "https://aliexpress.ps/quds_laravel/api/all_statments/${company_id.toString()}/${widget.customer_id.toString()}/${order_kashf_from_new_to_old ? "desc" : "asc"}?page=$_page";

        final res = await http.get(Uri.parse(url));
        setState(() {
          listPDFAll = json.decode(res.body)["statments"];
          for (int i = 0; i < listPDFAll.length; i++) {
            if (double.parse(listPDFAll[i]['money_amount'].toString()) > 0) {
              var money = listPDFAll[i]['money_amount'].toString();

              array_mnh.add(money);
            } else {
              var money =
                  double.parse(listPDFAll[i]['money_amount'].toString()) * -1;

              array_lah.add(money);
            }
          }
          for (int i = 0; i < array_mnh.length; i++) {
            total_mnh = total_mnh + double.parse(array_mnh[i].toString());
          }
          for (int i = 0; i < array_lah.length; i++) {
            total_lah = total_lah + double.parse(array_lah[i].toString());
          }
          var lastBalanceASC =
              listPDFAll.isNotEmpty ? listPDFAll.last['balance'] : null;
          var lastBalanceDESC =
              listPDFAll.isNotEmpty ? listPDFAll.first['balance'] : null;

          LastBalanceValue =
              order_kashf_from_new_to_old ? lastBalanceDESC : lastBalanceASC;
        });
      } else {
        var url =
            "https://aliexpress.ps/quds_laravel/api/get_all_filter_statments/$company_id/$salesman_id/${widget.customer_id.toString()}/${start_date.text}/${end_date.text}/${order_kashf_from_new_to_old ? "desc" : "asc"}";
        final res = await http.get(Uri.parse(url));
        setState(() {
          listPDFAll = json.decode(res.body)["statments"];
          for (int i = 0; i < listPDFAll.length; i++) {
            if (double.parse(listPDFAll[i]['money_amount'].toString()) > 0) {
              var money = listPDFAll[i]['money_amount'].toString();

              array_mnh.add(money);
            } else {
              var money =
                  double.parse(listPDFAll[i]['money_amount'].toString()) * -1;

              array_lah.add(money);
            }
          }
          for (int i = 0; i < array_mnh.length; i++) {
            total_mnh = total_mnh + double.parse(array_mnh[i].toString());
          }
          for (int i = 0; i < array_lah.length; i++) {
            total_lah = total_lah + double.parse(array_lah[i].toString());
          }
          var lastBalance =
              listPDFAll.isNotEmpty ? listPDFAll.last['balance'] : null;

          LastBalanceValue = lastBalance;
        });
      }

      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                              height: 100,
                              width: 100,
                              child:
                                  Center(child: CircularProgressIndicator())),
                        );
                      },
                    );
                    pdfPrinter8CM(withPro!);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Main_Color,
                    ),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "طباعه 8سم",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                              height: 100,
                              width: 100,
                              child:
                                  Center(child: CircularProgressIndicator())),
                        );
                      },
                    );
                    pdfPrinterA4(withPro!);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Main_Color,
                    ),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "طباعة A4",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Main_Color,
                    ),
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "لا أريد",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (err) {
      if (kDebugMode) {
        Navigator.of(context, rootNavigator: true).pop();
        print('Something went wrong , $err');
      }
    }
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (start_date.text != "") {
      filterStatmentsSecondCall();
    } else {
      print("1");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? company_id = prefs.getInt('company_id');
      int? salesman_id = prefs.getInt('salesman_id');
      String? code_price = prefs.getString('price_code');
      if (_hasNextPage == true &&
          _isFirstLoadRunning == false &&
          _isLoadMoreRunning == false &&
          _controller!.position.extentAfter < 300) {
        setState(() {
          _isLoadMoreRunning =
              true; // Display a progress indicator at the bottom
        });
        _page += 1; // Increase _page by 1

        try {
          var url =
              "https://aliexpress.ps/quds_laravel/api/statments/${company_id.toString()}/${widget.customer_id.toString()}/${order_kashf_from_new_to_old ? "desc" : "asc"}?page=$_page";

          final res = await http.get(Uri.parse(url));

          final List fetchedPosts = json.decode(res.body)["statments"]["data"];
          if (fetchedPosts.isNotEmpty) {
            // Filter out duplicates based on unique identifiers
            final uniqueFetchedPosts = fetchedPosts
                .where((newPost) => !listPDF
                    .any((existingPost) => newPost['id'] == existingPost['id']))
                .toList();

            setState(() {
              listPDF.addAll(uniqueFetchedPosts);
            });
          } else {
            Fluttertoast.showToast(msg: "نهاية الكشف");
            Timer(Duration(milliseconds: 300), () {
              Fluttertoast.cancel();
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
  }

  ScrollController? _controller;
  // ScrollController? _controllerFilterStatments;

  @override
  void dispose() {
    _controller?.removeListener(_loadMore);

    super.dispose();
  }

  pw.Container order_card(
      {String product_id = "",
      String product_name = "",
      bool fat8cm = false,
      String name = "",
      String qty = "",
      String price = "",
      String total = ""}) {
    return pw.Container(
      width: double.infinity,
      height: 15,
      child: pw.Padding(
        padding:
            pw.EdgeInsets.only(left: fat8cm ? 0 : 10, right: fat8cm ? 0 : 10),
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
                        child: pw.Text("$total",
                            style: pw.TextStyle(fontSize: fat8cm ? 4 : 8))),
                  )),
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    child: pw.Center(
                        child: pw.Text("$price",
                            style: pw.TextStyle(fontSize: fat8cm ? 4 : 8))),
                  )),
            ),

            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    child: pw.Center(
                        child: pw.Text(qty,
                            style: pw.TextStyle(fontSize: fat8cm ? 4 : 8))),
                  )),
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                    child: pw.Center(
                        child: pw.Text(
                            product_name.length > 20
                                ? product_name.substring(0, 20) + '...'
                                : product_name,
                            style: pw.TextStyle(fontSize: fat8cm ? 4 : 8))),
                  )),
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    child: pw.Center(
                        child: pw.Text(product_id == "" ? "-" : product_id,
                            style: pw.TextStyle(fontSize: fat8cm ? 4 : 8))),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
