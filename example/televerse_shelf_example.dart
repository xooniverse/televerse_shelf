import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:televerse/televerse.dart';
import 'package:televerse_shelf/televerse_shelf.dart';

void main() async {
  // Get your token from @BotFather
  final token = Platform.environment["BOT_TOKEN"]!;

  // Take an instance of the Televerse Shelf Adapter, which we'll use
  // as the fetcher for our bot.
  final fetcher = TeleverseShelfWebhook();

  // Initialize your bot with passing the fetcher.
  final bot = Bot(
    token,
    fetcher: fetcher,
  );

  // Setup your commands, and other listeners
  bot.command('start', (ctx) async {
    await ctx.reply("Hello World!");
  });

  // Create router
  final router = Router();

  // Use the `fetcher.createHandler` to handle the incoming request to the bot.
  router.post('/webhook', fetcher.createHandler());

  // Setup other routes as usual
  router.get('/api', (req) => Response.ok("Hello from API!"));
  router.get('/health', (req) => Response.ok('{"status":"OK"}'));

  /// Add middlewares as usual :)
  final pipeline =
      Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  // Start server
  final server = await serve(pipeline, 'localhost', 8080);

  // Start the bot.
  await bot.start();
  print('Server running on port ${server.port}');
}
