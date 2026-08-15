import 'package:flutter/material.dart';
import 'delivery_home_screen.dart';
import 'delivery_history_screen.dart';
import 'delivery_profile_screen.dart';
import 'delivery_earnings_screen.dart';

class DeliveryMainScreen extends StatefulWidget {
  const DeliveryMainScreen({super.key});
  @override
  State<DeliveryMainScreen> createState() => _DeliveryMainScreenState();
}

class _DeliveryMainScreenState extends State<DeliveryMainScreen> {
  int _index = 0;

  final _screens = const [
    DeliveryHomeScreen(),
    DeliveryHistoryScreen(),
    DeliveryEarningsScreen(),
    DeliveryProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.blue.shade700,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'السجل',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'الأرباح',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
