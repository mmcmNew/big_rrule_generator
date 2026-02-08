import 'package:flutter/material.dart';

class NumberListSection extends StatefulWidget {
  final String label;
  final String hint;
  final List<int> values;
  final ValueChanged<List<int>> onChanged;
  final bool allowNegative;

  const NumberListSection({
    super.key,
    required this.label,
    required this.hint,
    required this.values,
    required this.onChanged,
    this.allowNegative = true,
  });

  @override
  State<NumberListSection> createState() => _NumberListSectionState();
}

class _NumberListSectionState extends State<NumberListSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.values));
  }

  @override
  void didUpdateWidget(covariant NumberListSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values) {
      _controller.text = _format(widget.values);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            hintText: widget.hint,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            final parsed = _parse(value);
            widget.onChanged(parsed);
          },
        ),
      ],
    );
  }

  List<int> _parse(String value) {
    if (value.trim().isEmpty) return [];
    return value
        .split(',')
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .map((entry) => int.tryParse(entry))
        .whereType<int>()
        .where((entry) => widget.allowNegative || entry >= 0)
        .toList();
  }

  String _format(List<int> values) {
    if (values.isEmpty) return '';
    return values.join(', ');
  }
}
