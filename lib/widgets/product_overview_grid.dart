import 'package:flutter/material.dart';
import 'package:flutter_course_shop_app/providers/products_provider.dart';
import 'package:flutter_course_shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductOverviewGrid extends StatelessWidget {
  const ProductOverviewGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.showFavorites ? productsData.filteredItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
        value: products[idx],
        // create: (ctx) => products[idx],
        child: const ProductItem(), // (products[idx].id, products[idx].title, products[idx].imageUrl),
      ),
      itemCount: products.length,
    );
  }
}
