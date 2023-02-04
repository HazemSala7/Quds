import 'package:flutter/material.dart';
import 'package:flutter_application_1/Server/server.dart';

import '../../customer_details/customer_details.dart';

class FatoraCard extends StatefulWidget {
  final name, phone;
  int id, balance;
  FatoraCard(
      {Key? key,
      required this.id,
      this.name,
      this.phone,
      required this.balance})
      : super(key: key);

  @override
  State<FatoraCard> createState() => _FatoraCardState();
}

class _FatoraCardState extends State<FatoraCard> {
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
                      "${widget.id}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "${widget.balance}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      widget.name,
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
                                builder: (context) => CustomerDetails()));
                      },
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
