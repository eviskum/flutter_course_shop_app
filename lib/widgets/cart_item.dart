import 'package:flutter/material.dart';
import 'package:flutter_course_shop_app/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String keyId;
  final String title;
  final double price;
  final int quantity;

  const CartItemWidget(this.id, this.keyId, this.title, this.price, this.quantity, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: FittedBox(child: Text('€ $price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('€ ${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(keyId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
    );
  }
}
