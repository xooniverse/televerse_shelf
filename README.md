<div align="center">
  <h1><code>televerse_shelf</code></h1>

[![Pub Version](https://img.shields.io/pub/v/televerse_shelf?color=blue&logo=pub)](https://pub.dev/packages/televerse_shelf)
![GitHub](https://img.shields.io/github/license/xooniverse/televerse_shelf?color=green)
![Dart](https://img.shields.io/badge/Powered%20By-Dart-blue?logo=dart)

<a href="https://telegram.me/TeleverseDart">
  <img src="https://img.shields.io/badge/Telegram%2F@TeleverseDart-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white"/>
</a>
</div>

---

### 🚀 **Combine Televerse with Shelf for Custom Webhook Servers**

`televerse_shelf` extends the functionality of the Televerse framework, enabling you to integrate the power of Shelf into your Telegram bots. While Televerse natively supports webhooks, it implicitly handles server creation, limiting user control over routes and server customization. With `televerse_shelf`, you can build fully customizable web servers using Shelf while managing your bot's webhook on a dedicated route.

This package is perfect for developers who want to combine the simplicity of Televerse with the flexibility of Shelf to handle other web server tasks alongside Telegram bot updates.

---

## ✨ Key Features

- **Customizable Webhook Routes**  
  Define a specific route for handling Telegram updates via webhooks, without interfering with other routes.
  
- **Full Shelf Integration**  
  Seamlessly use Shelf's powerful routing and middleware alongside Televerse.
  
- **Dedicated TeleverseShelfWebhook**  
  A custom adapter for Televerse, enabling webhook updates via Shelf.

- **Multi-route Support**  
  Dedicate a single port for your bot webhook and additional routes, like APIs or health checks, all under one server.

---

## 🛠 Installation

Add `televerse_shelf` to your `pubspec.yaml`:

```yaml
dependencies:
  televerse_shelf: <latest>
```

Then import the package in your Dart code:

```dart
import 'package:televerse_shelf/televerse_shelf.dart';
```

---

## 💻 Getting Started

Here's a basic example to get you started with `televerse_shelf`:

```dart
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:televerse/televerse.dart';
import 'package:televerse_shelf/televerse_shelf.dart';

void main() async {
  final token = Platform.environment['BOT_TOKEN']!;
  final fetcher = TeleverseShelfWebhook();
  final bot = Bot(token, fetcher: fetcher);

  bot.command('start', (ctx) async {
    await ctx.reply('Hello, world!');
  });

  final router = Router();

  // Set up your webhook route
  router.post('/webhook', fetcher.createHandler());

  // Define other custom routes
  router.get('/api', (req) => Response.ok('Hello from API!'));
  router.get('/health', (req) => Response.ok('{"status":"OK"}'));

  final pipeline = Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  final server = await serve(pipeline, 'localhost', 8080);

  await bot.start();
  print('Server running on port ${server.port}');
}
```

### 🤔 What’s Happening Here?

- **`TeleverseShelfWebhook`**: Manages webhook updates and integrates with Shelf.
- **Custom Routes**: Use Shelf's `Router` to define `/api` and `/health` alongside the bot's `/webhook`.
- **Pipeline & Middleware**: Add logging, authentication, or other middleware to your server.

---

## 📚 Documentation

To use `televerse_shelf` effectively:

1. **Set Up Webhooks**: Use `TeleverseShelfWebhook` and `fetcher.createHandler()` for handling webhook routes.
2. **Customize Your Server**: Combine Televerse with Shelf’s routing and middleware to create versatile applications.
3. **Run Your Bot**: Call `bot.start()` to initiate the bot alongside your server.

For detailed examples and advanced usage, check out the [Televerse documentation](https://televerse.xooniverse.com).

---

## 💡 Use Cases

- Deploy bots on a single port with APIs or health checks.
- Build server applications that combine bot updates with REST APIs.
- Add middleware for logging, rate-limiting, or security to your bot server.

---

## 🤝 Contributing

We’d love to see contributions from the community! Feel free to fork the repository, open issues, or submit pull requests.

---

## 🌟 Shoot a Star

If you find `televerse_shelf` helpful, consider giving us a star on our [GitHub repository](https://github.com/xooniverse/televerse_shelf). It motivates us to keep building cool tools!

---

## 🤝 Join the Community

Need help? Have ideas? Join the discussion with other developers:

<a href="https://telegram.me/TeleverseDart">
  <img src="https://img.shields.io/badge/Telegram%2F@TeleverseDart-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white"/>
</a>  
<a href="https://github.com/xooniverse/televerse_shelf">
  <img src="https://img.shields.io/badge/GitHub%20Discussions-100000?style=for-the-badge&logo=github&logoColor=white"/>
</a>

---

Thank you for using `televerse_shelf`! 🚀