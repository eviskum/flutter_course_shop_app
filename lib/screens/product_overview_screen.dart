import 'package:flutter/material.dart';
import 'package:flutter_course_shop_app/providers/cart.dart';
import 'package:flutter_course_shop_app/providers/products_provider.dart';
import 'package:flutter_course_shop_app/screens/cart_screen.dart';
import 'package:flutter_course_shop_app/widgets/app_drawer.dart';
import 'package:flutter_course_shop_app/widgets/badge.dart';
import 'package:flutter_course_shop_app/widgets/product_overview_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { favorites, all }

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton<FilterOptions>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              const PopupMenuItem(child: Text('Only Favorites'), value: FilterOptions.favorites),
              const PopupMenuItem(child: Text('Show All'), value: FilterOptions.all),
            ],
            onSelected: (FilterOptions selectedValue) {
              products.setShowFavorites(selectedValue == FilterOptions.favorites);
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(Icons.shopping_cart)),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: const ProductOverviewGrid(),
    );
  }
}
