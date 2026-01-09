import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_flex_list/responsive_flex_list.dart';

import '../main.dart';

class SeparatorExample extends StatefulWidget {
  const SeparatorExample({super.key});

  @override
  State<SeparatorExample> createState() => _SeparatorExampleState();
}

class _SeparatorExampleState extends State<SeparatorExample> {
  MainAxisSeparatorMode mainAxisSeparatorMode = MainAxisSeparatorMode.itemWidth;
  Locale _locale = Locale('en', 'US');

  bool roundRobinLayout = false;

  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;

  fetchAPI() async {
    try {
      var resp = await http.get(Uri.parse('https://dummyjson.com/posts'));

      if (resp.statusCode == 200) {
        posts = List<Map<String, dynamic>>.from(jsonDecode(resp.body)['posts']);
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    fetchAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Separator Example'),
        actions: [
          PopupMenuButton<Locale>(
            initialValue: _locale,
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(Icons.more_vert, color: Colors.black),
            ),
            onSelected: (value) {
              _locale = value;
              _locale == Locale('en', 'US')
                  ? MyApp.of(context).setLocale(const Locale('en', 'US'))
                  : MyApp.of(context).setLocale(const Locale('ur', 'PK'));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Locale('en', 'US'),
                child: Text("English"),
              ),
              const PopupMenuItem(
                value: Locale('ur', 'PK'),
                child: Text("اردو"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (!context.isMobileDevice)
            Wrap(
              spacing: 50,
              children: [
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Round Robin Layout:'),
                    Switch.adaptive(
                      value: roundRobinLayout,
                      onChanged: (value) {
                        setState(() => roundRobinLayout = value);
                      },
                    ),
                  ],
                ),
                if (!roundRobinLayout)
                  Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Type:'),
                      DropdownButton(
                        value: mainAxisSeparatorMode,
                        items: [
                          DropdownMenuItem(
                            value: MainAxisSeparatorMode.fullWidth,
                            child: Text('Full Width'),
                          ),
                          DropdownMenuItem(
                            value: MainAxisSeparatorMode.itemWidth,

                            child: Text('Per Item'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => mainAxisSeparatorMode = value!);
                        },
                      ),
                    ],
                  ),
              ],
            ),
          const SizedBox(height: 16),

          ////
          //////
          ///
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator.adaptive())
                : ResponsiveFlexList.withSeparators(
                    roundRobinLayout: roundRobinLayout,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    animationType: ResponsiveAnimationType.slide,
                    animationFlow: AnimationFlow.byRow,
                    useIntrinsicHeight: true,
                    mainAxisSeparatorMode: mainAxisSeparatorMode,
                    mainAxisSeparator: (rowIndex, totalRows) => Container(
                      height: 2,
                      // color: Colors.grey.shade400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.blue[200]!,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    crossAxisSeparator: (columnIndex, totalColumns) =>
                        Container(
                          width: 2,
                          // color: Colors.grey.shade400,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.blue[200]!,
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                    items: posts,
                    itemBuilder: (item, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              '${index + 1}. ${item['title']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(item['body'], textAlign: TextAlign.justify),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
