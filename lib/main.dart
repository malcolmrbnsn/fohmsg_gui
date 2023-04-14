import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 300),
    // center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    // alwaysOnTop: true, //THIS IS GREAT
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: MaterialApp(
        title: 'MyApp',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const MyHomePage(title: 'Connect to Server'),
          '/second': (context) => const SecondScreen(),
        },
        // home: const MyHomePage(title: 'Connect to Server'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  TextEditingController serverController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  void _connectToServer() {
    String serverUrl = serverController.text;
    String username = usernameController.text;

    // Implement your logic to connect to the server here

    // ignore: avoid_print
    print('Connecting to $serverUrl with username $username');
    Navigator.pushNamed(context, '/second');
  }

  // @override
  // void initState() {
  //   super.initState();
  //   serverController.text = _prefs.then((SharedPreferences prefs) {
  //     return prefs.getString('server');
  //   });
  //   // serverController.text = server;
  //   // usernameController.text = username;
  // }

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the
    // widget tree.
    serverController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: serverController,
              decoration: const InputDecoration(labelText: 'Server URL'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16.0),
            const Padding(padding: EdgeInsets.symmetric(vertical: 6.0)),
            ElevatedButton(
              onPressed: _connectToServer,
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack.
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
