import 'package:flutter/material.dart';

class ManualIpDialog extends StatefulWidget {
  const ManualIpDialog({super.key});

  static Future<({String host, String? name})?> show(
    BuildContext context,
  ) {
    return showDialog<({String host, String? name})>(
      context: context,
      builder: (_) => const ManualIpDialog(),
    );
  }

  @override
  State<ManualIpDialog> createState() => _ManualIpDialogState();
}

class _ManualIpDialogState extends State<ManualIpDialog> {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _ipController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String? _validateIp(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Enter an IP address';
    final parts = v.split('.');
    if (parts.length != 4) return 'Invalid IPv4 address';
    for (final p in parts) {
      final n = int.tryParse(p);
      if (n == null || n < 0 || n > 255) return 'Invalid IPv4 address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add TV manually'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _ipController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'TV IP address',
                hintText: '192.168.1.42',
              ),
              validator: _validateIp,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name (optional)',
                hintText: 'Living-room Samsung',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final host = _ipController.text.trim();
            final name = _nameController.text.trim();
            Navigator.of(context).pop((
              host: host,
              name: name.isEmpty ? null : name,
            ));
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
