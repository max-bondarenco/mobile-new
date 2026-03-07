import 'package:flutter/material.dart';
import '../utils.dart';

class Screen12 extends StatefulWidget {
  const Screen12({super.key});

  @override
  State<Screen12> createState() => _Screen12State();
}

class _Screen12State extends State<Screen12> {
  final Map<String, String> inputs = {};
  String result = "";

  @override
  void initState() {
    super.initState();
    for (final key in inputValues12) {
      inputs[key] = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 1.2'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...inputValues12.map((key) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '$key (${getUnitChar(key)})',
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
                  result = calculateResultsT12(inputs);
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
