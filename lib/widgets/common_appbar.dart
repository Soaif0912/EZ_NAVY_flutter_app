import 'package:ez_navy_app/controller/product_page_controller/product_page_controller.dart';
import 'package:ez_navy_app/global_data/global_data.dart';
import 'package:ez_navy_app/routes/routes.dart';
import 'package:ez_navy_app/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatelessWidget {
  final bool iscartPage;
  final String title;
  final String? text;

  CommonAppBar({super.key, required this.iscartPage, required this.title, this.text});

      final ProductPageController controller = Get.put(ProductPageController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double height = size.height;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                if (iscartPage) ...[
                  GestureDetector(
                    onTap: () => pop(),
                    child: const Icon(Icons.arrow_back, size: 30),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: Color.fromRGBO(11, 34, 62, 1),
                  ),
                ),
                if (!iscartPage) ...[
                  const Spacer(),
                  GestureDetector(
                    child: SizedBox(
                      height: 30,
                      child: SvgPicture.asset('assets/images/sign-out-alt.svg'),
                    ),
                    onTap: () {
                      Get.defaultDialog(
                        title: "Log Out",
                        content: const Text("Are you sure you want to logout?"),
                        textConfirm: "Yes",
                        textCancel: "No",
                        onConfirm: () {
                          GlobalDataManager().removeUserId();
                          pushNamed(routeName: RoutesName.loginPage);
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  
                  GestureDetector(
                    onTap: () => pushNamed(routeName: RoutesName.cartPage),
                    child: Badge(
                      label: Obx(()=> Text('${controller.cartCount}')),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 30,
                        color: Color.fromRGBO(11, 34, 62, 1),
                      ),
                    ),
                  ),
                ]
              ],
            ),
            if (!iscartPage && text != null) ...[
              Padding(
                padding: EdgeInsets.only(top: height * 0.01),
                child: Text(
                  text!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color.fromRGBO(75, 75, 75, 1),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
