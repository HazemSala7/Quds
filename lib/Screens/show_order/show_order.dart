import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/show_order/order_card/order_card.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../LocalDB/Models/CartModel.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../Services/Drawer/drawer.dart';
import '../add_order/add_order.dart';

class ShowOrder extends StatefulWidget {
  final id, name;
  const ShowOrder({Key? key, this.id, this.name}) : super(key: key);

  @override
  State<ShowOrder> createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrder> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Container(
      color: Main_Color,
      child: SafeArea(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Scaffold(
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Main_Color),
                        ),
                      ],
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      List<CartItem> cartItems = cartProvider.cartItems;

                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          CartItem item = cartItems[index];
                          double total = item.price * item.quantity;
                          // var total = item.price *
                          //     double.parse(item.quantity.toString());
                          // double Alltotal = 0;
                          // for (CartItem item in cartItems) {
                          //   total += total;
                          // }
                          return OrderCard(
                            ponus_one: item.ponus1,
                            editProduct: () {
                              _editCartItem(cartProvider, item);
                            },
                            notes: " - ",
                            product_id: item.productId,
                            id: 2,
                            ItemCart: item,
                            invoice_id: 0,
                            ponus_two: item.ponus2,
                            discount: item.discount,
                            total: total,
                            price: item.price,
                            name: item.name,
                            qty: item.quantity,
                            removeProduct: () {
                              cartProvider.removeFromCart(item);
                              setState(() {});
                            },
                            image: item.image,
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
          BottomContainer(
            total: calculateTotal(cartProvider.cartItems),
            fatora_id: "0",
          ),
        ],
      )),
    );
  }

  double calculateTotal(List<CartItem> cartItems) {
    double total = 0;
    for (CartItem item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  _editCartItem(
    CartProvider cartProvider,
    CartItem item,
  ) {
    // Check if there is an ongoing navigation or dialog operation
    // if (Navigator.of(context).canPop()) {
    //   return;
    // }
    final TextEditingController nameController =
        TextEditingController(text: item.name);
    final TextEditingController priceController =
        TextEditingController(text: item.price.toString());
    final TextEditingController ponus1Controller =
        TextEditingController(text: item.ponus1.toString());
    final TextEditingController ponus2Controller =
        TextEditingController(text: item.ponus2.toString());
    final TextEditingController discontController =
        TextEditingController(text: item.discount.toString());
    final TextEditingController qtyController =
        TextEditingController(text: item.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تعديل بيانات المنتج'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'أسم المنتج'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'سعر المنتج'),
                keyboardType: TextInputType.number,
              ),
              Visibility(
                visible: ponus1,
                child: TextField(
                  controller: ponus1Controller,
                  decoration: InputDecoration(labelText: 'بونص 1'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Visibility(
                visible: ponus2,
                child: TextField(
                  controller: ponus2Controller,
                  decoration: InputDecoration(labelText: 'بونص 2'),
                  keyboardType: TextInputType.number,
                ),
              ),
              Visibility(
                visible: discount,
                child: TextField(
                  controller: discontController,
                  decoration: InputDecoration(labelText: 'الخصم'),
                  keyboardType: TextInputType.number,
                ),
              ),
              TextField(
                controller: qtyController,
                decoration: InputDecoration(labelText: 'الكميه'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('خروج'),
            ),
            TextButton(
              onPressed: () {
                // print("priceController.text");
                // print(priceController.text);
                if (int.parse(qtyController.text) > 0 &&
                    double.parse(priceController.text.toString()) == 0.0) {
                  // Navigator.of(context, rootNavigator: true).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                          'الكمية أكبر من 1 و السعر يساوي صفر , لا يمكن',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        actions: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Main_Color,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  "حسنا",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  double price = double.parse(priceController.text);
                  int quantity = int.parse(qtyController.text);
                  int ponus1filnal = int.parse(ponus1Controller.text);

                  // Call the updateCartItem function in CartProvider
                  cartProvider.updateCartItem(
                    item.copyWith(
                      name: nameController.text,
                      price: price,
                      quantity: quantity,
                      ponus1: ponus1filnal,
                    ),
                  );
                  setState(() {});

                  Navigator.of(context).pop();
                }
              },
              child: Text('حفظ البيانات'),
            ),
          ],
        );
      },
    );
  }

  removeProduct(id) async {
    var url = 'https://yaghco.website/quds_laravel/api/remove_fatora';
    var response = await http.post(Uri.parse(url), body: {"id": id.toString()});
    var data = jsonDecode(response.body);

    if (data['status'] == 'true') {
      Fluttertoast.showToast(msg: "تم حذف المنتج بنجاح");
    } else {
      Fluttertoast.showToast(msg: "حصل خطأ في عمليه الحذف");
    }
  }

  Widget BottomContainer({var total, var fatora_id}) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "المجموع : ",
                  style: GoogleFonts.cairo(
                      fontSize: 17,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                ),
                Text(
                  "₪$total",
                  style: GoogleFonts.cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Main_Color,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddOrder(
                                total: total.toString(),
                                id: widget.id,
                                fatora_id: fatora_id,
                                customer_name: widget.name,
                              )));
                },
                child: Container(
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Main_Color),
                  child: Center(
                    child: Text(
                      "حفظ الطلبيه",
                      style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getInvoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var url =
        'https://yaghco.website/quds_laravel/api/invoiceproducts/${company_id.toString()}/${salesman_id.toString()}';
    var response = await http.get(Uri.parse(url));
    var res = jsonDecode(response.body);
    return res;
  }
}
