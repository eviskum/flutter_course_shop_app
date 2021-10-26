import 'package:flutter/material.dart';
import 'package:flutter_course_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  // final String title;

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(id);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      // body: SingleChildScrollView(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(tag: loadedProduct.id, child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover)),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // SizedBox(
                //   height: 300,
                //   width: double.infinity,
                //   child: Hero(tag: loadedProduct.id, child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover)),
                // ),
                const SizedBox(height: 10),
                Text('€ ${loadedProduct.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 20)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(loadedProduct.description, textAlign: TextAlign.center, softWrap: true),
                ),
              ],
            ),
          ),
        ],
        // child: Column(
        //   children: [
        //     SizedBox(
        //       height: 300,
        //       width: double.infinity,
        //       child: Hero(tag: loadedProduct.id, child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover)),
        //     ),
        //     const SizedBox(height: 10),
        //     Text('€ ${loadedProduct.price.toStringAsFixed(2)}',
        //         style: const TextStyle(color: Colors.grey, fontSize: 20)),
        //     const SizedBox(height: 10),
        //     Container(
        //       padding: const EdgeInsets.symmetric(horizontal: 10),
        //       width: double.infinity,
        //       child: Text(loadedProduct.description, textAlign: TextAlign.center, softWrap: true),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
