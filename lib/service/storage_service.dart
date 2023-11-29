import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/product.dart';

class StorageService {
  static const String key = 'products';

  static Future<List<Product>> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(key)) {
      var data = prefs.getString(key);
      if (data != null) {
        Iterable decoded = jsonDecode(data);
        return List<Product>.from(decoded.map((e) => Product.fromJson(e)));
      }
    }

    return [];
  }

  static Future<void> saveProducts(List<Product> products) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var encoded = jsonEncode(products);
    prefs.setString(key, encoded);
  }

  static Map<String, List<Product>> groupProductsByCategory(
      List<Product> products) {
    Map<String, List<Product>> groupedProducts = {};

    for (var product in products) {
      if (!groupedProducts.containsKey(product.category)) {
        groupedProducts[product.category] = [];
      }
      groupedProducts[product.category]!.add(product);
    }

    return groupedProducts;
  }

  static Future<void> deleteProduct(String productId) async {
    List<Product> products = await getProducts();
    products.removeWhere((product) => product.id == productId);
    saveProducts(products);
  }

}
