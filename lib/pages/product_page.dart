import 'package:ez_navy_app/controller/product_page_controller/product_page_controller.dart';
import 'package:ez_navy_app/model/product_model/product_model.dart';
import 'package:ez_navy_app/routes/routes.dart';
import 'package:ez_navy_app/routes/routes_names.dart';
import 'package:ez_navy_app/utils/core.dart';
import 'package:ez_navy_app/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../widgets/custom_input_widget.dart';

class ProductPage extends StatelessWidget {
  final ProductPageController controller = Get.put(ProductPageController());

  ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double height = size.height;
    double width = size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: CommonAppBar(
            iscartPage: false,
            title: 'Products',
            text: 'Product & Customer Credentials',
          )),
      body: Padding(
        padding: EdgeInsets.only(
          left: width * 0.05,
          right: width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row

            Padding(
              padding: EdgeInsets.only(top: height * 0.020),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomInputWidget(
                    controller: controller.searchController,
                    hintText: 'Search By',
                    height: height * 0.050,
                    width: width * 0.66,
                    inputIcon: Icons.search,
                    // onChanged: (query) {
                    //   controller.updateSearchQuery(query);
                    // },
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('Ascending'),
                                onTap: () {
                                  controller.changeSortOrder('asc');
                                  Get.back();
                                },
                              ),
                              ListTile(
                                title: const Text('Descending'),
                                onTap: () {
                                  controller.changeSortOrder('desc');
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: SvgPicture.asset('assets/images/sorting.svg'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          color: Colors.white,
                          child: Obx(() {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.categories.length,
                              itemBuilder: (context, index) {
                                final category = controller.categories[index];
                                return ListTile(
                                  title: Text(category),
                                  onTap: () {
                                    controller.setCategory(category);
                                    Get.back();
                                  },
                                );
                              },
                            );
                          }),
                        ),
                      );
                    },
                    child: SvgPicture.asset('assets/images/filter.svg'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Category Filter
            Obx(() {
              if (controller.selectedCategory.value != null) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Category: ${controller.selectedCategory.value}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.setCategory(null);
                      },
                      child: Text('X  Clear Filter'),
                    ),
                  ],
                );
              }
              return SizedBox();
            }),

            Expanded(
              child: Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.50,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: controller.products.length,
                        itemBuilder: (context, index) {
                          final product = controller.products[index];
                          return ProductCard(product: product);
                        },
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final ProductPageController controller = Get.put(ProductPageController());
  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                pushNamed(
                    routeName: RoutesName.productDetailsPage,
                    arguments: ProductArgument(productID: product.id));
              },
              child: Center(
                  child: Image.network(product.image,
                      height: 100, fit: BoxFit.cover)),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(
              height: 20,
            ),
            Text('\$${product.price}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return
               Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:  
                      controller.checkProductInCart(product.id)
                      ?
                      Row(
                        children: [
                          InkWell(
                            onTap: ()=> controller.decreaseProductCount(product.id),
                            child: Text('-', style: TextStyle(fontSize: 30),),
                          ),
                          Spacer(),
                          Text('${controller.checkPoductCount(product.id)}', style: TextStyle(fontSize: 20)),
                          Spacer(),
                          InkWell(
                            onTap: ()=> controller.addTocart(product.id),
                            child: Text('+', style: TextStyle(fontSize: 25)),
                          )
                        ],
                      ) :
                      InkWell(
                        onTap: ()=> controller.addTocart(product.id),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Text('Add to cart',
                          style: TextStyle(
                            color: Color.fromRGBO(11, 34, 62, 1),
                            fontSize: 20,
                          )),
                        ),
                      ),
                    );
                  
            }),
          ],
        ),
      ),
    );
  }
}
