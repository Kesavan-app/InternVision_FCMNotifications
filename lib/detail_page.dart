import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final text = args?['title'] ?? 'No Title';
    final message = args?['message'] ?? 'No Message';

    return Scaffold(
      appBar: AppBar(title: Text(text)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
