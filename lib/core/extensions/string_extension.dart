import 'package:html/dom.dart' show Element;
import 'package:html/parser.dart' show parse;

extension StringExtension on String {
  String? get errorMsg {
    var document = parse(this);
    Element? errMsg = document.getElementById('errmsg');
    if (errMsg != null) {
      return errMsg.innerHtml;
    }
    return null;
  }

  String get removeHtmlTags {
    RegExp regExp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true,
    );
    return replaceBrWithNewline.replaceAll(regExp, '').unescapeHtml;
  }

  String get unescapeHtml {
    // Use html package's built-in unescape instead of html_unescape package
    final text = this
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#39;', "'");

    // Handle numeric entities
    return text.replaceAllMapped(
      RegExp(r'&#(\d+);'),
      (match) => String.fromCharCode(int.parse(match.group(1)!)),
    );
  }

  String get removeWbr {
    return replaceAll('<wbr>', '');
  }

  String get replaceWbrWithNewline {
    return replaceAll('<wbr>', ' \n');
  }

  String get replaceBrWithSpace {
    return replaceAll('<br>', ' ');
  }

  String get replaceBrWithNewline {
    return replaceAll('<br>', ' \n');
  }

  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
