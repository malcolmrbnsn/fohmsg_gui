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
          '/': (context) => const HomePage(),
          '/app': (context) => const ChatPage(),
        },
        // home: const MyHomePage(title: 'Connect to Server'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController serverController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  void _connectToServer() {
    String serverUrl = serverController.text;
    String username = usernameController.text;

    // Implement your logic to connect to the server here

    // ignore: avoid_print
    print('Connecting to $serverUrl with username $username');
    Navigator.pushNamed(context, '/app');
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
        title: const Text('Connect to Server'),
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

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 100.0,
            height: double.infinity,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text('Button 1'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('Button 2'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('Button 3'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(
                        title: Text('Chat message 1'),
                      ),
                      ListTile(
                        title: Text('Chat message 2'),
                      ),
                      ListTile(
                        title: Text('Chat message 3'),
                      ),
                      // Add more chat messages here
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Type a message',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        child: const Text('Send'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
