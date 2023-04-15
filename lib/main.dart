// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import './chat.dart';

void main() async {
  // Apply window size constraints if on desktop
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 300),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      // alwaysOnTop: true, //THIS IS GREAT
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // get this show on the road
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// STATE:
  late IO.Socket socket;
  String serverURL = "";
  String username = "";
  bool connected = false;
  late List<Object> messages;
  late List<Object> users;

// METHODS:

// Sign in
  void handleLoginSubmit(String addr, String usr) {
    setState(() => {
          username = usr,
          serverURL = addr,
        });
    print(serverURL);
    print(username);
    setPrefs(); //not sure if this works
    initSocket();
  }

// // Receive Message
//   void handleMessageReceive() {}
// // Send Message
//   void handleMessageTransmit() {}
// // Update Users
//   void handleUpdateUsers() {}
// // Send Effect
//   void handleEffectSend() {}
// // Recieve Effect
//   void handleEffectReceive() {}

  // SOCKETIO FUNCTS
  void initSocket() {
    // setup socket
    socket = IO.io(serverURL, <String, dynamic>{
      // 'autoConnect': true,
      // 'setTransports': ['websocket'],
    });
    socket.onConnect((_) {
      print('socket connected');
    });
    socket.onDisconnect((_) {
      print('socket disconnected');
    });
    socket.onConnectError((dynamic err) {
      print(err);
    });
    socket.onError((dynamic err) {
      print(err);
    });
  }

// PREFS
  void pullPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('serverURL'));
    setState(() {
      serverURL = prefs.getString('serverURL') ?? "";
      username = prefs.getString('username') ?? "";
    });
  }

  setPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('serverURL', serverURL);
    prefs.setString('username', username);
    print(prefs.getString('serverURL'));
  }

// STOCK EFFECTS
  @override
  void initState() {
    pullPrefs();
    super.initState();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(
              serverURL: serverURL,
              username: username,
              handleLoginSubmit: handleLoginSubmit,
            ),
        '/app': (context) => const ChatPage(),
      },
      // home: const MyHomePage(title: 'Connect to Server'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.serverURL,
    required this.username,
    required this.handleLoginSubmit,
  }) : super(key: key);

  final Function handleLoginSubmit;
  final String serverURL;
  final String username;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TextEditingController serverController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  void _connectToServer() {
    // Implement your logic to connect to the server here

    widget.handleLoginSubmit(serverController.text, usernameController.text);

    Navigator.pushNamed(context, '/app');
  }

  @override
  void initState() {
    serverController.text = widget.serverURL;
    usernameController.text = widget.username;
    super.initState;
  }

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
              autocorrect: false,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16.0),
            const Padding(padding: EdgeInsets.symmetric(vertical: 6.0)),
            ElevatedButton(
              // onPressed: _connectToServer,
              onPressed: _connectToServer,
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
