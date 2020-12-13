import 'package:flutter/material.dart';
// import 'package:flutter_grpc/src/generated/helloworld.pbgrpc.dart';
import 'package:flutter_grpc/src/generated/greet.pbgrpc.dart';
import 'package:grpc/grpc.dart';

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
  var result = '';
  GreeterClient client = GreeterClient(ClientChannel('192.168.1.228',
      port: 5001,
      options: ChannelOptions(credentials: ChannelCredentials.insecure())));

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _callGrpcService() async {
    /*var response = await client.sayHello(HelloRequest()..name = "Flutter is ");
    // var response2 =
    //     await client.sayHelloAgain(HelloRequest()..name = "Awesome!!");
    setState(() {
      result = response.message;
      _counter++;
    });*/

    var response =
        await client.sayHello(HelloRequest()..name = "Shorotshishir");

    var temp = '';
    await for (var item in response) {
      temp = '${temp}\n${item.message}';
    }
    setState(() {
      result = temp;
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
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$result : $_counter',
              style: Theme.of(context).textTheme.headline4,
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
