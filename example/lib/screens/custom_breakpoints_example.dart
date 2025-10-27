import 'package:flutter/material.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

/// Custom breakpoints example
///
class CustomBreakpointsExample extends StatelessWidget {
  const CustomBreakpointsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final customBreakpoints = Breakpoints(
      tablet: 800,
      laptop: 1200,
      tabletColumns: 4,
      laptopColumns: 6,
      desktopColumns: 8,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Example with breakpoints')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Breakpoints Example',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tablet: 800px (4 cols), Laptop: 1200px (6 cols), Desktop: 8 cols',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Resize window to see responsive behavior',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Screen width: ${MediaQuery.of(context).size.width.toInt()}px',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ResponsiveFlexList.builder(
                animationFlow: AnimationFlow.byRow,
                customAnimationBuilder: (context, child, animation) {
                  return RotationTransition(
                    turns: Tween<double>(
                      begin: 0.95,
                      end: 1.0,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                items: List.generate(20, (index) => 'Item ${index + 1}'),
                breakpoints: customBreakpoints,
                itemBuilder: (item, index) {
                  if (item == null) return const SizedBox.shrink();

                  return Container(
                    height: 80,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.purple[300]!, Colors.purple[600]!],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple[200]!.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
