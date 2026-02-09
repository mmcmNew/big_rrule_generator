import 'package:flutter/material.dart';
import 'package:big_rrule_generator/big_rrule_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'big_rrule_generator Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'big_rrule_generator Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RRuleResult? _currentRule;
  RRuleLocalizations _currentLocale = RRuleLocalizations.english;

  void _changeLocale(bool toRussian) {
    setState(() {
      _currentLocale = toRussian ? RRuleLocalizations.russian : RRuleLocalizations.english;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) {
              _changeLocale(value == 'ru');
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'en',
                child: Text('English'),
              ),
              const PopupMenuItem(
                value: 'ru',
                child: Text('Русский'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select recurrence pattern:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Container(
              height: 600,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SingleChildScrollView(
                  child: RRuleGenerator(
                    startDate: DateTime.now(),
                    localizations: _currentLocale,
                    onRRuleChanged: (result) {
                      setState(() {
                        _currentRule = result;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_currentRule != null) ...[
              Text(
                'Generated RRULE:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SelectableText(
                _currentRule!.rrule,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              const SizedBox(height: 8),
              Text(
                'Human-readable description:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                describeRRule(_currentRule!.rrule, localizations: _currentLocale),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
