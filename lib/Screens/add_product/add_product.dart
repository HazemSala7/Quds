import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../LocalDB/Models/CartModel.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../Server/server.dart';
import '../../Services/Drawer/drawer.dart';

class AddProduct extends StatefulWidget {
  final id, name, qty, customer_id, desc, image;
  var price;
  AddProduct(
      {Key? key,
      this.id,
      this.desc,
      this.name,
      this.image,
      this.customer_id,
      this.qty,
      required this.price})
      : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController invoiceID = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController bonus1Controller = TextEditingController();
  TextEditingController bonus2Controller = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController discountContrller = TextEditingController();
  TextEditingController totalController = TextEditingController();

  setContrllers() async {
    nameController.text = widget.name;
    priceController.text = widget.price.toString();
    qtyController.text = widget.qty.toString();
    discountContrller.text = "0";
    qty.text = "1";
    var init_total = double.parse(qty.text) *
        double.parse(priceController.text) *
        (1 - (double.parse(discountContrller.text) / 100));
    totalController.text = init_total.toString();
  }

  @override
  void initState() {
    super.initState();

    setContrllers();
  }

  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Container(
      color: Main_Color,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldState,
          drawer: DrawerMain(),
          appBar: PreferredSize(
              child: AppBarBack(), preferredSize: Size.fromHeight(50)),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "اضافة صنف",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 20, right: 15, left: 15),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "رقم الفاتوره",
                  //         style: TextStyle(
                  //             fontSize: 16, fontWeight: FontWeight.bold),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                  //   child: Container(
                  //     height: 50,
                  //     width: double.infinity,
                  //     child: TextField(
                  //       controller: invoiceID,
                  //       obscureText: false,
                  //       decoration: InputDecoration(
                  //         focusedBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(
                  //               color: Color(0xff34568B), width: 2.0),
                  //         ),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(
                  //               width: 2.0, color: Color(0xffD6D3D3)),
                  //         ),
                  //         hintText: "رقم الفاتوره",
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "أسم المنتج",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: TextField(
                        readOnly: true,
                        controller: nameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff34568B), width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD6D3D3)),
                          ),
                          hintText: "أسم الصنف",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "وصف المنتج",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffD6D3D3))),
                        // height: 50,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.desc.toString()),
                        )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 15, left: 15),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "الكمية",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Visibility(
                          visible: existed_qty,
                          child: SizedBox(
                            width: 15,
                          ),
                        ),
                        Visibility(
                          visible: existed_qty,
                          child: Expanded(
                            flex: 1,
                            child: Text(
                              "الكمية الموجوده",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 50,
                            child: TextField(
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              controller: qty,
                              onChanged: (hazem) {
                                setState(() {
                                  var init_total = double.parse(qty.text) *
                                      double.parse(priceController.text) *
                                      (1 -
                                          (double.parse(
                                                  discountContrller.text) /
                                              100));
                                  totalController.text = init_total.toString();
                                });
                              },
                              obscureText: false,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff34568B), width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0, color: Color(0xffD6D3D3)),
                                ),
                                hintText: "الكمية",
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: existed_qty,
                          child: SizedBox(
                            width: 15,
                          ),
                        ),
                        Visibility(
                          visible: existed_qty,
                          child: Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                readOnly: true,
                                controller: qtyController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff34568B), width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xffD6D3D3)),
                                  ),
                                  hintText: "الكمية الموجوده",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: ponus1 == false && ponus2 == false ? false : true,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 15, left: 15),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: ponus1,
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "بونص 1",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Visibility(
                            visible: ponus2,
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "بونص 2",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                    child: Row(
                      children: [
                        Visibility(
                          visible: ponus1,
                          child: Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                controller: bonus1Controller,
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff34568B), width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xffD6D3D3)),
                                  ),
                                  hintText: "بونص 1",
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: ponus2,
                          child: SizedBox(
                            width: 15,
                          ),
                        ),
                        Visibility(
                          visible: ponus2,
                          child: Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                controller: bonus2Controller,
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff34568B), width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Color(0xffD6D3D3)),
                                  ),
                                  hintText: "بونص 2",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "سعر المنتج",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: TextField(
                        onChanged: (hazem) {
                          setState(() {
                            var init_total = double.parse(qty.text) *
                                double.parse(priceController.text) *
                                (1 -
                                    (double.parse(discountContrller.text) /
                                        100));
                            totalController.text = init_total.toString();
                          });
                        },
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        controller: priceController,
                        obscureText: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff34568B), width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD6D3D3)),
                          ),
                          hintText: "السعر",
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: discount,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 15, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "الخصم",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: discount,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 5),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: TextField(
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          onChanged: (hazem) {
                            setState(() {
                              var init_total = double.parse(qty.text) *
                                  double.parse(priceController.text) *
                                  (1 -
                                      (double.parse(discountContrller.text) /
                                          100));
                              totalController.text = init_total.toString();
                            });
                          },
                          controller: discountContrller,
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff34568B), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xffD6D3D3)),
                            ),
                            hintText: "الخصم",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "المجموع",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: TextField(
                        readOnly: true,
                        controller: totalController,
                        obscureText: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff34568B), width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD6D3D3)),
                          ),
                          hintText: "المجموع",
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: notes,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 15, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "ملاحظات",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: notes,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 5),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        child: TextField(
                          controller: notesController,
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff34568B), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xffD6D3D3)),
                            ),
                            hintText: "ملاحظات",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 25, left: 25, top: 35, bottom: 30),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 50,
                      minWidth: double.infinity,
                      color: Color(0xff34568B),
                      textColor: Colors.white,
                      child: Text(
                        "اضافة صنف",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        final newItem = CartItem(
                          productId: widget.id.toString(),
                          name: widget.name,
                          image: widget.image,
                          price: double.parse(priceController.text),
                          discount: double.parse(discountContrller.text),
                          quantity: int.parse(qty.text),
                          ponus1: int.parse(bonus1Controller.text == ""
                              ? "0"
                              : bonus1Controller.text),
                          ponus2: int.parse(bonus2Controller.text == ""
                              ? "0"
                              : bonus2Controller.text),
                        );
                        cartProvider.addToCart(newItem);
                        Fluttertoast.showToast(
                            msg: "تم اضافه هذا المنتج الى الفاتوره بنجاح");
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  send() async {
    if (nameController.text == '' || qtyController.text == '') {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('الرجاء تعبئه جميع الفراغات'),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'حسنا',
                  style: TextStyle(color: Color(0xff34568B)),
                ),
              ),
            ],
          );
        },
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? company_id = prefs.getInt('company_id');
      int? salesman_id = prefs.getInt('salesman_id');
      var url = 'https://aliexpress.ps/quds_laravel/api/addFatora';

      final response = await http.post(
        Uri.parse(url),
        body: {
          'product_id': widget.id.toString(),
          'product_name': widget.name.toString(),
          'customer_id': widget.customer_id.toString(),
          'company_id': company_id.toString(),
          'f_code': "1",
          'salesman_id': salesman_id.toString(),
          'p_quantity': qty.text,
          'p_price': priceController.text,
          'bonus1': bonus1Controller.text == "" ? "0" : bonus1Controller.text,
          'bonus2': bonus2Controller.text == "" ? "0" : bonus2Controller.text,
          'discount':
              discountContrller.text == "" ? "0" : discountContrller.text,
          'total': totalController.text,
          'notes': notesController.text == "" ? "-" : notesController.text,
        },
      );

      var data = jsonDecode(response.body);

      if (data['message'] == 'Fatora created successfully') {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: "تم اضافه هذا المنتج الى الطلبيه بنجاح");
        Navigator.pop(context);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        // print('fsdsdfs');
      }
    }
  }
}
