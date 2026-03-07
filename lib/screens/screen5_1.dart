import 'package:flutter/material.dart';
import '../utils.dart';

class Screen51 extends StatefulWidget {
  const Screen51({super.key});

  @override
  State<Screen51> createState() => _Screen51State();
}

class _Screen51State extends State<Screen51> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String> _selects = {};
  String _result = '';

  @override
  void initState() {
    super.initState();
    const inputFields = ['n', 'l', 'Za', 'Zp'];
    for (final field in inputFields) {
      _controllers[field] = TextEditingController();
    }
    final selectFields = {
      'line': powerLines.keys.toList(),
      'transformer': transformers.keys.toList(),
      'switch1': switches.keys.toList(),
      'switch2': switches.keys.toList(),
      'sectionSwitch': switches.keys.toList(),
    };
    selectFields.forEach((key, options) {
      _selects[key] = options.first;
    });
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
      _result = calculateResultsT51(inputs, _selects);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 5.1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ..._selects.entries.map((entry) {
                      final key = entry.key;
                      final value = entry.value;
                      final options = key == 'line'
                          ? powerLines.keys.toList()
                          : key == 'transformer'
                              ? transformers.keys.toList()
                              : switches.keys.toList();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DropdownButtonFormField<String>(
                          value: value,
                          decoration: InputDecoration(
                            labelText: key,
                            border: const OutlineInputBorder(),
                          ),
                          items: options.map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selects[key] = newValue!;
                            });
                          },
                        ),
                      );
                    }),
                    ..._controllers.entries.map((entry) {
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
                    }),
                  ],
                ),
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
