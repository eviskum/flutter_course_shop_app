import 'package:flutter/material.dart';
import 'package:flutter_course_shop_app/providers/cart.dart';
import 'package:flutter_course_shop_app/providers/orders.dart';
import 'package:flutter_course_shop_app/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 20)),
                  // SizedBox(width: 10),
                  const Spacer(),
                  Chip(
                    label: Text(
                      cart.totalSum.toStringAsFixed(2),
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6!.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(cart.itemsList, cart.totalSum);
                        cart.clear();
                      },
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, idx) => CartItemWidget(
                cart.itemsList[idx].id,
                cart.keysList[idx],
                cart.itemsList[idx].title,
                cart.itemsList[idx].price,
                cart.itemsList[idx].quantity,
              ),
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
