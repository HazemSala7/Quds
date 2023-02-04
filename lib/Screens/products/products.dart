import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Screens/products/product_card/product_dart.dart';
import 'package:flutter_application_1/Screens/show_order/show_order.dart';
import 'package:flutter_application_1/Server/server.dart';
import 'package:flutter_application_1/Services/AppBar/appbar_back.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Services/Drawer/drawer.dart';

class Products extends StatefulWidget {
  final id, name;
  final category_id;
  const Products({Key? key, this.id, this.name, this.category_id})
      : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  bool search = false;
  TextEditingController idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // filterProducts();

    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
    // getProducts();
  }

  var final_product = [];

  Widget build(BuildContext context) {
    return Container(
      color: Main_Color,
      child: SafeArea(
          child: Scaffold(
        key: _scaffoldState,
        drawer: DrawerMain(),
        appBar: PreferredSize(
            child: AppBarBack(), preferredSize: Size.fromHeight(50)),
        body: _isFirstLoadRunning
            ? Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                child: SpinKitPulse(
                  color: Main_Color,
                  size: 60,
                ),
              )
            : Column(
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
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 15, left: 15, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "الأصناف",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowOrder(
                                          id: widget.id,
                                          name: widget.name,
                                        )));
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            child: Center(
                              child: Text(
                                "عرض الطلبيه",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Main_Color),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 50, left: 50, top: 25),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: TextField(
                        controller: idController,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.center,
                        onChanged: (_) {
                          if (idController.text != "") {
                            searchProducts();
                          } else {
                            _firstLoad();
                          }
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'بحث عن أسم الصنف',
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
                  ),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 0,
                          crossAxisCount: 2,
                        ),
                        controller: _controller,
                        // ignore: unnecessary_null_comparison
                        itemCount: _posts != null ? _posts.length : 0,
                        itemBuilder: (_, int index) {
                          return ProductCard(
                            customer_id: widget.id.toString(),
                            price: _posts[index]['price'] ?? "-",
                            name: _posts[index]['p_name'] ?? "-",
                            desc: _posts[index]['description'] ?? "-",
                            id: _posts[index]['id'],
                            qty: _posts[index]['quantity'] ?? "-",
                            image: _posts[index]['images'] ?? "-",
                          );
                        }),
                  ),

                  // when the _loadMore function is running
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  // When nothing else to load
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 40),
                      color: Main_Color,
                      child: const Center(
                        child: Text('You have fetched all of the products'),
                      ),
                    ),
                ],
              ),
      )),
    );
  }

  var PRODUCTS = [];

  // var pr;

  // getPrice(i) async {
  //   pr = await setPrice(i);
  //   return pr;
  // }

  // setPrice(pro_id) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? company_id = prefs.getInt('company_id');
  //   int? salesman_id = prefs.getInt('salesman_id');
  //   var url =
  //       'http://yaghco.website/quds_laravel/api/check_invoiceproducts/${company_id.toString()}/${salesman_id.toString()}/${widget.id}/$pro_id';
  //   var response = await http.get(Uri.parse(url));
  //   var res = jsonDecode(response.body);
  //   if (res["invoiceproducts"].length == 0) {
  //     return "0";
  //   } else {
  //     return res["invoiceproducts"][0]["p_price"];
  //   }
  // }

  List prices = [];

  searchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    String? code_price = prefs.getString('price_code');
    try {
      var url =
          'https://yaghco.website/quds_laravel/api/search_products/${idController.text}/${company_id.toString()}/${salesman_id.toString()}/${widget.id.toString()}/${code_price}';
      var response = await http.get(Uri.parse(url));
      var res = jsonDecode(response.body)["products"];
      setState(() {
        _posts = res;
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }
  }

  // At the beginning, we fetch the first 20 posts
  int _page = 0;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  List _posts = [];

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    String? code_price = prefs.getString('price_code');
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      var url = widget.category_id != "all"
          ? "https://yaghco.website/quds_laravel/api/products/${company_id.toString()}/${widget.category_id}/${salesman_id.toString()}/${widget.id.toString()}/${code_price}?page=$_page"
          : "https://yaghco.website/quds_laravel/api/allProducts/${company_id.toString()}/${salesman_id.toString()}/${widget.id.toString()}/${code_price}?page=$_page";
      final res = await http.get(Uri.parse(url));
      setState(() {
        _posts = json.decode(res.body)["products"]["data"];
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? company_id = prefs.getInt('company_id');
    int? salesman_id = prefs.getInt('salesman_id');
    String? code_price = prefs.getString('price_code');
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller!.position.extentAfter < 100) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1

      try {
        var url = widget.category_id != "all"
            ? "https://yaghco.website/quds_laravel/api/products/${company_id.toString()}/${widget.category_id}/${salesman_id.toString()}/${widget.id.toString()}/${code_price}?page=$_page"
            : "https://yaghco.website/quds_laravel/api/allProducts/${company_id.toString()}/${salesman_id.toString()}/${widget.id.toString()}/${code_price}?page=$_page";
        final res = await http.get(Uri.parse(url));

        final List fetchedPosts = json.decode(res.body)["products"]["data"];
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  ScrollController? _controller;

  @override
  void dispose() {
    _controller?.removeListener(_loadMore);
    super.dispose();
  }
}