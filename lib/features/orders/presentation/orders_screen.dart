import 'package:bhm_supermarket/app/router/app_router.dart';
import 'package:bhm_supermarket/features/orders/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OrdersProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.push('/checkout_screen')),
        title: const Text("طلباتي"),
      ),
      body: Consumer<OrdersProvider>(
        builder: (_, provider, __) {
          if (provider.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.orders.isEmpty) {
            return const Center(
              child: Text("لا توجد طلبات"),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: ListView.builder(
              itemCount: provider.orders.length,
              itemBuilder: (_, index) {
                return OrderCard(
                  provider.orders[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
