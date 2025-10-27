import 'package:example/screens/masonry_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

import 'screens/builder_example.dart';
import 'screens/children_example.dart';
import 'screens/separator_example.dart';

void main() {
  ResponsiveConfig.init(breakpoints: Breakpoints.defaultBreakpoints);
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
