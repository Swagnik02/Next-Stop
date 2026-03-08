import 'package:flutter/material.dart';
import 'package:next_stop/core/utils/maps_coordinate_parser.dart';
import 'package:next_stop/core/utils/maps_link_resolver.dart';

class TestMapsParser extends StatefulWidget {
  const TestMapsParser({super.key});

  @override
  State<TestMapsParser> createState() => _TestMapsParserState();
}

class _TestMapsParserState extends State<TestMapsParser> {
  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: urlController,
          decoration: const InputDecoration(
            labelText: "Paste Google Maps URL",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 20),

        MaterialButton(
          color: Colors.teal,
          child: const Text("Parse Trip"),
          onPressed: () async {
            final url = urlController.text.trim();

            if (url.isEmpty) return;

            String? resolvedUrl = await getResolvedMapsUrl(url);
            print(resolvedUrl);
            if (resolvedUrl != null) {
              final trip = extractTripFromMapsUrl(resolvedUrl);

              print(trip.toString());
            }
          },
        ),
      ],
    );
  }
}
