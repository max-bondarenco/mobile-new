import 'package:flutter/material.dart';
import '../utils.dart';

class Screen42 extends StatefulWidget {
  const Screen42({super.key});

  @override
  State<Screen42> createState() => _Screen42State();
}

class _Screen42State extends State<Screen42> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  void _calculate() {
    final inputs = {'S': _controller.text};
    setState(() {
      _result = calculateResultsT42(inputs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 4.2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'S (Ом)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
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
