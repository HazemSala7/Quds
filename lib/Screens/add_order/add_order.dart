import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../LocalDB/Models/CartModel.dart';
import '../../LocalDB/Provider/CartProvider.dart';
import '../../Server/server.dart';
import '../../Services/Drawer/drawer.dart';
import '../products/products.dart';
import 'package:pdf/widgets.dart' as pw;

class AddOrder extends StatefulWidget {
  final id, total, fatora_id, customer_name;
  const AddOrder(
      {Key? key, this.id, this.total, this.fatora_id, this.customer_name})
      : super(key: key);

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  setContrllers() {
    valueController.text = widget.total;
  }

  @override
  void initState() {
    super.initState();
    setContrllers();
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
                title: "اضافة طلبية",
              ),
              preferredSize: Size.fromHeight(50)),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "قيمه الفاتوره",
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
                        controller: valueController,
                        obscureText: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff34568B), width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD6D3D3)),
                          ),
                          hintText: "قيمه الفاتوره",
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
                          "الخصم",
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
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        controller: DiscountController,
                        obscureText: false,
                        onChanged: (_) {
                          if (DiscountController.text == "") {
                            setState(() {
                              valueafterController.text = valueController.text;
                            });
                          } else {
                            setState(() {
                              var tot = double.parse(valueController.text) -
                                  double.parse(DiscountController.text);
                              valueafterController.text = tot.toString();
                            });
                          }
                        },
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
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "المجموع بعد الخصم",
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
                        controller: valueafterController,
                        obscureText: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff34568B), width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Color(0xffD6D3D3)),
                          ),
                          hintText: "المجموع بعد الخصم",
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
                          "الملاحظات",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      child: TextField(
                        controller: NotesController,
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
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 25, left: 25, top: 35, bottom: 20),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 50,
                      minWidth: double.infinity,
                      color: Color(0xff34568B),
                      textColor: Colors.white,
                      child: Text(
                        "حفظ الطلبيه",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              actions: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      final cartProvider =
                                          Provider.of<CartProvider>(context,
                                              listen: false);
                                      List<CartItem> cartItems =
                                          cartProvider.cartItems;
                                      Navigator.pop(context);
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
                                      send(pdfFatora5CM(cartItems));
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Main_Color,
                                      ),
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          "طباعه 5سم",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      final cartProvider =
                                          Provider.of<CartProvider>(context,
                                              listen: false);
                                      List<CartItem> cartItems =
                                          cartProvider.cartItems;
                                      Navigator.pop(context);
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
                                      send(pdfFatora8CM(cartItems));
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Main_Color,
                                      ),
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          "طباعه 8سم",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      final cartProvider =
                                          Provider.of<CartProvider>(context,
                                              listen: false);
                                      List<CartItem> cartItems =
                                          cartProvider.cartItems;
                                      Navigator.pop(context);

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
                                      send(pdfFatoraA4(cartItems));
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Main_Color,
                                      ),
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          "طباعه A4",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
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
                                      send(nothing());
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Main_Color,
                                      ),
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          "لا أريد",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
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

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String setTimet = '';
  TextEditingController Controller = TextEditingController();

  String _hour = '', _minute = '', _time = '';

  Future<Null> sat_start(BuildContext context) async {
    TimeOfDay? picked1 = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!);
        });

    if (picked1 != null)
      setState(() {
        selectedTime = picked1;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        Controller.text = _time;
        Controller.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [HH, ':', nn, ":", "00"]).toString();
      });
  }

  TextEditingController dateinput = TextEditingController();
  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      // print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      // print(
      //     formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        dateinput.text = formattedDate; //set output date to TextField value.
      });
    } else {
      // print("Date is not selected");
    }
  }

  TextEditingController DiscountController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController valueafterController = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  send(pdf) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    ;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = DateTime.now();
    var formatterDate = DateFormat('yy-MM-dd');
    var formatterTime = DateFormat('kk:mm:ss');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    String? store_id_order = prefs.getString('store_id') ?? "1";
    List<Map<String, dynamic>> productsArray = cartProvider.getProductsArray();
    String jsonData = jsonEncode(productsArray);
    List<dynamic> parsedData = jsonDecode(jsonData);
    List ProductsIDarray = [];
    List ProductsNamearray = [];
    List qtyArray = [];
    List priceArray = [];
    List ponus1Array = [];
    List ponus2Array = [];
    List discountArray = [];
    List totalArray = [];
    List notesArray = [];
    List colorArray = [];
    for (int i = 0; i < parsedData.length; i++) {
      ProductsIDarray.add(parsedData[i]["product_id"]);
      ProductsNamearray.add(parsedData[i]["name"]);
      priceArray.add(parsedData[i]["price"]);
      colorArray.add(parsedData[i]["color"].toString());
      qtyArray.add(parsedData[i]["quantity"]);
      ponus1Array.add(parsedData[i]["ponus1"]);
      ponus2Array.add(0);
      discountArray.add(0);
      totalArray.add(0);
      notesArray.add(parsedData[i]["notes"]);
    }
    var url = 'https://aliexpress.ps/quds_laravel/api/add_order_test';
    var request = new http.MultipartRequest("POST", Uri.parse(url));
    for (int i = 0; i < ProductsIDarray.length; i++) {
      request.fields['product_id[$i]'] = ProductsIDarray[i].toString();
    }
    for (int i = 0; i < colorArray.length; i++) {
      request.fields['color_name[$i]'] = colorArray[i].toString();
    }
    for (int i = 0; i < ProductsNamearray.length; i++) {
      request.fields['product_name[$i]'] = ProductsNamearray[i].toString();
    }
    for (int i = 0; i < priceArray.length; i++) {
      request.fields['p_price[$i]'] = priceArray[i].toString();
    }
    for (int i = 0; i < qtyArray.length; i++) {
      request.fields['p_quantity[$i]'] = qtyArray[i].toString();
    }
    for (int i = 0; i < ponus1Array.length; i++) {
      request.fields['bonus1[$i]'] = ponus1Array[i].toString();
    }
    for (int i = 0; i < ponus2Array.length; i++) {
      request.fields['bonus2[$i]'] = ponus2Array[i].toString();
    }
    for (int i = 0; i < discountArray.length; i++) {
      request.fields['discount[$i]'] = discountArray[i].toString();
    }
    for (int i = 0; i < notesArray.length; i++) {
      request.fields['notes[$i]'] = notesArray[i].toString();
    }
    request.fields['f_date'] = actualDate.toString();
    request.fields['f_value'] = valueafterController.text;
    request.fields['customer_id'] = widget.id.toString();
    request.fields['company_id'] = company_id.toString();
    request.fields['salesman_id'] = salesman_id.toString();
    request.fields['f_code'] = "1";
    request.fields['f_discount'] =
        DiscountController.text == "" ? "0" : DiscountController.text;
    request.fields['store_id'] = store_id_order.toString();
    request.fields['f_time'] = actualTime.toString();
    request.fields['note'] = NotesController.text;
    if (store_id_order == "") {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("الرجاء اضافه رقم المخزن في صفحه تعريفات أوليه"),
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
      var headers = {'ContentType': 'application/json'};
      request.headers.addAll(headers);
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) async {
        Map valueMap = json.decode(value);
        if (valueMap['status'].toString() == 'true') {
          Navigator.of(context, rootNavigator: true).pop();
          Fluttertoast.showToast(
              msg: "تم اضافه الفاتوره بنجاح",
              backgroundColor: Colors.green,
              fontSize: 18);
          cartProvider.clearCart();
          pdf;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          print('failed');
        }
      });
    }
  }

  nothing() {}

  pdfFatoraA4(var cartItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? shop_no = prefs.getString('shop_no');
    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterTime = DateFormat('kk:mm:ss');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    var arabicFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Hacen_Tunisia.ttf"));
    // var imagelogo = pw.MemoryImage(
    //   (await rootBundle.load('assets/quds_logo.jpeg')).buffer.asUint8List(),
    // );
    List<pw.Widget> widgets = [];
    final title = pw.Column(
      children: [
        // pw.Directionality(
        //     textDirection: pw.TextDirection.rtl,
        //     child: pw.Text("شركه يغمور للتجاره",
        //         style: pw.TextStyle(fontSize: 20))),
        // pw.SizedBox(
        //   height: 5,
        // ),
        // pw.Directionality(
        //     textDirection: pw.TextDirection.rtl,
        //     child: pw.Text("الخليل  - دوار المناره",
        //         style: pw.TextStyle(fontSize: 20))),
        // pw.SizedBox(
        //   height: 5,
        // ),
        // pw.Directionality(
        //     textDirection: pw.TextDirection.rtl,
        //     child: pw.Text("0595324689", style: pw.TextStyle(fontSize: 20))),
        // pw.SizedBox(
        //   height: 5,
        // ),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Row(children: [
            pw.Text(actualDate.toString(),
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 17)),
            pw.SizedBox(width: 5),
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child:
                    pw.Text("التاريخ : ", style: pw.TextStyle(fontSize: 17))),
          ]),
        ]),
        pw.SizedBox(height: 5),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(widget.customer_name.toString(),
                style: pw.TextStyle(fontSize: 17)),
          ),
          pw.SizedBox(width: 5),
          pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child:
                  pw.Text("أسم الزبون : ", style: pw.TextStyle(fontSize: 17))),
        ]),
        pw.SizedBox(
          height: 5,
        ),
      ],
    );
    widgets.add(title);
    final firstrow = pw.Container(
      height: 40,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(right: 5, left: 5),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                flex: 1,
                child: pw.Container(
                  // decoration: pw.BoxDecoration(
                  //   border: pw.Border.all(color: PdfColors.grey400),
                  // ),
                  child: pw.Center(
                    child: pw.Text(
                      "المبلغ",
                      style: pw.TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                flex: 1,
                child: pw.Container(
                  child: pw.Center(
                    child: pw.Text(
                      "السعر",
                      style: pw.TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                flex: 1,
                child: pw.Container(
                  child: pw.Center(
                    child: pw.Text(
                      "الكمية",
                      style: pw.TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Expanded(
                flex: 2,
                child: pw.Container(
                  child: pw.Center(
                    child: pw.Text(
                      "الصنف",
                      style: pw.TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    widgets.add(firstrow);

    final listview = pw.ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        CartItem item = cartItems[index];
        double total = item.price * item.quantity;
        return pw.Container(
          height: 40,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(right: 5, left: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${total.toString()}",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${item.price}",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${item.quantity}",
                          style: pw.TextStyle(
                            fontSize: 17,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 2,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${item.name}",
                          style: pw.TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    widgets.add(listview);
    final total =
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
      pw.SizedBox(height: 10),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
        pw.Text(widget.total.toString(),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 17)),
        pw.SizedBox(width: 5),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text("المجوع قبل الخصم : ",
                style: pw.TextStyle(fontSize: 17))),
      ]),
      pw.SizedBox(height: 10),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
        pw.Text(DiscountController.text,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 17)),
        pw.SizedBox(width: 5),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(" الخصم : ", style: pw.TextStyle(fontSize: 17))),
      ]),
      pw.SizedBox(height: 10),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
        pw.Text(valueController.text,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 17)),
        pw.SizedBox(width: 5),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text("المجموع النهائي : ",
                style: pw.TextStyle(fontSize: 17))),
      ]),
    ]);
    widgets.add(total);
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        pageFormat: PdfPageFormat.a4,

        build: (context) => widgets, //here goes the widgets list
      ),
    );
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pdfFatora8CM(var cartItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? shop_no = prefs.getString('shop_no');
    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterTime = DateFormat('kk:mm:ss');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    var arabicFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Hacen_Tunisia.ttf"));
    // var imagelogo = pw.MemoryImage(
    //   (await rootBundle.load('assets/quds_logo.jpeg')).buffer.asUint8List(),
    // );
    List<pw.Widget> widgets = [];
    final title = pw.Column(
      children: [
        // pw.Container(
        //     height: 70,
        //     width: double.infinity,
        //     child: pw.Image(imagelogo, fit: pw.BoxFit.cover)),
        // pw.SizedBox(
        //   height: 5,
        // ),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Row(children: [
            pw.Text(actualDate.toString(),
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            pw.SizedBox(width: 5),
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Text("التاريخ : ", style: pw.TextStyle(fontSize: 9))),
          ]),
        ]),
        pw.SizedBox(height: 2),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(widget.customer_name.toString(),
                style: pw.TextStyle(fontSize: 8)),
          ),
          pw.SizedBox(width: 5),
          pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child:
                  pw.Text("أسم الزبون : ", style: pw.TextStyle(fontSize: 9))),
        ]),
        pw.SizedBox(
          height: 5,
        ),
      ],
    );
    widgets.add(title);
    final firstrow = pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 1,
              child: pw.Container(
                // decoration: pw.BoxDecoration(
                //   border: pw.Border.all(color: PdfColors.grey400),
                // ),
                child: pw.Center(
                  child: pw.Text(
                    "المبلغ",
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
              ),
            ),
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 1,
              child: pw.Container(
                child: pw.Center(
                  child: pw.Text(
                    "السعر",
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
              ),
            ),
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 1,
              child: pw.Container(
                child: pw.Center(
                  child: pw.Text(
                    "الكمية",
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
              ),
            ),
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 2,
              child: pw.Container(
                child: pw.Center(
                  child: pw.Text(
                    "الصنف",
                    style: pw.TextStyle(fontSize: 8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    widgets.add(firstrow);

    final listview = pw.ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        CartItem item = cartItems[index];
        double total = item.price * item.quantity;
        return pw.Container(
          height: 30,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(right: 5, left: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${total.toString()}",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${item.price}",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${item.quantity}",
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 2,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${item.name}",
                          style: pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    widgets.add(listview);
    final total =
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
      pw.SizedBox(height: 5),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
        pw.Text(widget.total.toString(),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        pw.SizedBox(width: 5),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text("المجوع قبل الخصم : ",
                style: pw.TextStyle(fontSize: 9))),
      ]),
      pw.SizedBox(height: 5),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
        pw.Text(DiscountController.text,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        pw.SizedBox(width: 5),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(" الخصم : ", style: pw.TextStyle(fontSize: 9))),
      ]),
      pw.SizedBox(height: 5),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
        pw.Text(valueController.text,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        pw.SizedBox(width: 5),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text("المجموع النهائي : ",
                style: pw.TextStyle(fontSize: 9))),
      ]),
    ]);
    widgets.add(total);
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        pageFormat: PdfPageFormat(
          4 * PdfPageFormat.cm,
          20 * PdfPageFormat.cm,
        ),

        build: (context) => widgets, //here goes the widgets list
      ),
    );
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pdfFatora5CM(var cartItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? shop_no = prefs.getString('shop_no');
    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterTime = DateFormat('kk:mm:ss');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    var arabicFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Hacen_Tunisia.ttf"));
    // var imagelogo = pw.MemoryImage(
    //   (await rootBundle.load('assets/quds_logo.jpeg')).buffer.asUint8List(),
    // );
    List<pw.Widget> widgets = [];
    final title = pw.Column(
      children: [
        // pw.Container(
        //     height: 70,
        //     width: double.infinity,
        //     child: pw.Image(imagelogo, fit: pw.BoxFit.cover)),
        pw.SizedBox(
          height: 5,
        ),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Row(children: [
            pw.Text(actualDate.toString(),
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6)),
            pw.SizedBox(width: 2),
            pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Text("التاريخ : ", style: pw.TextStyle(fontSize: 6))),
          ]),
        ]),
        pw.SizedBox(height: 2),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(widget.customer_name.toString(),
                style: pw.TextStyle(fontSize: 6)),
          ),
          pw.SizedBox(width: 5),
          pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child:
                  pw.Text("أسم الزبون : ", style: pw.TextStyle(fontSize: 6))),
        ]),
        pw.SizedBox(
          height: 5,
        ),
      ],
    );
    widgets.add(title);
    final firstrow = pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 1,
              child: pw.Container(
                // decoration: pw.BoxDecoration(
                //   border: pw.Border.all(color: PdfColors.grey400),
                // ),
                child: pw.Center(
                  child: pw.Text(
                    "المبلغ",
                    style: pw.TextStyle(fontSize: 6),
                  ),
                ),
              ),
            ),
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 1,
              child: pw.Container(
                child: pw.Center(
                  child: pw.Text(
                    "السعر",
                    style: pw.TextStyle(fontSize: 6),
                  ),
                ),
              ),
            ),
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 1,
              child: pw.Container(
                child: pw.Center(
                  child: pw.Text(
                    "الكمية",
                    style: pw.TextStyle(fontSize: 6),
                  ),
                ),
              ),
            ),
          ),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Expanded(
              flex: 2,
              child: pw.Container(
                child: pw.Center(
                  child: pw.Text(
                    "الصنف",
                    style: pw.TextStyle(fontSize: 6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    widgets.add(firstrow);

    final listview = pw.ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        CartItem item = cartItems[index];
        double total = item.price * item.quantity;
        return pw.Container(
          height: 40,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(right: 5, left: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${total.toString()}",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${item.price}",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 1,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${item.quantity}",
                          style: pw.TextStyle(
                            fontSize: 6,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Expanded(
                    flex: 2,
                    child: pw.Container(
                      child: pw.Center(
                        child: pw.Text(
                          "${item.name}",
                          style: pw.TextStyle(
                            fontSize: 6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    widgets.add(listview);
    final total =
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
      pw.SizedBox(height: 5),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
        pw.Text(widget.total.toString(),
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6)),
        pw.SizedBox(width: 2),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text("المجوع قبل الخصم : ",
                style: pw.TextStyle(fontSize: 6))),
      ]),
      pw.SizedBox(height: 5),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
        pw.Text(DiscountController.text,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6)),
        pw.SizedBox(width: 2),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text(" الخصم : ", style: pw.TextStyle(fontSize: 6))),
      ]),
      pw.SizedBox(height: 5),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
        pw.Text(valueController.text,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6)),
        pw.SizedBox(width: 2),
        pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Text("المجموع النهائي : ",
                style: pw.TextStyle(fontSize: 6))),
      ]),
    ]);
    widgets.add(total);
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: arabicFont,
        ),
        pageFormat: PdfPageFormat(
          4 * PdfPageFormat.cm,
          20 * PdfPageFormat.cm,
        ),

        build: (context) => widgets, //here goes the widgets list
      ),
    );
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
