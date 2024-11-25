import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf_io.dart';
import 'package:test/test.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:televerse/televerse.dart' hide Handler;
import 'package:televerse_shelf/televerse_shelf.dart';

void main() {
  group('TeleverseShelfWebhook Tests', () {
    late TeleverseShelfWebhook fetcher;
    late Bot bot;
    late Pipeline pipeline;
    late Router router;
    late Handler handler;

    final startJson = {
      "update_id": 1234,
      "message": {
        "message_id": 12345,
        "from": {
          "id": 1726826785,
          "is_bot": false,
          "first_name": "Kid",
          "language_code": "en"
        },
        "chat": {
          "id": 1726826785,
          "first_name": "🕷️",
          "username": "cosmickid",
          "type": "private"
        },
        "date": 1732432070,
        "text": "/start",
        "entities": [
          {"offset": 0, "length": 6, "type": "bot_command"}
        ]
      }
    };

    setUp(() async {
      fetcher = TeleverseShelfWebhook();

      // Mock bot initialization
      bot = Bot(
        Platform.environment["BOT_TOKEN"]!,
        fetcher: fetcher,
      );

      // Define bot commands for testing
      bot.command('start', (ctx) async {
        await ctx.reply('Hello from test bot!');
      });

      // Initialize router and pipeline
      router = Router();
      router.post('/webhook', fetcher.createHandler());
      router.get('/health', (req) => Response.ok("OK"));
      pipeline = Pipeline();
      handler = pipeline.addMiddleware(logRequests()).addHandler(router.call);

      await serve(handler, "localhost", 8080, shared: true);
      await bot.start();
    });

    test('Webhook route processes bot updates', () async {
      // Simulate a bot update payload
      final updatePayload = json.encode(startJson);

      // Mock HTTP request to webhook route
      final request = Request(
        'POST',
        Uri.parse('http://localhost:8080/webhook'),
        body: updatePayload,
        headers: {'content-type': 'application/json'},
      );

      final response = await handler(request);

      expect(response.statusCode, equals(200));
    });

    test('Middleware handles requests correctly', () async {
      // Simulate an unrelated route request
      final request = Request('GET', Uri.parse('http://localhost:8080/health'));
      final response = await handler(request);

      expect(response.statusCode, equals(200));
      expect(await response.readAsString(), contains('OK'));
    });
  });
}
