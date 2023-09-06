import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/catches/catch_card/catch_card.dart';
import 'package:flutter_application_1/Screens/total_receivables/total_card/total_card.dart';
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Server/server.dart';
import '../../Services/Drawer/drawer.dart';

class Catches extends StatefulWidget {
  const Catches({Key? key}) : super(key: key);

  @override
  State<Catches> createState() => _CatchesState();
}

class _CatchesState extends State<Catches> {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                        child: CircularProgressIndicator())),
                              );
                            },
                          );
                          pdfFatora8CM();
                        },
                        child: Container(
                            height: 40,
                            width: 130,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Main_Color),
                            child: Center(
                                child: Text(
                              "طباعه PDF",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )))),
                  ],
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
                padding: const EdgeInsets.only(top: 40),
                child: Container(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
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
                                "#الزبون",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Main_Color,
                                border: Border.all(color: Color(0xffD6D3D3))),
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
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Main_Color,
                                border: Border.all(color: Color(0xffD6D3D3))),
                            child: Center(
                              child: Text(
                                "المبلغ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Main_Color,
                                border: Border.all(color: Colors.white)),
                            child: Center(
                              child: Text(
                                "التاريخ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Main_Color,
                                border: Border.all(color: Colors.white)),
                            child: Center(
                              child: Text(
                                "ملاحظات",
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
              FutureBuilder(
                future: start_date.text != "" ? filterQabds() : getQabds(),
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
                      var Customers = snapshot.data["qabds"];
                      return ListView.builder(
                        itemCount: Customers.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CatchCard(
                            id: Customers[index]['customer_id'] ?? "0",
                            balance: double.parse(Customers[index]['chks']) +
                                double.parse(Customers[index]['cash']) +
                                double.parse(Customers[index]['discount']),
                            name: Customers[index]['customer'] == "-"
                                ? "-"
                                : Customers[index]['customer']["c_name"],
                            phone: Customers[index]['q_date'] ?? "",
                            notes: Customers[index]['notes'] ?? "",
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
    setQabds();
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

  bool fun = false;
  TextEditingController searchController = TextEditingController();
  filterQabds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };
    var url =
        'https://yaghco.website/quds_laravel/api/filter_qabds/$company_id/$salesman_id?start_date=${start_date.text}&end_date=${end_date.text}';
    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body);
    return res;
  }

  var Qadbs;

  getQabds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };
    var url =
        'https://yaghco.website/quds_laravel/api/qabds/${company_id.toString()}/${salesman_id.toString()}';
    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body);
    return res;
  }

  setQabds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };
    var url =
        'https://yaghco.website/quds_laravel/api/qabds/${company_id.toString()}/${salesman_id.toString()}';
    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body);
    setState(() {
      Qadbs = res["qabds"];
    });
  }

  pdfFatora8CM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? shop_no = prefs.getString('shop_no');
    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterTime = DateFormat('kk:mm:ss');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    var arabicFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Hacen_Tunisia.ttf"));
    List<pw.Widget> widgets = [];
    final title = pw.Column(
      children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Row(children: [
            pw.Text(actualDate.toString(),
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            pw.SizedBox(width: 5),
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Text("التاريخ : ", style: pw.TextStyle(fontSize: 9))),
          ]),
        ]),
        pw.SizedBox(height: 2),
      ],
    );
    widgets.add(title);
    final firstrow = pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // pw.Directionality(
          //   textDirection: pw.TextDirection.rtl,
          //   child: pw.Expanded(
          //     flex: 1,
          //     child: pw.Container(
          //       child: pw.Center(
          //         child: pw.Text(
          //           "رقم الزبون",
          //           style: pw.TextStyle(fontSize: 8),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 2,
              child: pw.Container(
                child: pw.Center(
                  child: pw.Text(
                    "ملاحظات",
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
              ),
            ),
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 2,
              child: pw.Container(
                child: pw.Center(
                  child: pw.Text(
                    "التاريخ",
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
              ),
            ),
          ),

          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 1,
              child: pw.Container(
                child: pw.Center(
                  child: pw.Text(
                    "المبلغ",
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
              ),
            ),
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 1,
              child: pw.Container(
                child: pw.Center(
                  child: pw.Text(
                    "أسم الزبون",
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    widgets.add(firstrow);

    final listview = pw.ListView.builder(
      itemCount: Qadbs.length,
      itemBuilder: (context, index) {
        var BALANCE = double.parse(Qadbs[index]['chks']) +
            double.parse(Qadbs[index]['cash']) +
            double.parse(Qadbs[index]['discount']);
        return pw.Container(
          height: 15,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(right: 5, left: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                // pw.Directionality(
                //   textDirection: pw.TextDirection.rtl,
                //   child: pw.Expanded(
                //     flex: 1,
                //     child: pw.Container(
                //       child: pw.Center(
                //         child: pw.Text(
                //           "${Qadbs[index]["customer_id"] ?? 1}",
                //           style: pw.TextStyle(
                //             fontWeight: pw.FontWeight.bold,
                //             fontSize: 8,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 2,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${Qadbs[index]["notes"] ?? "-"}",
                          style: pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 2,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${Qadbs[index]["q_date"] ?? "-"}",
                          style: pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${BALANCE}",
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${Qadbs[index]['customer']["c_name"] ?? "-"}",
                          style: pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    widgets.add(listview);
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
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
}
