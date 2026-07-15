import 'package:flutter/material.dart';

import '../models/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(address.title),

        subtitle: Text('${address.city} - ${address.district}'),

        trailing: address.isDefault
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
      ),
    );
  }
}
