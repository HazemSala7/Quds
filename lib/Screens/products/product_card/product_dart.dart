import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Server/server.dart';
import '../../add_product/add_product.dart';
import '../../edit_product_data/edit_product_data.dart';

class ProductCard extends StatefulWidget {
  final image, name, desc, price_code, id;
  var qty, price, customer_id;

  ProductCard(
      {Key? key,
      this.image,
      required this.id,
      required this.customer_id,
      required this.qty,
      this.price_code,
      required this.price,
      required this.desc,
      this.name})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddProduct(
                      id: widget.id,
                      name: widget.name,
                      customer_id: widget.customer_id.toString(),
                      price: widget.price,
                      qty: widget.qty,
                      desc: widget.desc,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Container(
            child: Wrap(
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 7,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      // decoration:
                      // BoxDecoration(borderRadius: BorderRadius.circular(40)),
                      height: 140,
                      width: double.infinity,
                      child: Center(
                        child: SizedBox(
                          height: 200,
                          width: 250,
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(40)),
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
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProductData(
                                        id: widget.id,
                                        name: widget.name,
                                        price: widget.price,
                                        qty: widget.qty,
                                      )));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 30,
                        ))
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 7,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  // height: 30,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              widget.name,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              '${widget.price} ₪',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Main_Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
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
                    send();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Main_Color,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    height: 35,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "اضافة الى الطلبيه",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //  Container(
        //   height: 280,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey.withOpacity(0.2),
        //         spreadRadius: 7,
        //         blurRadius: 5,
        //       ),
        //     ],
        //     borderRadius: BorderRadius.circular(10),
        //     color: Colors.white,
        //   ),
        //   child: Column(
        //     children: [
        //       Container(
        //         height: 220,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             Expanded(
        //               flex: 3,
        //               child: Padding(
        //                 padding: const EdgeInsets.only(
        //                     right: 10, top: 10, bottom: 10),
        //                 child: Container(
        //                   height: 200,
        //                   decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(10),
        //                   ),
        //                   child: Image.network(widget.image,
        //                       fit: BoxFit.cover,
        //                       loadingBuilder:
        //                           (context, child, loadingProgress) {
        //                         if (loadingProgress == null) return child;

        //                         return Center(
        //                             child: CircularProgressIndicator(
        //                           backgroundColor: Main_Color,
        //                         ));
        //                         // You can use LinearProgressIndicator or CircularProgressIndicator instead
        //                       },
        //                       errorBuilder: (context, error, stackTrace) =>
        //                           Image.asset(
        //                             "assets/quds_logo.jpeg",
        //                             fit: BoxFit.cover,
        //                           )),
        //                 ),
        //               ),
        //             ),
        //             SizedBox(
        //               width: 20,
        //             ),
        //             Expanded(
        //               flex: 3,
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                 children: [
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Container(
        //                         width: 150,
        //                         child: Column(
        //                           mainAxisAlignment: MainAxisAlignment.start,
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               "الأسم : ${widget.name}",
        //                               style: TextStyle(
        //                                   fontWeight: FontWeight.bold,
        //                                   fontSize: 14),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   Row(
        //                     children: [
        //                       Text(
        //                         "السعر :",
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.bold, fontSize: 14),
        //                       ),
        //                       SizedBox(
        //                         width: 10,
        //                       ),
        //                       Text(
        //                         "₪${widget.price}",
        //                         style: TextStyle(
        //                             fontWeight: FontWeight.bold, fontSize: 14),
        //                       ),
        //                     ],
        //                   ),
        //                   Visibility(
        //                     visible: existed_qty,
        //                     child: Row(
        //                       children: [
        //                         Text(
        //                           "الكميه :",
        //                           style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 14),
        //                         ),
        //                         SizedBox(
        //                           width: 10,
        //                         ),
        //                         Text(
        //                           "${widget.qty}",
        //                           style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 14),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                   Visibility(
        //                     visible: desc,
        //                     child: Row(
        //                       children: [
        //                         Text(
        //                           "الوصف :",
        //                           style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 14),
        //                         ),
        //                         SizedBox(
        //                           width: 10,
        //                         ),
        //                         Text(
        //                           "${widget.desc}",
        //                           style: TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                               fontSize: 14),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(top: 10),
        //         child: InkWell(
        //           onTap: () {
        //             showDialog(
        //               context: context,
        //               builder: (BuildContext context) {
        //                 return AlertDialog(
        //                   content: SizedBox(
        //                       height: 100,
        //                       width: 100,
        //                       child:
        //                           Center(child: CircularProgressIndicator())),
        //                 );
        //               },
        //             );
        //             send();
        //           },
        //           child: Container(
        //             decoration: BoxDecoration(
        //                 color: Main_Color,
        //                 borderRadius: BorderRadius.circular(10)),
        //             height: 40,
        //             width: 200,
        //             child: Center(
        //               child: Text(
        //                 "اضافة الى الطلبيه",
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: 18),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  send() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var url = 'https://yaghco.website/quds_laravel/api/addFatora';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'product_id': widget.id.toString(),
        'product_name': widget.name.toString(),
        'customer_id': widget.customer_id.toString(),
        'company_id': company_id.toString(),
        'salesman_id': salesman_id.toString(),
        'p_quantity': "1",
        'f_code': "1",
        'p_price': widget.price,
        'bonus1': "0",
        'bonus2': "0",
        'discount': "0",
        'total': double.parse(widget.price).toString(),
        'notes': "-",
      },
    );

    var data = jsonDecode(response.body);

    if (data['message'] == 'Fatora created successfully') {
      Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(msg: "تم اضافه هذا المنتج الى الطلبيه بنجاح");
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      // print('fsdsdfs');
    }
  }
}
