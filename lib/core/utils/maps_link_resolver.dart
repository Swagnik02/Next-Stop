import 'package:http/http.dart' as http;

/// Extract first URL from shared text
String? extractUrl(String text) {
  final match = RegExp(r'https?:\/\/\S+').firstMatch(text);
  return match?.group(0);
}

/// Expand Google Maps short links
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

      final location = response.headers['location'];

      if (location == null) {
        return current.toString();
      }

      current = Uri.parse(location);
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

  if (extracted.contains("maps.app.goo.gl")) {
    return await resolveGoogleMapsLink(extracted);
  }

  return extracted;
}
