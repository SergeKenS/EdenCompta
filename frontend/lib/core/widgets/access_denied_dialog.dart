import 'package:flutter/material.dart';

class AccessDeniedDialog extends StatelessWidget {
  const AccessDeniedDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const AccessDeniedDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.lock_outline,
            color: Colors.red[600],
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Accès Refusé',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: const Text(
        'Vous n\'avez pas accès à cette page.',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
