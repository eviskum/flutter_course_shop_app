import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_course_shop_app/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;
  const OrderItemWidget(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('€ ${widget.order.amount}'),
            subtitle: Text(DateFormat('dd-MM-yyyy, hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more)),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20 + 20, 100),
              child: ListView(
                children: widget.order.products
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${e.quantity} x €${e.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
