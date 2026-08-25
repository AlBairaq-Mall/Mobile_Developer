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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<OrdersProvider>().loadOrders();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OrdersProvider>().loadMore();
    }
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

          if (provider.error != null && provider.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.refresh,
                    child: const Text("إعادة المحاولة"),
                  ),
                ],
              ),
            );
          }

          if (provider.orders.isEmpty) {
            return const Center(child: Text("لا توجد طلبات"));
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: provider.orders.length + (provider.loadingMore ? 1 : 0),
              itemBuilder: (_, index) {
                if (index == provider.orders.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return OrderCard(provider.orders[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
