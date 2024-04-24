import 'package:flutter/material.dart';

class CapsuleName extends StatelessWidget {
  final String name;
  const CapsuleName({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        name,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
