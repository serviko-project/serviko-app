import 'package:flutter/material.dart';
import 'package:serviko_app/core/widgets/role_switch_tile.dart';

// Profile Screen of Provider
class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [const Spacer(), const RoleSwitchTile(), const Spacer()],
        ),
      ),
    );
  }
}
