import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown.dart';

class AboutPanel extends StatelessWidget {
  final String instructions;

  const AboutPanel({
    super.key,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height;
    final maxWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Zakat calculator supporting multi-currency conversion.'),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: 'Ghazi Majdoub '),
                  TextSpan(
                    text: '© 2025',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            SizedBox(height: maxHeight * 0.4, child: MarkdownWidget(data: instructions)),
          ],
        ),
      ),
    );
  }
}