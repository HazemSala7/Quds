import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../edit_product/edit_product.dart';

class OrderCard extends StatefulWidget {
  final image, name, total, notes, product_id;
  Function removeProduct;
  int id;
  var qty, discount, ponus_one, ponus_two, price, invoice_id;
  OrderCard(
      {Key? key,
      this.image,
      required this.qty,
      required this.product_id,
      required this.notes,
      required this.id,
      required this.invoice_id,
      this.price,
      this.name,
      required this.ponus_one,
      required this.removeProduct,
      required this.ponus_two,
      required this.discount,
      this.total})
      : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 30, right: 15, left: 15),
        child: Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 7,
                blurRadius: 5,
              ),
            ],
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      child: Container(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4)),
                          child: Image.network(widget.image,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;

                                return Center(
                                    child: CircularProgressIndicator(
                                  backgroundColor: Main_Color,
                                ));
                                // You can use LinearProgressIndicator or CircularProgressIndicator instead
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    "assets/quds_logo.jpeg",
                                    fit: BoxFit.cover,
                                  )),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(
                              "الأسم :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.name.length > 10
                                  ? widget.name.substring(0, 10) + '...'
                                  : widget.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "السعر :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "₪${widget.price}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "الكميه :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${widget.qty}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "بونص 1 :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.ponus_one}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "بونص 2 :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.ponus_two}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "الخصم :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.discount}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "المجموع :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.total.toString().length < 5
                                  ? "₪${widget.total}"
                                  : "₪${widget.total.toString().substring(0, 4)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProduct(
                                    product_id: widget.product_id,
                                    name: widget.name,
                                    price: widget.price,
                                    qty: widget.qty,
                                    invoiceID: widget.invoice_id,
                                    bonus1: widget.ponus_one,
                                    bonus2: widget.ponus_two,
                                    discount: widget.discount,
                                    notes: widget.notes,
                                    ID: widget.id,
                                  )));
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Main_Color,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "تعديل",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "هل تريد بالتأكيد حذف هذا المنتج من الطلبيه؟"),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      widget.removeProduct();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Main_Color),
                                      child: Center(
                                        child: Text(
                                          "نعم",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Main_Color),
                                    child: Center(
                                      child: Text(
                                        "لا",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Main_Color,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          " حذف",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
