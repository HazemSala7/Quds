import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/invoice/invoice_card/invoice_card.dart';
import 'package:flutter_application_1/Screens/total_receivables/total_card/total_card.dart';
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';

import '../../Server/server.dart';
import '../../Services/AppBar/appbar.dart';
import '../../Services/Drawer/drawer.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key}) : super(key: key);

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
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
                padding: const EdgeInsets.only(
                    right: 15, left: 15, top: 15, bottom: 15),
                child: Row(
                  children: [
                    Text(
                      "أسم الزبون : ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Hazem Salah",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Main_Color),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 40,
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
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
                      width: 15,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 40,
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          textAlign: TextAlign.center,
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
                                "الرصيد",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                "منه",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                "له",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "البيان",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "التاريخ",
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
              ListView.builder(
                itemCount: 15,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InvoiceCard(
                    from: "100",
                    to: "200",
                    balance: "540",
                    Statement: "asdasd",
                    date: "05-09-2022",
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
