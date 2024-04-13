import 'package:flutter/material.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../customer_details/customer_details.dart';

class CustomerCard extends StatefulWidget {
  final name, phone, price_code, id, balance;
  int index;
  CustomerCard(
      {Key? key,
      required this.id,
      required this.index,
      required this.balance,
      this.name,
      this.price_code,
      this.phone})
      : super(key: key);

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('price_code', widget.price_code.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerDetails(
                      balance: widget.balance,
                      id: widget.id,
                      name: widget.name,
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
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                flex: 4,
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
                flex: 4,
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
            ],
          ),
        ),
      ),
    );
  }
}
