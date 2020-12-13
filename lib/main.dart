import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_grpc/src/generated/helloworld.pbgrpc.dart';
import 'package:flutter_grpc/src/generated/greet.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _counter = 0;
  var resultUnary = '';
  var resultStream = '';
  GreeterClient client = GreeterClient(ClientChannel('192.168.1.228',
      port: 5001,
      options: ChannelOptions(credentials: ChannelCredentials.insecure())));

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  /*void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }*/

  readFile() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0.
      return 0;
    }
  }

  void _callGrpcService() async {
    /*var response = await client.sayHello(HelloRequest()..name = "Flutter is ");
    // var response2 =
    //     await client.sayHelloAgain(HelloRequest()..name = "Awesome!!");
    setState(() {
      result = response.message;
      _counter++;
    });*/

    var responseUnary =
        await client.sayHelloUnary(HelloRequest()..name = "Shorotshishir");
    var temp1 = responseUnary.message;

    var responseStream = await client
        .sayHelloServerStream(HelloRequest()..name = "Shorotshishir");

    var temp2 = '';
    await for (var item in responseStream) {
      temp2 = '${temp2}\n${item.message}';
    }

    var p = await _localPath;
    print(p);
    setState(() {
      resultStream = temp2;
      resultUnary = temp1;
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('request : $_counter -> $resultUnary',
                style: Theme.of(context).textTheme.headline6),
            Text(
              '$resultStream',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _callGrpcService,
        tooltip: 'Increment',
        child: Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
