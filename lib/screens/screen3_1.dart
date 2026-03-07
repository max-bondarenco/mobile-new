import 'package:flutter/material.dart';
import '../utils.dart';

class Screen31 extends StatefulWidget {
  const Screen31({super.key});

  @override
  State<Screen31> createState() => _Screen31State();
}

class _Screen31State extends State<Screen31> {
  final Map<String, TextEditingController> _controllers = {};
  String _result = '';

  @override
  void initState() {
    super.initState();
    const inputFields = ['P', 'o1', 'o2', 'Price'];
    for (final field in inputFields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    final inputs = <String, String>{};
    _controllers.forEach((key, controller) {
      inputs[key] = controller.text;
    });
    setState(() {
      _result = calculateResultsT31(inputs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 3.1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _controllers.entries.map((entry) {
                  final key = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: '$key (${getUnit(key)})',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 16),
            Text(
              _result,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
