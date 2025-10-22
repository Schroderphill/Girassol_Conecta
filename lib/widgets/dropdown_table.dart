import 'package:flutter/material.dart';

class DropdownTable extends StatelessWidget {
  final String title;
  final List<String> options;
  final void Function(String) onSelected;

  const DropdownTable({
    super.key,
    required this.title,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          hint: const Text('Selecione'),
          items: options
              .map((opt) => DropdownMenuItem(
                    value: opt,
                    child: Text(opt),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) onSelected(value);
          },
        ),
      ],
    );
  }
}
