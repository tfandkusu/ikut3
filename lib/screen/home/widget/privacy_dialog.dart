import 'package:flutter/material.dart';

import '../../../resource/privacy_strings.dart';

/// プライバシーポリシーを表示する
void showPrivacyDialog(BuildContext context) {
  final themeData = Theme.of(context);
  final titleTextStyle = themeData.typography.dense.headlineMedium
      ?.copyWith(color: themeData.colorScheme.onSurface);
  final closeTextStyle = themeData.typography.dense.bodyMedium
      ?.copyWith(color: themeData.colorScheme.onPrimary);

  final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.resolveWith(
          (states) => const EdgeInsets.fromLTRB(32, 16, 32, 16)));

  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(PrivacyStrings.title, style: titleTextStyle),
            content: _buildPrivacyContent(context),
            actions: [
              FilledButton(
                  style: buttonStyle,
                  onPressed: () {
                    // ダイアログを閉じる
                    Navigator.of(context).pop();
                  },
                  child: Text(PrivacyStrings.close, style: closeTextStyle))
            ],
          ));
}

Widget _buildPrivacyContent(BuildContext context) {
  return Container(
    width: 600,
    constraints: const BoxConstraints(maxHeight: 500),
    child: Column(
      children: [
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: ListView(shrinkWrap: true, children: [
            const SizedBox(height: 16),
            _buildBody(context, PrivacyStrings.body1),
            _buildHead(context, PrivacyStrings.head2),
            _buildBody(context, PrivacyStrings.body2),
            _buildHead(context, PrivacyStrings.head3),
            _buildBody(context, PrivacyStrings.body3),
            _buildHead(context, PrivacyStrings.head4),
            _buildBody(context, PrivacyStrings.body4),
            const SizedBox(height: 16),
          ]),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    ),
  );
}

Widget _buildHead(BuildContext context, String text) {
  final themeData = Theme.of(context);

  final style = themeData.typography.dense.headlineMedium
      ?.copyWith(color: themeData.colorScheme.onSurface);
  return Container(
    margin: const EdgeInsets.fromLTRB(0, 16, 12, 16),
    child: Text(text, style: style),
  );
}

Widget _buildBody(BuildContext context, String text) {
  final themeData = Theme.of(context);
  final style = themeData.typography.dense.bodyMedium
      ?.copyWith(color: themeData.colorScheme.onSurface);
  return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Text(text, style: style));
}
