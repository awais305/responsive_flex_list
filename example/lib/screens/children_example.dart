import 'package:flutter/material.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

/// Basic example with predefined children
///
class ChildrenExample extends StatelessWidget {
  const ChildrenExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Children Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic ResponsiveFlexList',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Using predefined child widgets with automatic responsive behavior.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ResponsiveFlexList(
                animationType: ResponsiveAnimationType.slide,
                animationFlow: AnimationFlow.individual,
                children: List.generate(
                  12,
                  (index) => _buildColorCard(
                    'Item ${index + 1}',
                    Colors.primaries[index % Colors.primaries.length],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper method to build colored cards
Widget _buildColorCard(String title, Color color) {
  return Container(
    height: 100,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.withValues(alpha: 0.7), color],
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}
