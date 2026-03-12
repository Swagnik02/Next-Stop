import 'dart:async';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntentService {
  StreamSubscription? _subscription;

  void startListening(Function(String) onTextReceived) {
    /// App running in background
    _subscription = ReceiveSharingIntent.instance.getMediaStream().listen((
      files,
    ) {
      for (final file in files) {
        final text = file.path;

        if (text.isNotEmpty) {
          onTextReceived(text);
        }
      }
    });

    /// App opened via share
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      for (final file in files) {
        final text = file.path;

        if (text.isNotEmpty) {
          onTextReceived(text);
        }
      }

      /// Important: clear intent after processing
      ReceiveSharingIntent.instance.reset();
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
