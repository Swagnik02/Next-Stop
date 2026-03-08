import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:next_stop/core/utils/maps_coordinate_parser.dart';
import 'package:next_stop/core/utils/maps_link_resolver.dart';
import 'package:next_stop/features/journey/models/trip_model.dart';

class TestMapsParser extends StatefulWidget {
  final Function(Trip trip) onTripParsed;

  const TestMapsParser({super.key, required this.onTripParsed});

  @override
  State<TestMapsParser> createState() => _TestMapsParserState();
}

class _TestMapsParserState extends State<TestMapsParser> {
  final TextEditingController urlController = TextEditingController();

  Future<void> _parseUrl() async {
    final url = urlController.text.trim();

    if (url.isEmpty) return;

    String? resolvedUrl = await getResolvedMapsUrl(url);

    if (resolvedUrl != null) {
      final trip = extractTripFromMapsUrl(resolvedUrl);

      widget.onTripParsed(trip);
      urlController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Trip loaded from Google Maps"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          /// TEXT FIELD
          Expanded(
            child: TextField(
              controller: urlController,
              textAlignVertical: TextAlignVertical.center,
              onSubmitted: (_) => _parseUrl(),
              decoration: const InputDecoration(
                hintText: "Paste Google Maps link",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.map_outlined),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          /// PASTE BUTTON
          IconButton(
            tooltip: "Paste",
            icon: const Icon(Icons.paste_outlined),
            onPressed: () async {
              final data = await Clipboard.getData('text/plain');
              final text = data?.text ?? '';

              urlController.text = text;

              if (text.contains("maps")) {
                _parseUrl();
              }
            },
          ),

          /// PARSE BUTTON
          IconButton(
            tooltip: "Parse",
            icon: const Icon(Icons.link),
            color: Colors.teal,
            onPressed: _parseUrl,
          ),
        ],
      ),
    );
  }
}
