import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final box = Hive.box('porganizer');
  Map data = {0: 0};
  final weekdayLabels = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

  void load() async {
    final rawData = box.get('data', defaultValue: {}) as Map;
    setState(() => data = rawData);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    final today = weekdayLabels[DateTime.now().weekday - 1];
    print(today);
    return Scaffold(
      appBar: AppBar(title: Text('POrganizer')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(keys: ['data']),
        builder: (context, Box box, child) {
          if (data.containsKey(0)) {
            return CircularProgressIndicator();
          }

          if (data.isEmpty) {
            return Center(child: Text('No data'));
          }

          Map template = data['template'];
          late Map todayData;
          if (template.containsKey(today)) {
            todayData = data[today] ?? {'stunden': template[today]['stunden']};
          } else {
            todayData = {};
          }
          print(todayData);
          var controlles = [
            for (var _ in todayData['stunden'].keys) TextEditingController(),
          ];

          return Center(
            child: Column(
              children: [
                for (var stunde in todayData['stunden'].keys)
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: TextField(
                          controller: controlles[stunde - 1],
                          decoration: InputDecoration(
                            filled: true,
                            label: Text('$stunde'),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
