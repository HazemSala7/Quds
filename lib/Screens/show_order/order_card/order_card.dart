import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../edit_product/edit_product.dart';

class OrderCard extends StatefulWidget {
  final image, name, total, notes, product_id;
  Function removeProduct;
  Function editProduct;
  int id;
  var qty, discount, ponus_one, ponus_two, price, invoice_id;
  var ItemCart;
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
      required this.editProduct,
      required this.ponus_two,
      required this.discount,
      required this.ItemCart,
      this.total})
      : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  void _handleMenuSelection(int value) {
    // Handle the selected option
    switch (value) {
      case 1:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("هل تريد بالتأكيد حذف هذا المنتج من الطلبيه؟"),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        widget.removeProduct();
                        Fluttertoast.showToast(msg: "تم حذف المنتج بنجاح");
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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

        break;
      case 2:
        widget.editProduct();
        break;
      case 3:
        // Handle option 3
        break;
      default:
        break;
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 15, left: 15),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            height: 200,
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
                          Visibility(
                            visible: notes,
                            child: Row(
                              children: [
                                Text(
                                  "الملاحظات :",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.notes,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<int>(
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Main_Color,
                    ),
                    title: Text(
                      'حذف',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: Main_Color,
                    ),
                    title: Text(
                      'تعديل',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ),
              ],
              onSelected: (int value) {
                _handleMenuSelection(value);
              },
              child: FaIcon(
                FontAwesomeIcons.listUl,
                color: Main_Color,
              ),
            ),
          )
        ],
      ),
    );
  }
}
