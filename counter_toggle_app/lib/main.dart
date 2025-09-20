import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  void _onThemeChanged(bool value) {
    setState(() {
      _isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter Toggle App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        brightness: Brightness.dark,
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(
        title: 'Counter Toggle App',
        isDark: _isDark,
        onThemeChanged: _onThemeChanged,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.isDark,
    required this.onThemeChanged,
  });
  final String title;
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _showFirstImage = true;
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _toggleImage() {
    if (_controller.isAnimating) return;
    _controller.reverse().then((_) {
      setState(() {
        _showFirstImage = !_showFirstImage;
      });
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Switch.adaptive(
                value: widget.isDark,
                onChanged: widget.onThemeChanged,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.dark_mode_outlined),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FadeTransition(
                    opacity: _fade,
                    child: Image.asset(
                      _showFirstImage ? 'assets/gt_start_score.png' : 'assets/gt_final_score.png',
                      width: 400,
                      height: 400,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _toggleImage,
                    child: const Text('Toggle Image'),
                  ),
                  const SizedBox(height: 20),
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
