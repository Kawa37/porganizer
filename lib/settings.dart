import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final box = Hive.box('porganizer');

  final List<String> dayOpts = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'So', 'Sa'];
  Set<String> checkedDays = {};
  List selectedPeriods = [];

  void saveData() {
    var data = box.get('data', defaultValue: {}) as Map;

    final theData = {
      for (String e in checkedDays)
        e: {
          'stunden': {
            for (
              int period = 1;
              period <=
                  selectedPeriods.lastWhere(
                    (m) => m.containsKey(e),
                    orElse: () => {e: 0},
                  )[e];
              period++
            )
              period: "",
          },
        },
    };
    data['template'] = theData;
    box.put('data', data);
    print(data);
  }

  @override
  void initState() {
    super.initState();

    final data = box.get('data', defaultValue: {}) as Map;
    print(data);
    if (data.containsKey('template')) {
      Map template = data['template'];
      setState(() {
        checkedDays = template.keys.cast<String>().toSet();
        selectedPeriods = [
          for (var day in template.keys.cast<String>())
            {day: template[day]['stunden'].length},
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(selectedPeriods);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: screenHeight / 2),
        child: Column(
          children: [
            ...dayOpts.map(
              (opt) => Column(
                children: [
                  CheckboxListTile(
                    value: checkedDays.contains(opt),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          checkedDays.add(opt);
                        } else {
                          checkedDays.remove(opt);
                        }
                      });
                    },
                    title: Text(opt),
                  ),
                  if (checkedDays.contains(opt))
                    DropdownMenu(
                      hintText: 'Stunden',

                      onSelected: (idx) {
                        setState(() => selectedPeriods.add({opt: idx}));
                      },
                      dropdownMenuEntries: [
                        for (int i = 0; i < 8; i++)
                          DropdownMenuEntry(value: i, label: '$i'),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                saveData();
              },
              child: Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
