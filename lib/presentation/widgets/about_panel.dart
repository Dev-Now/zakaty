import 'package:flutter/material.dart';

class AboutPanel extends StatelessWidget {
  const AboutPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Zakat calculator supporting multi-currency conversion.'),
      ],
    );
  }
}