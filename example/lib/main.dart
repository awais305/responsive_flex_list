import 'package:example/screens/masonry_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/builder_example.dart';
import 'screens/children_example.dart';
import 'screens/separator_example.dart';
import 'screens/test.dart';

void main() {
  runApp(const MyApp());

  // debugProfileBuildsEnabled = true;
  // debugProfileBuildsEnabledUserWidgets = true;
  // debugPrintRebuildDirtyWidgets = true;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [Locale('en', 'US'), Locale('ur', 'PK')],

      title: 'ResponsiveFlexList Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ResponsiveFlexListDemo(),
      // home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GroupedListView<TransactionModel>(
        items: transactions,
        groupBy: (transaction) {
          return '${transaction.date.month} ${transaction.date.year}';
        },
        subGroupBy: (transaction) {
          return '${transaction.date.year}/${transaction.date.month}/${transaction.date.day}';
        },
        firstGroupLabel: 'This Month',
        groupHeaderBuilder: (groupKey, items) {
          final total = items.fold(
            0.0,
            (sum, t) => sum + double.parse(t.amount),
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  groupKey,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 23),
                ),
              ],
            ),
          );
        },
        subGroupHeaderBuilder: (subGroupKey, items) {
          final dailyTotal = items.fold(
            0.0,
            (sum, t) => sum + double.parse(t.amount),
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subGroupKey,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (items.length > 1)
                  Text(
                    '\$${dailyTotal.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          );
        },
        itemBuilder: (transaction, itemsInSubGroup) {
          return ListTile(
            title: Text(transaction.title),
            subtitle: Text(transaction.description),
            trailing: Text('\$${transaction.amount}'),
          );
        },
      ),
    );
  }
}

class ResponsiveFlexListDemo extends StatelessWidget {
  const ResponsiveFlexListDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ResponsiveFlexList Demo')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChildrenExample()),
                );
              },
              child: Text('Children Example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BuilderExample()),
                );
              },
              child: Text('Builder Example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SeparatorExample()),
                );
              },
              child: Text('Separator Example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MasonryExample()),
                );
              },
              child: Text('Masonry Example'),
            ),
          ],
        ),
      ),
    );
  }
}
