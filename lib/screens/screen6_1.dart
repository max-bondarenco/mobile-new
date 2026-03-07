import 'package:flutter/material.dart';
import '../utils.dart';

class Screen61 extends StatefulWidget {
  const Screen61({super.key});

  @override
  State<Screen61> createState() => _Screen61State();
}

class _Screen61State extends State<Screen61> {
  final Map<String, TextEditingController> _controllers = {};
  String _result = '';

  @override
  void initState() {
    super.initState();
    const inputFields = ['Pa', 'o1', 'o2', 'C'];
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
      _result = calculateResultsT61(inputs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 6.1'),
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
                        labelText: key == 'C'
                            ? 'C (грн/МВт*год)'
                            : '$key (${getUnit(key)})',
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
