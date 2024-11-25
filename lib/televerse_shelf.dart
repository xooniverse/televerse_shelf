/// # Televerse Shelf
///
/// `televerse_shelf` is a Dart library that integrates the power of the
/// [televerse](https://pub.dev/packages/televerse) package with the flexibility of
/// [package:shelf](https://pub.dev/packages/shelf). It allows you to manage Telegram bot webhooks
/// while retaining full control over your server routes and middleware.
///
/// ## Motivation
///
/// By default, the Televerse package supports fetching updates from a webhook. However, the server
/// that handles these webhooks is managed internally, leaving developers with limited control over
/// routes and other server functionalities. With `televerse_shelf`, you can leverage the capabilities
/// of `package:shelf` to create a customizable web server where you can specify your own routes and
/// middleware, all while seamlessly handling Telegram bot webhooks.
///
/// This package is perfect for developers who want more control over their server and wish to combine
/// a Telegram bot with other API routes or functionalities on a single port.
///
/// ## Key Features
///
/// - **Customizable Routes:** Define your own routes for both the bot webhook and other server
///   functionalities using `package:shelf`.
/// - **Middleware Support:** Add and manage middlewares (e.g., logging, authentication) for your
///   routes, including the bot webhook route.
/// - **Seamless Televerse Integration:** Easily set up a Televerse bot with a webhook, managed
///   by a Shelf-powered server.
///
/// ## How It Works
///
/// 1. Use the `TeleverseShelfWebhook` to create a handler for your bot's webhook.
/// 2. Define a dedicated route for the webhook using `package:shelf_router` or your preferred
///    Shelf-compatible router.
/// 3. Add additional routes for other server functionality as needed.
/// 4. Start a Shelf server to handle all the defined routes.
///
/// ## Example
///
/// Here's a simple example to demonstrate how to use the package:
///
/// ```dart
/// import 'dart:io';
///
/// import 'package:shelf/shelf.dart';
/// import 'package:shelf/shelf_io.dart';
/// import 'package:shelf_router/shelf_router.dart';
/// import 'package:televerse/televerse.dart';
/// import 'package:televerse_shelf/televerse_shelf.dart';
///
/// void main() async {
///   // Get your token from @BotFather
///   final token = Platform.environment["BOT_TOKEN"]!;
///
///   // Take an instance of the Televerse Shelf Adapter, which we'll use
///   // as the fetcher for our bot.
///   final fetcher = TeleverseShelfWebhook();
///
///   // Initialize your bot by passing the fetcher.
///   final bot = Bot(
///     token,
///     fetcher: fetcher,
///   );
///
///   // Setup your commands and other listeners
///   bot.command('start', (ctx) async {
///     await ctx.reply("Hello World!");
///   });
///
///   // Create a router
///   final router = Router();
///
///   // Use the fetcher.createHandler() to handle the bot's incoming webhook requests.
///   router.post('/webhook', fetcher.createHandler());
///
///   // Add additional routes for other server functionalities
///   router.get('/api', (req) => Response.ok("Hello from API!"));
///   router.get('/health', (req) => Response.ok('{"status":"OK"}'));
///
///   // Add middlewares as usual
///   final pipeline =
///       Pipeline().addMiddleware(logRequests()).addHandler(router.call);
///
///   // Start the server
///   final server = await serve(pipeline, 'localhost', 8080);
///
///   // Start the bot
///   await bot.start();
///   print('Server running on port ${server.port}');
/// }
/// ```
///
/// ## When to Use `televerse_shelf`
///
/// - When you need more control over your server routes and middleware.
/// - When you want to combine Telegram bot functionality with other server endpoints.
/// - When you're building a complex application that requires a single server handling both
///   bot requests and other HTTP requests.
///
/// ## Getting Started
///
/// - Install the package via `pub add televerse_shelf`.
/// - Import it alongside `televerse` and `shelf`.
/// - Set up your Shelf server, defining routes and adding middlewares.
/// - Use the `TeleverseShelfWebhook` to integrate your bot webhook seamlessly into your Shelf server.
///
/// With `televerse_shelf`, you get the best of both worlds: the simplicity of Televerse and the
/// flexibility of Shelf, enabling you to build sophisticated applications with ease.
library;

export 'src/televerse_shelf_base.dart';
