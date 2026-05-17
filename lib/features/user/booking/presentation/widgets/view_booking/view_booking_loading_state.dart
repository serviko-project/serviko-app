import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewBookingLoadingState extends StatelessWidget {
  const ViewBookingLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 60, width: double.infinity, color: Colors.white),
            const SizedBox(height: 24),
            Container(height: 20, width: double.infinity, color: Colors.white),
            const SizedBox(height: 16),
            Container(height: 20, width: double.infinity, color: Colors.white),
            const SizedBox(height: 24),
            Container(height: 150, width: double.infinity, color: Colors.white),
            const SizedBox(height: 24),
            Container(height: 100, width: double.infinity, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
