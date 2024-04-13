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
  var price, packingNumber, packingPrice;
  var productColors;
  AddProduct(
      {Key? key,
      this.id,
      this.desc,
      this.name,
      this.image,
      this.customer_id,
      this.qty,
      required this.productColors,
      required this.packingNumber,
      required this.packingPrice,
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
  TextEditingController packingnumber = TextEditingController();
  TextEditingController packingprice = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController bonus1Controller = TextEditingController();
  TextEditingController bonus2Controller = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController discountContrller = TextEditingController();
  TextEditingController totalController = TextEditingController();
  String selectedColor = '';
  List<String> _Names = [];

  setContrllers() async {
    if (widget.packingNumber != null || widget.packingNumber != "") {
      packingnumber.text = widget.packingNumber.toString();
      packingprice.text = widget.packingPrice.toString();
    }

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
              child: AppBarBack(
                title: "اضافة صنف الى الطلبية",
              ),
              preferredSize: Size.fromHeight(50)),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(widget.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                "assets/quds_logo.jpeg",
                                fit: BoxFit.cover,
                              ),
                          height: 200)),
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
                  Visibility(
                    visible: widget.packingNumber == null ||
                            widget.packingNumber == ""
                        ? false
                        : true,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, right: 15, left: 15),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "عدد التعبئة",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "سعر التعبئة",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, top: 5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 50,
                                  child: TextField(
                                    readOnly: true,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    controller: packingnumber,
                                    onChanged: (hazem) {
                                      setState(() {
                                        var init_total = double.parse(
                                                qty.text) *
                                            double.parse(priceController.text) *
                                            (1 -
                                                (double.parse(discountContrller
                                                        .text) /
                                                    100));
                                        totalController.text =
                                            init_total.toString();
                                      });
                                    },
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff34568B),
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2.0,
                                            color: Color(0xffD6D3D3)),
                                      ),
                                      hintText: "عدد التعبئة",
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
                                  height: 50,
                                  child: TextField(
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    readOnly: true,
                                    controller: packingprice,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff34568B),
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2.0,
                                            color: Color(0xffD6D3D3)),
                                      ),
                                      hintText: "سعر التعبئة",
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                        height: 50,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.desc.toString()),
                        )),
                  ),
                  Visibility(
                    visible: widget.productColors.length == 0 ? true : false,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, right: 15, left: 15),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "الكمية",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, top: 5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 50,
                                  child: TextField(
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    controller: qty,
                                    onChanged: (hazem) {
                                      setState(() {
                                        var init_total = double.parse(
                                                qty.text) *
                                            double.parse(priceController.text) *
                                            (1 -
                                                (double.parse(discountContrller
                                                        .text) /
                                                    100));
                                        totalController.text =
                                            init_total.toString();
                                      });
                                    },
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff34568B),
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2.0,
                                            color: Color(0xffD6D3D3)),
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
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              signed: true, decimal: true),
                                      readOnly: true,
                                      controller: qtyController,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff34568B),
                                              width: 2.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2.0,
                                              color: Color(0xffD6D3D3)),
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
                          if (widget.productColors.length == 0) {
                            setState(() {
                              var init_total = double.parse(qty.text) *
                                  double.parse(priceController.text) *
                                  (1 -
                                      (double.parse(discountContrller.text) /
                                          100));
                              totalController.text = init_total.toString();
                            });
                          } else {
                            setState(() {
                              totalController.text =
                                  calculateTotal().toString();
                            });
                          }
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
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: widget.productColors.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final colorData = widget.productColors[index];
                        String colorCode = colorData['color'];
                        bool isSelected = selectedColor == colorCode;

                        int quantity = colorData['quantity'] ?? 0;
                        TextEditingController _countController =
                            TextEditingController();
                        _countController.text = quantity.toString();

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Color(int.parse('0xFF$colorCode')),
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Color: $colorCode',
                                style: TextStyle(fontSize: 16),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (quantity > 0) {
                                          quantity--;
                                          colorData['quantity'] = quantity;
                                          int newQuantity = int.tryParse(
                                                  quantity.toString()) ??
                                              0;
                                          updateProductColorQuantity(
                                              index, newQuantity);
                                        }
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: TextField(
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: _countController,
                                        onChanged: (_) {
                                          colorData['quantity'] =
                                              int.parse(_.toString());
                                          quantity = int.parse(_.toString());
                                          int newQuantity = int.tryParse(
                                                  quantity.toString()) ??
                                              0;
                                          updateProductColorQuantity(
                                              index, newQuantity);
                                          setState(() {});
                                        },
                                        onSubmitted: (_) {
                                          colorData['quantity'] =
                                              int.parse(_.toString());
                                          quantity = int.parse(_.toString());
                                          int newQuantity = int.tryParse(
                                                  quantity.toString()) ??
                                              0;
                                          updateProductColorQuantity(
                                              index, newQuantity);
                                          setState(() {});
                                        }),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                        colorData['quantity'] = quantity;
                                        int newQuantity =
                                            int.tryParse(quantity.toString()) ??
                                                0;
                                        updateProductColorQuantity(
                                            index, newQuantity);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
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
                        if (widget.productColors.length == 0) {
                          final newItem = CartItem(
                            colorsNames:
                                _Names.map((size) => size.toString()).toList(),
                            notes: notesController.text == ""
                                ? "-"
                                : notesController.text,
                            color: "",
                            productId: widget.id.toString(),
                            name: widget.name,
                            image: widget.image,
                            price: double.parse(priceController.text),
                            discount: double.parse(discountContrller.text),
                            quantity: qty.text == "" || qty.text == null
                                ? 1
                                : int.parse(qty.text),
                            ponus1: int.parse(bonus1Controller.text == ""
                                ? "0"
                                : bonus1Controller.text),
                            ponus2: int.parse(bonus2Controller.text == ""
                                ? "0"
                                : bonus2Controller.text),
                          );
                          cartProvider.addToCart(newItem);
                        } else {
                          for (int i = 0;
                              i < widget.productColors.length;
                              i++) {
                            _Names.add(
                                widget.productColors[i]["color"].toString());
                          }
                          for (int i = 0;
                              i < widget.productColors.length;
                              i++) {
                            if (int.parse(
                                    widget.productColors[i]['quantity'] == null
                                        ? "0"
                                        : widget.productColors[i]['quantity']
                                            .toString()) >=
                                1) {
                              final newItem = CartItem(
                                colorsNames:
                                    _Names.map((size) => size.toString())
                                        .toList(),
                                notes: notesController.text == ""
                                    ? "-"
                                    : notesController.text,
                                color:
                                    widget.productColors[i]["color"].toString(),
                                productId: widget.id.toString(),
                                name: widget.name,
                                image: widget.image,
                                price: double.parse(priceController.text),
                                discount: double.parse(discountContrller.text),
                                quantity: int.parse(widget.productColors[i]
                                        ['quantity']
                                    .toString()),
                                ponus1: int.parse(bonus1Controller.text == ""
                                    ? "0"
                                    : bonus1Controller.text),
                                ponus2: int.parse(bonus2Controller.text == ""
                                    ? "0"
                                    : bonus2Controller.text),
                              );
                              cartProvider.addToCart(newItem);
                            }
                          }
                        }

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

  double calculateTotal() {
    double totalPrice = 0.0;
    for (var colorData in widget.productColors) {
      int quantity = colorData['quantity'] ?? 0;
      double colorPrice = quantity * double.parse(priceController.text);
      totalPrice += colorPrice;
    }
    return totalPrice;
  }

  void updateProductColorQuantity(int index, int newQuantity) {
    setState(() {
      widget.productColors[index]['quantity'] = newQuantity;
      totalController.text = calculateTotal().toString();
    });
  }
}
