import 'package:flutter/material.dart';
import 'package:flutter_course_shop_app/providers/products_provider.dart';
import 'package:flutter_course_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_course_shop_app/widgets/app_drawer.dart';
import 'package:flutter_course_shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Products productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (ctx, idx) => Column(
            children: [
              UserProductItem(
                  productsData.items[idx].id, productsData.items[idx].title, productsData.items[idx].imageUrl, (id) {
                productsData.deleteProduct(id);
              }),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
