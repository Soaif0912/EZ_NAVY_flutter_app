import 'package:ez_navy_app/constant/api_url.dart';
import 'package:ez_navy_app/global_data/global_data.dart';
import 'package:ez_navy_app/model/product_model/product_model.dart';
import 'package:ez_navy_app/services/api/http_services.dart';
import 'package:ez_navy_app/utils/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductPageController extends GetxController {

  HttpService httpService = HttpService();

  var products = <ProductModel>[].obs;
  var userCartList = <Map>[].obs;
  var cartCount = 0.obs;
  var categories = <String>[].obs;
  var isLoading = false.obs;
  var selectedCategory = Rxn<String>();
  var sortOrder = 'asc'.obs;
  var searchQuery = ''.obs;
  final currentUserId = GlobalDataManager().getUserId();
  
  // Search Controller
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    fetchuserCart();
    fetchProducts();
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    if (isLoading.value) return;
    isLoading.value = true;

    const baseUrl = 'https://fakestoreapi.com/products';
    final url = selectedCategory.value != null
        ? '$baseUrl/category/${selectedCategory.value}?sort=${sortOrder.value}'
        : '$baseUrl?sort=${sortOrder.value}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var fetchedProducts = json.decode(response.body);

      if(fetchedProducts is List){
        print('product length ${fetchedProducts.length}');
        products.value = fetchedProducts.map((json)=> ProductModel.fromJson(json)).toList();
      }

    } else {
      Get.snackbar("Error", "Failed to load products");
    }
    isLoading.value = false;
  }

  Future<void> fetchCategories() async {
    final url = 'https://fakestoreapi.com/products/categories';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      categories.value = List<String>.from(json.decode(response.body));
    } else {
      showError("Failed to load categories");
    }
  }

  void setCategory(String? category) {
    selectedCategory.value = category;
    fetchProducts();
  }

  void changeSortOrder(String order) {
    sortOrder.value = order;
    fetchProducts();
  }

  // Fetch userCart
  Future<void> fetchuserCart() async{
    final allUsreCartDetails = await httpService.apiGetRequest(ApiUrls.baseUrl+ApiUrls.userCartDatails);
    if(allUsreCartDetails.status == true){
      
      print('fetching userCartList success =>>');
      print(allUsreCartDetails.data);

      List<Map<String, dynamic>> filteredCart = List<Map<String, dynamic>>.from(allUsreCartDetails.data.where((user)=> user['userId'] == currentUserId).toList());
      userCartList.value = filteredCart;
      print('filtered cart ${filteredCart}');

      cartCount.value = 0;
      filteredCart.forEach((item) {
        cartCount.value += item['productQuantity'] as int; 
      });

      print('Total cart count ${cartCount}');
    }
  }

  bool checkProductInCart(int id){
    return userCartList.any((product) => product['productId'] == id);
  }

  // Add to cart function
  Future<void> addTocart(int id) async{
    final productId = id;
    bool productAlreaduInCart = false;
    Map<String, dynamic> productInCart={};
    String productCartId = '0';

    final allUsreCartDetails = await httpService.apiGetRequest(ApiUrls.baseUrl+ApiUrls.userCartDatails);

    if(allUsreCartDetails.status == true){
      print('product ID: $productId');
      print(allUsreCartDetails.data);

      for(var user in allUsreCartDetails.data){
        if( user['userId'] == currentUserId && user['productId'] == productId ){
          productAlreaduInCart = true;
          print('order ID: ${user['id']}');

          productCartId = user['id'].toString();
          productInCart = {
            "userId": currentUserId,
            "productId": productId,
            "productQuantity": user['productQuantity'] + 1,
          };
        }
      }

      if(productAlreaduInCart == false){
        Map<String, dynamic> bodyData = {
          "userId": currentUserId,
          "productId": productId,
          "productQuantity": 1,
        };
        final addToCartRequest = await httpService.apiPostRequest(ApiUrls.baseUrl+ApiUrls.userCartDatails, bodyData);
        if(addToCartRequest.status == true){
          print('add to cart details: ${addToCartRequest.data}');
          cartCount += 1;
          fetchuserCart();
        }else{
          showError(addToCartRequest.errorMessage!);
        }
      }else{
        final finalUrl = '${ApiUrls.baseUrl}${ApiUrls.userCartDatails}/$productCartId';
        print('update URL: ${finalUrl}');

        final updateCartRequest = await httpService.apiPutRequest(finalUrl, productInCart);
        if(updateCartRequest.status == true){
          print('update cart details: ${updateCartRequest.data}');
          cartCount += 1;
          fetchuserCart();
        }else{
          showError(updateCartRequest.errorMessage!);
        }
      }

    }

  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
}
