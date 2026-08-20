import 'package:bhm_supermarket/features/orders/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_page_header.dart';
import '../../../app/router/app_routes.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<OrdersProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppPageHeader(
        title: "طلباتي",
        fallbackRoute: AppRoutes.home,
      ),
      body: Consumer<OrdersProvider>(
        builder: (_, provider, __) {
          if (provider.loading) {
            return const LoadingWidget();
          }

          if (provider.orders.isEmpty) {
            return const Center(child: Text("لا توجد طلبات"));
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: ListView.builder(
              itemCount: provider.orders.length,
              itemBuilder: (_, index) {
                return OrderCard(provider.orders[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
