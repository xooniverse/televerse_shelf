import 'dart:convert';
import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart' hide Middleware, Handler;

/// A shelf adapter for Televerse webhook functionality that implements the Fetcher interface
class TeleverseShelfWebhook<CTX extends Context> extends Fetcher<CTX> {
  /// Update Stream Subscription
  StreamSubscription<Update>? _updateSubscription;

  /// Error handler for long polling.
  FutureOr<void> Function(BotError<CTX> err)? _onError;

  /// Sets the error handler for long polling.
  @override
  void onError(FutureOr<void> Function(BotError<CTX> err) onError) =>
      _onError = onError;

  StreamController<Update>? _updateStreamController;

  /// The secret token for webhook verification
  final String? secretToken;

  /// Flag to track if the adapter is active
  bool _isActive = false;

  /// Creates a new TeleverseShelfWebhook instance
  ///
  /// [secretToken] - Optional secret token for webhook verification
  TeleverseShelfWebhook({
    this.secretToken,
  }) {
    _updateStreamController = StreamController<Update>.broadcast();
  }

  /// Creates a shelf middleware for handling Telegram webhook requests
  Middleware createMiddleware({String path = "/webhook"}) {
    return (Handler innerHandler) {
      return (Request request) async {
        if (request.url.path != path.replaceAll(RegExp('^/'), '')) {
          return innerHandler(request);
        }

        return _handleRequest(request);
      };
    };
  }

  /// Creates a shelf handler for processing Telegram webhook requests
  Handler createHandler() {
    return _handleRequest;
  }

  /// Handles incoming webhook requests
  Future<Response> _handleRequest(Request request) async {
    if (!isActive) {
      return Response(503, body: '{"ok":false,"error":"Service unavailable"}');
    }

    if (request.method != 'POST') {
      return Response(405, body: '{"ok":false,"error":"Method not allowed"}');
    }

    // Verify secret token if set
    if (secretToken != null) {
      final requestToken = request.headers['X-Telegram-Bot-Api-Secret-Token'];
      if (requestToken != secretToken) {
        return Response(401, body: '{"ok":false,"error":"Unauthorized"}');
      }
    }

    try {
      final body = await request.readAsString();
      final update = Update.fromJson(jsonDecode(body));

      // Add update to the stream instead of handling directly
      addUpdate(update);

      return Response.ok(
        '{"ok":true}',
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e, stack) {
      _onError?.call(BotError(e, stack));
      return Response(400, body: '{"ok":false,"error":"Invalid update"}');
    }
  }

  @override
  Future<void> start() async {
    _isActive = true;
    return Future.value();
  }

  @override
  Future<void> stop() async {
    _isActive = false;
    await _updateStreamController?.close();
    await _updateSubscription?.cancel();
  }

  @override
  bool get isActive => _isActive;
}
