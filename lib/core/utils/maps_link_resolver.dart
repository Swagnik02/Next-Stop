import 'package:http/http.dart' as http;

/// Extract first URL from shared text
String? extractUrl(String text) {
  final match = RegExp(r'https?:\/\/\S+').firstMatch(text);
  return match?.group(0);
}

/// Expand Google Maps short links (robust)
Future<String> resolveGoogleMapsLink(String url) async {
  Uri current = Uri.parse(url);
  final client = http.Client();

  try {
    for (int i = 0; i < 5; i++) {
      final request = http.Request('GET', current)
        ..followRedirects = false
        ..headers['User-Agent'] =
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120 Safari/537.36';

      final response = await client.send(request);

      /// HTTP redirects
      if ([301, 302, 307, 308].contains(response.statusCode)) {
        final location = response.headers['location'];

        if (location == null) break;

        current = Uri.parse(location);
        continue;
      }

      /// Some pages return 200 but redirect via HTML
      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();

        /// Meta refresh redirect
        final metaMatch = RegExp(
          r"url=([^'>\s]+)",
          caseSensitive: false,
        ).firstMatch(body);

        if (metaMatch != null) {
          return metaMatch.group(1)!;
        }

        /// JS redirect
        final jsMatch = RegExp(
          r"window\.location\.href\s*=\s*[\']([^\']+)[\']",
        ).firstMatch(body);

        if (jsMatch != null) {
          return jsMatch.group(1)!;
        }

        return current.toString();
      }

      return current.toString();
    }
  } catch (_) {
    return url;
  } finally {
    client.close();
  }

  return current.toString();
}

/// Resolve final maps URL
Future<String?> getResolvedMapsUrl(String sharedText) async {
  final extracted = extractUrl(sharedText);

  if (extracted == null) return null;

  /// Handle all possible shorteners
  if (extracted.contains("maps.app.goo.gl") ||
      extracted.contains("goo.gl/maps") ||
      extracted.contains("t.co") ||
      extracted.contains("bit.ly")) {
    return await resolveGoogleMapsLink(extracted);
  }

  return extracted;
}
