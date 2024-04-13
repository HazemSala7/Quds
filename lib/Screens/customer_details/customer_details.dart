import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/add_sarf/add_sarf.dart';
import 'package:flutter_application_1/Screens/catch_receipt/catch_receipt.dart';
import 'package:flutter_application_1/Screens/categories/categories.dart';
import 'package:flutter_application_1/Screens/kashf_hesab/kashf_hesab.dart';
import 'package:flutter_application_1/Screens/sarf/sarf.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/Drawer/drawer.dart';
import '../add_product/add_product.dart';
import 'customer_details_card/customer_details_card.dart';

class CustomerDetails extends StatefulWidget {
  final id, name, balance;
  const CustomerDetails({Key? key, this.id, required this.balance, this.name})
      : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  @override
  String scanBarcode = '';
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  TextEditingController idController = TextEditingController();
  var Price_Code;
  initiatePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code_price = prefs.getString('price_code');
    setState(() {
      Price_Code = code_price;
    });
  }

  Timer? _timer;
  bool dontgo = false;
  _AnimatedFlutterLogoState() {
    _timer = new Timer(const Duration(milliseconds: 400), () {
      setState(() {});
    });
  }

  bool qr_barcode = false;
  barcodeScan() async {
    String barcodeScanRes = "";

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = '';
    }
    return barcodeScanRes;
  }

  qrScan() async {
    String barcodeScanRes = "";

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = '';
    }

    return barcodeScanRes;
  }

  var pr;

  setPrice(pro_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var url =
        'http://aliexpress.ps/quds_laravel/api/check_invoiceproducts/${company_id.toString()}/${salesman_id.toString()}/${widget.id}/$pro_id';
    var response = await http.get(Uri.parse(url));
    var res = jsonDecode(response.body);
    if (res["invoiceproducts"].length == 0) {
      return "0";
    } else {
      return res["invoiceproducts"][0]["p_price"];
    }
  }

  setPriceBarcode(pro_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    var url =
        'http://aliexpress.ps/quds_laravel/api/get_price_barcode/${company_id.toString()}/${salesman_id.toString()}/${widget.id}/$pro_id';
    var response = await http.get(Uri.parse(url));
    var res = jsonDecode(response.body);
    if (res["invoiceproducts"].length == 0) {
      return "0";
    } else {
      return res["invoiceproducts"][0]["p_price"];
    }
  }

  searchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    String? code_price = prefs.getString('price_code');
    var url =
        'http://aliexpress.ps/quds_laravel/api/get_specefic_product/${idController.text}/${company_id.toString()}/${salesman_id.toString()}/${widget.id}/${code_price}';
    var response = await http.get(Uri.parse(url));
    try {
      var res = jsonDecode(response.body)["products"][0];
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddProduct(
                    packingNumber: "",
                    packingPrice: "",
                    id: res["id"],
                    desc: res["description"] ?? "",
                    productColors: [],
                    name: res["p_name"],
                    customer_id: widget.name.toString(),
                    price: res["price"],
                    image: res["images"],
                    qty: res["quantity"],
                  )));
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(msg: "المنتج غير متوفر!");
    }
  }

  dont() {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(msg: "لديك خطأ ما");
  }

  searchBarcode() async {
    // var barcode = await barcodeScan();
    var barcode = qr_barcode ? await barcodeScan() : await qrScan();
    // while (barcode.isNotEmpty) {
    //   barcode = await barcodeScan();
    // }
    setState(() {
      scanBarcode = barcode.toString();
    });

    scanBarcode.toString() == "" && dontgo == false ? dont() : search_bar();
  }

  search_bar() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? company_id = prefs.getInt('company_id');
      var url =
          'http://aliexpress.ps/quds_laravel/api/search_products_barcode/${company_id.toString()}/${scanBarcode.toString()}';
      var response = await http.get(Uri.parse(url));
      var res = jsonDecode(response.body)["prodcuts"][0];
      if (res.length == 0) {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: "لديك خطأ ما");
      } else {
        var price = "0";
        var prices = res['product'];
        pr = await setPriceBarcode(scanBarcode.toString());

        if (pr.toString() == "0") {
          if (prices.length == 0) {
            // return static price
            price = "0";
          } else if (prices.length == 1) {
            price = prices[0]["price"];
          } else {
            var _price = prices.firstWhere((e) => e["price_code"] == Price_Code,
                orElse: () => "5");

            price = _price == "5" ? "0" : _price["price"];
          }
        } else {
          price = pr;
        }
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddProduct(
                      packingNumber: "",
                      packingPrice: "",
                      id: res["id"].toString(),
                      desc: res["description"] ?? "",
                      productColors: [],
                      image: res["images"],
                      name: res["p_name"],
                      customer_id: widget.name.toString(),
                      price: price,
                      qty: res["quantity"].toString(),
                    )));
        setState(() {
          scanBarcode = "111";
        });
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: "الرجاء اعادة المحاولة");
    }
  }

  lastStep() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
              height: 100,
              width: 100,
              child: Center(child: CircularProgressIndicator())),
        );
      },
    );
    searchBarcode();
  }

  Widget build(BuildContext context) {
    return Container(
      color: Main_Color,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldState,
          drawer: DrawerMain(),
          appBar: PreferredSize(
              child: AppBarBack(
                title: "برنامج القدس للمحاسبة",
              ),
              preferredSize: Size.fromHeight(50)),
          body: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: JUST,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 20, left: 20, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 50,
                            width: 200,
                            child: TextField(
                              controller: idController,
                              textInputAction: TextInputAction.done,
                              textAlign: TextAlign.center,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'بحث عن رقم الصنف',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Main_Color, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0, color: Color(0xffD6D3D3)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              searchProducts();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator())),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(83, 89, 219, 1),
                                    Color.fromRGBO(32, 39, 160, 0.6),
                                  ]),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text("بحث",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Visibility(
                              visible: JUST,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    qr_barcode = true;
                                  });
                                  dontgo
                                      ? Navigator.of(context,
                                              rootNavigator: true)
                                          .pop()
                                      : lastStep();
                                  // setState(() {
                                  //   _scanBarcode = "";
                                  // });
                                },
                                child: Container(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      "بحث عن طريق الباركود",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(83, 89, 219, 1),
                                      Color.fromRGBO(32, 39, 160, 0.6),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: Visibility(
                              visible: JUST,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    qr_barcode = false;
                                  });
                                  dontgo
                                      ? Navigator.of(context,
                                              rootNavigator: true)
                                          .pop()
                                      : lastStep();
                                  // setState(() {
                                  //   _scanBarcode = "";
                                  // });
                                },
                                child: Container(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      "بحث عن طريق QR",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(83, 89, 219, 1),
                                      Color.fromRGBO(32, 39, 160, 0.6),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Visibility(
                                visible: JUST,
                                child: CustomerDetailsCard(
                                  name: "طلبية",
                                  my_icon: Icons.request_page,
                                  navi: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Categories(
                                                  id: widget.id,
                                                  name: widget.name,
                                                )));
                                  },
                                ),
                              ),
                              Visibility(
                                visible: JUST,
                                child: CustomerDetailsCard(
                                  name: "سند قبض",
                                  my_icon: Icons.money,
                                  navi: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CatchReceipt(
                                                  balance: widget.balance,
                                                  name: widget.name.toString(),
                                                  id: widget.id,
                                                )));
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Visibility(
                                visible: JUST,
                                child: CustomerDetailsCard(
                                  name: "سند صرف",
                                  my_icon: Icons.money,
                                  navi: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddSarf(
                                                  name: widget.name.toString(),
                                                  id: widget.id,
                                                )));
                                  },
                                ),
                              ),
                              CustomerDetailsCard(
                                name: "كشف حساب",
                                my_icon: Icons.account_balance,
                                navi: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => KashfHesab(
                                              name: widget.name.toString(),
                                              customer_id:
                                                  widget.id.toString())));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiatePrefs();
  }
}
