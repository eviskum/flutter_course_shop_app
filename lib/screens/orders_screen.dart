import 'package:flutter/material.dart';
import 'package:flutter_course_shop_app/providers/orders.dart';
import 'package:flutter_course_shop_app/widgets/app_drawer.dart';
import 'package:flutter_course_shop_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, idx) => OrderItemWidget(ordersData.orders[idx]),
      ),
    );
  }
}
