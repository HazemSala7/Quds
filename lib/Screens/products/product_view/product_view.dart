import 'package:flutter/material.dart';
import 'package:flutter_application_1/Server/server.dart';

class ProductView extends StatelessWidget {
  String image;
  ProductView({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Main_Color,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey),
                    child: Center(
                        child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
