import 'package:flutter/material.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

/// Builder example with dynamic content
///
class BuilderExample extends StatelessWidget {
  const BuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Builder Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Builder Pattern',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Building widgets dynamically from a data list.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ResponsiveFlexList.builder(
                animationFlow: AnimationFlow.byRow,
                staggerDelay: Duration(milliseconds: 300),
                animationType: ResponsiveAnimationType.slideDown,
                items: fruits,
                itemBuilder: (context, index) {
                  return _buildCard(fruits[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sample data for demonstrations
final List<String> fruits = [
  '🍎 Apple',
  '🍌 Banana',
  '🍒 Cherry',
  '📅 Date',
  '🫐 Elderberry',
  '🍇 Grapes',
  '🥝 Kiwi',
  '🍋 Lemon',
  '🥭 Mango',
  '🍊 Orange',
  '🍑 Peach',
  '🍐 Pear',
  '🍍 Pineapple',
  '🍓 Strawberry',
  '🍉 Watermelon',
];

Widget _buildCard(String fruit, int index) {
  return Card(
    elevation: 2,
    child: Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            fruit,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Index: $index',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}
