import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/products/products.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/AppBar/appbar_back.dart';
import '../../Services/Drawer/drawer.dart';

class Categories extends StatefulWidget {
  final id, name;
  Categories({Key? key, this.id, this.name}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "الأقسام",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
                child: FutureBuilder(
                  future: getCategories(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: SpinKitPulse(
                            color: Main_Color,
                            size: 60,
                          ),
                        ),
                      );
                    } else if (snapshot.data != null) {
                      var mydata = snapshot.data['categories'];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Products(
                                            category_id: "all",
                                            id: widget.id,
                                            name: widget.name,
                                          )));
                            },
                            child: Container(
                              width: 150,
                              height: 60,
                              child: Center(
                                child: Text(
                                  "جميع الأصناف",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                    ),
                                  ],
                                  border:
                                      Border.all(color: Main_Color, width: 2),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 20,
                              crossAxisCount: 2,
                            ),
                            itemCount: mydata.length,
                            itemBuilder: (BuildContext context, int index) {
                              return category(
                                  name: mydata[index]["name"],
                                  id: mydata[index]["id"]);
                            },
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        child: Center(
                            child: Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator())),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget category({String name = "", int id = 0}) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Screen()));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Products(
                      category_id: id.toString(),
                      id: widget.id,
                      name: widget.name,
                    )));
      },
      child: Container(
        width: 120,
        // height: 50,
        child: Center(
          child: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
              ),
            ],
            border: Border.all(color: Main_Color, width: 2),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    var url =
        'https://yaghco.website/quds_laravel/api/categories/${company_id.toString()}';
    var response = await http.get(Uri.parse(url));
    var res = jsonDecode(response.body);
    return res;
  }
}
