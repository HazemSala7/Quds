import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/kashf_hesab/kashf_hesab.dart';
import 'package:flutter_application_1/Server/server.dart';

import '../../customer_details/customer_details.dart';

class TotalCard extends StatefulWidget {
  final name, phone, balance, id;
  int index;
  TotalCard(
      {Key? key,
      required this.index,
      required this.id,
      this.name,
      this.phone,
      required this.balance})
      : super(key: key);

  @override
  State<TotalCard> createState() => _TotalCardState();
}

class _TotalCardState extends State<TotalCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => KashfHesab(
                      customer_id: widget.id,
                    )));
      },
      child: Container(
        height: 40,
        color: widget.index % 2 == 0 ? Colors.white : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffDFDFDF),
                      border: Border.all(color: Color(0xffD6D3D3))),
                  child: Center(
                    child: Text(
                      "${widget.id}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xffD6D3D3))),
                  child: Center(
                    child: Text(
                      "${widget.balance}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                      widget.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
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
                              builder: (context) => CustomerDetails()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xffD6D3D3))),
                      child: Center(
                        child: Text(
                          widget.phone,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Main_Color),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
