import 'package:flutter/material.dart';
import '../utils.dart';

class Screen11 extends StatefulWidget {
  const Screen11({super.key});

  @override
  State<Screen11> createState() => _Screen11State();
}

class _Screen11State extends State<Screen11> {
  final Map<String, String> inputs = {};
  String result = "";

  @override
  void initState() {
    super.initState();
    for (final key in possiblePValues) {
      inputs[key] = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 1.1'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...possiblePValues.map((key) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '$key (%)',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        inputs[key] = value;
                      });
                    },
                  ),
                )),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  result = calculateResultsT11(inputs);
                });
              },
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 16.0),
            Text(
              result,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ],
        ),
      ),
    );
  }
}
