import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Server/server.dart';
import '../../Services/Drawer/drawer.dart';
import '../products/products.dart';

class AddOrder extends StatefulWidget {
  final id, total, fatora_id;
  const AddOrder({Key? key, this.id, this.total, this.fatora_id})
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
              child: AppBarBack(), preferredSize: Size.fromHeight(50)),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "اضافه فاتوره",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
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
                          setState(() {
                            var tot = double.parse(valueController.text) -
                                double.parse(DiscountController.text);
                            valueController.text = tot.toString();
                          });
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
                              content: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            );
                          },
                        );
                        send();
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
  TextEditingController NotesController = TextEditingController();
  send() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = DateTime.now();
    var formatterDate = DateFormat('yy-MM-dd');
    var formatterTime = DateFormat('kk:mm:ss');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    String? store_id_order = prefs.getString('store_id');
    var url = 'https://yaghco.website/quds_laravel/api/add_order';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'f_date': actualDate.toString(),
        'f_value': valueController.text,
        'fatora_id': widget.fatora_id.toString(),
        'customer_id': widget.id.toString(),
        'company_id': company_id.toString(),
        'f_code': "1",
        'salesman_id': salesman_id.toString(),
        'f_discount':
            DiscountController.text == "" ? "0" : DiscountController.text,
        'store_id': store_id_order.toString(),
        'notes': NotesController.text == "" ? "-" : NotesController.text,
        'f_time': actualTime.toString(),
      },
    );
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
      var data = jsonDecode(response.body);
      if (data['status'] == 'true') {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: "تم اضافه الفاتوره بنجاح");
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        print('fsdsdfs');
      }
    }
  }
}
