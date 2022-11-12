import 'dart:math';

import 'package:vibration/vibration.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';




void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,


      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: Colors.black12,).copyWith(background: Colors.white),

      ),
      home:  const MyHome(title: 'Tic Tac Toe'),


    );

  }
}


class MyHome extends StatefulWidget {
  const MyHome({super.key, required this.title});





  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHome> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHome> {
  late ConfettiController controllerTopCenter;
  void initController() {
    controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      initController();
    });

  }



  int _turn = 0;
  int _startTurn = 0;
  int _remaining = 9;
  int _winner = -1;
  static const List<List<int>> _lines = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]];
  final List<int> _board = List<int>.generate(9, (index) => -1);
  final _playerScore = [0, 0];
  final _playerImages = <Image>[
    Image.asset('img/X.png'),
    Image.asset('img/O.png'),
  ];
  void _processPlacement(int index) {
    setState(() {
      if(_remaining <= 0 || _winner >= 0) return;
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(_board[index] == -1) {
        _board[index] = _turn;
        _turn = (_turn + 1) % 2;
        _remaining --;
      }
      // print(index);
      for(List<int> line in _lines){
        int occupant = _board[line[0]];
        for(int i in line){
          if(_board[i] != occupant){
            occupant = -1;
            break;
          }
        }
        if(occupant > -1){
          _winner = occupant;
          _playerScore[_winner] += 1;
          break; // allow only one line to count
        }
      }
    });
  }
  void _resetGameState() {
    setState(() {
      _startTurn = (_startTurn+1) % 2;
      _turn = _startTurn;
      _remaining = 9;
      _winner = -1;
      for (int i = 0; i < _board.length; i++) {
        _board[i] = -1;
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('It is currently '),
              SizedBox(
                height: 30,
                child: _playerImages[_turn],
              ),
              const Text('\'s turn.'),
            ],
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // height: constraints.maxHeight / 2,
              // width: MediaQuery.of(context).size.width / 2,
              final FixedTrackSize squareLength = (min(MediaQuery.of(context).size.height-132, MediaQuery.of(context).size.width)/3.0 - 6).px;

              return LayoutGrid(
                columnSizes: [squareLength, 2.px, squareLength, 2.px, squareLength],
                rowSizes: [squareLength, 2.px, squareLength, 2.px, squareLength],
                children: List.generate(25, (index) {
                  int x = index%5;
                  int y = index~/5;
                  if(x%2 == 1){
                    return const VerticalDivider(
                      color: Colors.black,
                    );
                  } else if(y%2 == 1){
                    return const Divider(
                      color: Colors.black,
                    );
                  }else{
                    index = (x~/2)+(y~/2)*3;
                  }
                  return InkWell(
                    onTap: (){
                      _processPlacement(index);
                    },
                    child: Center(
                      child: (){
                        switch(_board[index]){
                          case -1:
                            return Container(
                                decoration: const BoxDecoration(
                                    color: Colors.blueGrey
                            ),
                            );
                          case 0:
                            return Image.asset('img/X.png');
                          case 1:
                            return Image.asset('img/O.png');
                        }
                      }(),
                    ),
                  );
                }),
              );
            },
          ),
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (){
                if(_remaining > 0 && _winner == -1) {
                  return <Widget>[Container()];
                } else {
                  if(_winner == -1){
                    Vibration.vibrate(pattern: [100, 500, 100, 500]);
                    return <Widget>[
                      const Text('It\'s a tie! Press the refresh button to restart'),
                    ];
                  } else {
                    Vibration.vibrate(duration: 1000, amplitude: 80028);




                    return <Widget>[


                      const Text('The winner is '),

                      _playerImages[_winner],


                      const Text('! Press the refresh button to restart'),

                    ];
                  }
                }
              }(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 30,
                  child: _playerImages[0]
              ),
              Text(' ${_playerScore[0]} - ${_playerScore[1]} '),
              SizedBox(
                height: 30,
                child: _playerImages[1],
              ),
            ],
          )
        ],
      ),
      /*Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: _resetGameState,

        tooltip: 'Restart',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

