import 'package:bhm_supermarket/features/orders/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import '../../../core/design_system/components/feedback/app_empty_state.dart';
import '../../../core/design_system/components/feedback/app_error_state.dart';
import '../../../core/design_system/components/feedback/app_loading.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_page_header.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/design_system/patterns/app_responsive.dart';
import '../../../app/theme/app_spacing.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const AppPageHeader(
        title: "طلباتي",
        fallbackRoute: AppRoutes.home,
      ),
      body: SafeArea(
        child: Consumer<OrdersProvider>(
          builder: (_, provider, __) {
            if (provider.loading) {
              return const Center(child: AppLoading());
            }

            if (provider.error != null && provider.orders.isEmpty) {
              return Center(
                child: AppErrorState(
                  message: provider.error!,
                  onRetry: provider.refresh,
                ),
              );
            }

            if (provider.orders.isEmpty) {
              return const Center(
                child: AppEmptyState(
                  title: "لا توجد طلبات",
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: provider.refresh,
              color: colorScheme.primary,
              child: AppConstrainedContent(
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  itemCount: provider.orders.length + (provider.loadingMore ? 1 : 0),
                  itemBuilder: (_, index) {
                    if (index == provider.orders.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                        child: Center(child: AppLoading(size: 24)),
                      );
                    }
                    return OrderCard(provider.orders[index]);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
