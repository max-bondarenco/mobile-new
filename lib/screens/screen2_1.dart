import 'package:flutter/material.dart';
import '../utils.dart';

class Screen21 extends StatefulWidget {
  const Screen21({super.key});

  @override
  State<Screen21> createState() => _Screen21State();
}

class _Screen21State extends State<Screen21> {
  final Map<String, String> inputs = {};
  String result = "";

  @override
  void initState() {
    super.initState();
    for (final key in inputFields21) {
      inputs[key] = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 2.1'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...inputFields21.map((key) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '$key (${getUnitString(key)})',
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
                  result = calculateResultsT21(inputs);
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
