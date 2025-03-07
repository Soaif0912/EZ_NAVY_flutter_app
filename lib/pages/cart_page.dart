import 'package:ez_navy_app/routes/routes.dart';
import 'package:ez_navy_app/routes/routes_names.dart';
import 'package:ez_navy_app/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double height = size.height;
    double width = size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CommonAppBar(iscartPage: true, title: 'Cart',),
      ),
      body: const SingleChildScrollView(
        child: Center(child: Text('Cart Page')),
      ),
    );
  }
}
