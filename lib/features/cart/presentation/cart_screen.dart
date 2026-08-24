import 'package:bhm_supermarket/core/widgets/app_page_header.dart';
import 'package:bhm_supermarket/features/navigation/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../ads/models/offer_model.dart';
import '../../ads/providers/offers_provider.dart';
import '../providers/cart_provider.dart';
import '../../auth/utils/auth_gate.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _synced = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_synced && mounted) {
        _synced = true;

        await context.read<CartProvider>().loadFromServer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final offers = context.watch<OffersProvider>();
    final giftRewards = offers.giftRewardsFor(
      cart.items.map(
        (item) => OfferCartLine(
          productId: item.product.id,
          unitId: item.selectedUnit.id,
          quantity: item.quantity,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppPageHeader(
        title: 'السلة',
        showBack: false,
        actions: [
          if (cart.isNotEmpty)
            TextButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text('تفريغ السلة'),
                  content: const Text('هل تريد حذف جميع المنتجات؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await cart.clear();
                      },
                      child: const Text(
                        'حذف',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
              icon: const Icon(
                Icons.delete_outline,
                size: 18,
                color: AppColors.error,
              ),
              label: const Text(
                'تفريغ',
                style: TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🛒', style: TextStyle(fontSize: 54)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'السلة فارغة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'أضف منتجات من الصفحة الرئيسية',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<NavigationProvider>().changeTab(0);
                    },
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('تسوق الآن'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Items list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    itemCount: cart.items.length + giftRewards.length,
                    itemBuilder: (context, index) {
                      if (index >= cart.items.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _GiftRewardCard(
                            reward: giftRewards[index - cart.items.length],
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CartItemCard(
                          item: cart.items[index],
                          onIncrease: () async {
                            await cart.increase(index);
                          },
                          onDecrease: () async {
                            await cart.decrease(index);
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Summary card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      //ملخص الطلب من هنا
                      _SummaryRow(
                        'المجموع',
                        '${cart.originalSubtotal.toStringAsFixed(0)} ر.ي',
                      ),

                      if (cart.offerDiscount > 0) ...[
                        const SizedBox(height: 8),
                        _SummaryRow(
                          'الخصم',
                          '-${cart.offerDiscount.toStringAsFixed(0)} ر.ي',
                          valueColor: AppColors.success,
                        ),
                      ],

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'إجمالي المنتجات',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${cart.subtotal.toStringAsFixed(0)} ر.ي',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          AuthGate.check(
                            context,
                            destination: AppRoutes.checkout,
                            onAuthenticated: () {
                              context.push(AppRoutes.checkout);
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 16,
                        ),
                        label: const Text('متابعة إتمام الطلب'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          minimumSize: const Size(double.infinity, 52),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
          ),
        ],
      );
}

class _GiftRewardCard extends StatelessWidget {
  final GiftRewardModel reward;

  const _GiftRewardCard({required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard_rounded, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'هدية مجانية',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text('${reward.gift.productName} × ${reward.quantity}'),
              ],
            ),
          ),
          const Text(
            '0 ر.ي',
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
