import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showIkut3AboutDialog(BuildContext context) {
  showAboutDialog(
      context: context,
      // applicationIcon: Image(
      //     width: 96,
      //     height: 96,
      //     image: AssetImage('assets/icon.png'),
      //     filterQuality: FilterQuality.high),
      applicationVersion: '0.0.1',
      applicationLegalese: 'Copyright © 2023 Haruhiko Takada',
      children: [
        const SizedBox(height: 16),
        _buildLink(context, 'https://qiita.com/tfandkusu'),
        _buildLink(context, 'https://twitter.com/tfandkusu'),
        _buildLink(context, 'https://github.com/tfandkusu'),
        _buildLink(context, 'https://zenn.dev/tfandkusu'),
        const SizedBox(height: 16),
        _buildPoweredBy(context)
      ]);
}

/// リンクテキストを作成する
/// [url] リンクURL
/// [text] テキスト。nullの時はURLと同じ
StatelessWidget _buildLink(BuildContext context, String url, {String? text}) {
  final themeData = Theme.of(context);
  final textStyle = themeData.typography.englishLike.bodyMedium
      ?.copyWith(color: themeData.colorScheme.primary);
  double horizontal = 16;
  if (text != null) {
    horizontal = 8;
  } else {
    text = url;
  }
  return InkWell(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: horizontal),
      child: Text(text, style: textStyle),
    ),
    onTap: () async {
      await launchUrl(Uri.parse(url));
    },
  );
}

Wrap _buildPoweredBy(BuildContext context) {
  final themeData = Theme.of(context);
  final textStyle = themeData.typography.englishLike.bodyMedium
      ?.copyWith(color: themeData.colorScheme.primary);
  return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
    Text("Powered by ", style: textStyle),
    _buildLink(context, "https://cloud.google.com/vision/automl/docs",
        text: "AutoML Vision"),
    _buildLink(context, "https://www.tensorflow.org/", text: "TensorFlow")
  ]);
}
