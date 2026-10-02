import 'package:a11y_kit/a11y_kit.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Web: semantics always on + no double navigation on semantic links.
  // Android/iOS: no-op.
  A11y.ensureInitialized();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      // Screen readers use the app's language, not the device's.
      builder: A11yLocale.appBuilder,
      theme: ThemeData(
        extensions: const [A11yTheme(focusColor: Color(0xFFB8290C))],
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  int _copies = 0;

  void _copy() {
    setState(() => _copies++);
    // Web/iOS: spoken announcement. Android: the live region below.
    A11yAnnouncer.announce(context, 'Copied');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const A11yHeading(
            level: 1,
            label: 'Jane Doe',
            child: Text('JANE DOE', style: TextStyle(fontSize: 40.0)),
          ),
          const A11yCapsText('Open to work'),
          const SizedBox(height: 24.0),
          // A custom-drawn link: Tab, Enter/Space, focus ring, <a href> on
          // web, read as "GitHub, link" instead of "GITHUB ↗".
          A11yTappable(
            url: 'https://github.com',
            semanticsLabel: 'GitHub',
            onTap: () {},
            builder: (context, highlighted) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'GITHUB ↗',
                style: TextStyle(
                  decoration: highlighted ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
          // A small icon button, grown to a 48×48 target.
          A11yLiveRegion(
            child: A11yTappable(
              semanticsLabel: _copies == 0 ? 'Copy' : 'Copied',
              minTapTargetSize: const Size.square(kMinInteractiveDimension),
              onTap: _copy,
              builder: (_, _) => const Icon(Icons.copy, size: 16.0),
            ),
          ),
          const SizedBox(height: 24.0),
          // Portuguese content inside an English page gets a Portuguese voice.
          const A11yLocale(
            locale: Locale('pt', 'BR'),
            child: A11ySelectableText('Olá, mundo!'),
          ),
          // Animations shrink to zero under "Reduce motion".
          AnimatedContainer(
            duration: context.motionDuration(const Duration(milliseconds: 300)),
            height: 4.0,
            width: _copies.isEven ? 40.0 : 120.0,
            color: Colors.deepOrange,
          ),
        ],
      ),
    );
  }
}
