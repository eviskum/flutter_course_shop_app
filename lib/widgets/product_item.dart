import 'package:flutter/material.dart';
import 'package:flutter_course_shop_app/providers/cart.dart';
import 'package:flutter_course_shop_app/providers/product.dart';
import 'package:flutter_course_shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // const ProductItem(this.id, this.title, this.imageUrl, {Key? key}) : super(key: key);
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context);
    Cart cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
          },
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
              onPressed: () {
                product.toggleFavorite();
              },
              icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).colorScheme.secondary),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Added item to cart',
                      // textAlign: TextAlign.center,
                    ),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSignleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
