import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/invoice_details/invoice_details.dart';
import 'package:flutter_application_1/Server/server.dart';

import '../../customer_details/customer_details.dart';

class InvoiceCard extends StatefulWidget {
  final date, from, to, Statement, balance;
  InvoiceCard(
      {Key? key, this.balance, this.date, this.from, this.to, this.Statement})
      : super(key: key);

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      widget.balance,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      widget.from,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      widget.to,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      widget.Statement,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvoiceDetails(
                                      date: widget.date ?? "",
                                    )));
                      },
                      child: Text(
                        widget.date,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Main_Color),
                      ),
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
    );
  }
}
