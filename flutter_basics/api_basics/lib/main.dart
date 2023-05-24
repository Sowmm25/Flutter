import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/basic.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Api Integration",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyButton());
  }
}

class MyButton extends StatefulWidget {
  const MyButton({super.key});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('API DEMO'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  child: Text("Click to view jokes"),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(title: 'API DEMO'))),
                ),
              ],
            ),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Future<List<Joke>> _getJokes() async {
    var data = await http
        .get(Uri.parse("https://api.chucknorris.io/jokes/search?query=cats"));
    var jsonData = jsonDecode(data.body);

    List<Joke> jokes = [];
    for (var joke in jsonData["result"]) {
      Joke newJoke = Joke(joke["created_at"], joke["icon_url"], joke["id"],
          joke["url"], joke["value"]);
      jokes.add(newJoke);
    }
    return jokes;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getJokes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 223, 222, 223),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 20.0,
                                backgroundImage: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2016/09/01/08/24/smiley-1635451_960_720.png'),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(snapshot.data[index].createdAt),
                              subtitle: Text(snapshot.data[index].value),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildPopupDialog(context),
                                );
                              },
                            )));
                  },
                );
              }
            },
          ),
        ));
  }
} //${snapshot.data[index].iconUrl}

Widget _buildPopupDialog(BuildContext context) {
  // ignore: unnecessary_new
  return new AlertDialog(
    title: const Text('Api Demo'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hope You enjoyed the Joke!!"),
      ],
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Close'),
      ),
    ],
  );
}

class Joke {
  final String createdAt;
  final String iconUrl;
  final String id;
  final String url;
  final String value;

  Joke(this.createdAt, this.iconUrl, this.id, this.url, this.value);
}
