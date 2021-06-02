import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final List<Map<String, dynamic>>? textSpanList;

  RichTextWidget({
    required this.text,
    required this.textStyle,
    this.textSpanList,
  });

  List<InlineSpan> getTextSpanList(List<Map<String, dynamic>>? textSpanData) {
    List<InlineSpan> textSpanLists = [];
    if (textSpanData != null && textSpanData.length > 0) {
      for (var spanDict in textSpanData) {
        var textSpan = TextSpan(
            text: spanDict['text'] != null ? spanDict['text'] : '',
            style: spanDict['style']);
        textSpanLists.add(textSpan);
      }
    }
    return textSpanLists;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: text,
        style: textStyle,
        children: getTextSpanList(textSpanList),
      ),
    );
  }
}
