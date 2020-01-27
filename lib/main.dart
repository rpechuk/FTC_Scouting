import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class GameData {
  int _matchNumber;

  //auto
  int _autoSkystones = 0;
  set setAutoSkystones(skystones) => this._autoSkystones = skystones;
  int _autoStones = 0;
  set setAutoStones(stones) => this._autoStones = stones;
  bool _isRepositioned = false;
  bool get getReposition => this._isRepositioned;
  int _autoStonesPlaced = 0;
  set setAutoStonesPlaced(stones) => this._autoStonesPlaced = stones;
  bool _isNavigated = false;
  set setNavigation(navigate) => this._isNavigated = navigate;
  bool get getNavigation => this._isNavigated;

  //tele-op
  int _stonesDelivered = 0;
  int _stonesPlaced = 0;

  //endgame
  int _stonesInTallestSkyscraper = 0;
  bool _isCaped1 = false;
  int _levelsUnderCap1 = 0;
  bool _isCaped2 = false;
  int _levelsUnderCap2 = 0;
  bool _isFoundationMoved = false;
  bool _isParked = false;

  GameData (int matchNumber) {
    this._matchNumber = matchNumber;
  }
  set setReposition(bool reposition) => this._isRepositioned = reposition;
  String get getMatchName => this._matchNumber == 0 ? "Before Match" : "Qualification" + this._matchNumber.toString();

}

class TeamData {
  int _teamNumber;
  final _gameData = <GameData>[];

  TeamData(int teamNumber){
    this._teamNumber = teamNumber;
    for(int i = 0; i < 6; i++){
      _gameData.add(new GameData(i));
    }
  }

  int get getTeamNumber => this._teamNumber;

  String get getTeamName => this._teamNumber.toString();

  List<GameData> get getGameDataArray => this._gameData;
}

class RandomWordsState extends State<RandomWords> {
  final _teamData = <TeamData>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  bool val = false;

  void _addNewTeam() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(         // Add 6 lines from here...
            appBar: AppBar(
              title: Text('New Team'),
            ),
              body: TextField(
                  onSubmitted: (String value) {
                    setState(() {
                      _teamData.add(new TeamData((int.parse(value))));
                    });
                    Navigator.pop(context);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "Add Team Number",
                      icon: Icon(Icons.adb)
                  )
              ),
          );
        },
      ),
    );
  }

  void _pushTeamData(TeamData teamData) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(         // Add 6 lines from here...
            appBar: AppBar(
              title: Text(teamData.getTeamName),
            ),
            body: _buildGameDataList(teamData),
          );
        },
      ),
    );
  }

  void _pushGameData(GameData gameData, TeamData teamData) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(         // Add 6 lines from here...
            appBar: AppBar(
              title: Text(teamData.getTeamName + ": " +gameData.getMatchName),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    Text(
                        'Auto',
                        style: TextStyle(fontSize: 47, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                    ),
                    TextField(
                      onSubmitted: (String value) {
                        setState(() {
                          gameData._autoSkystones = int.parse(value);
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Number of skystones delivered in auto",
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    TextField(
                        onSubmitted: (String value) {
                          setState(() {
                            gameData._autoStones = int.parse(value);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Number of stones delivered in auto",
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    TextField(
                        onSubmitted: (String value) {
                          setState(() {
                            gameData._autoStonesPlaced = int.parse(value);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Number of stones placed in auto",
                        )
                    ),
                    SwitchListTile(
                      title: new Text("Is the robot Repositioned?"),
                      value: gameData.getReposition,
                      onChanged: (newVal) {
                        gameData._isRepositioned = newVal;
                      },
                    ),
                    SwitchListTile(
                      title: new Text("Is the robot Navigated?"),
                      value: gameData.getNavigation,
                      onChanged: (newVal) {
                        gameData._isNavigated = newVal;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    Text(
                      'Tele-Op',
                      style: TextStyle(fontSize: 47, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                    ),
                    TextField(
                        onSubmitted: (String value) {
                          setState(() {
                            gameData._stonesDelivered = int.parse(value);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Number of stones delivered in Tele-Op",
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    TextField(
                        onSubmitted: (String value) {
                          setState(() {
                            gameData._stonesPlaced = int.parse(value);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Number of stones placed in Tele-Op",
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    Text(
                      'End Game',
                      style: TextStyle(fontSize: 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                    ),
                    TextField(
                        onSubmitted: (String value) {
                          setState(() {
                            gameData._stonesInTallestSkyscraper = int.parse(value);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Number of stones in the tallest skyscraper",
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    SwitchListTile(
                      title: new Text("Is Cap 1 placed?"),
                      value: gameData._isCaped1,
                      onChanged: (newVal) {
                        gameData._isCaped1 = newVal;
                      },
                    ),
                    Visibility(
                      child: TextField(
                          onSubmitted: (String value) {
                            setState(() {
                              gameData._stonesInTallestSkyscraper = int.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Number of stones under Cap 1",
                          )
                      ),
                      visible: gameData._isCaped1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    SwitchListTile(
                      title: new Text("Is Cap 2 placed?"),
                      value: gameData._isCaped2,
                      onChanged: (newVal) {
                        gameData._isCaped2 = newVal;
                      },
                    ),
                    Visibility(
                      child: TextField(
                          onSubmitted: (String value) {
                            setState(() {
                              gameData._stonesInTallestSkyscraper = int.parse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Number of stones under Cap 2",
                          )
                      ),
                      visible: gameData._isCaped2,
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildGameDataList(TeamData team) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: team._gameData.length,
        itemBuilder: /*1*/ (context, i) {
          return _buildGameRow(team._gameData[i], team);
        });
  }

  Widget _buildGameRow(GameData gameData, teamData) {
    return
      Card(
          child: ListTile(
            title: Text(
              gameData.getMatchName,
              style: _biggerFont,
            ),
            onTap: () {
              _pushGameData(gameData, teamData);
            },
          ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team selector'),
      ),
      body: _buildSuggestions(),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNewTeam,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        )
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _teamData.length,
        itemBuilder: /*1*/ (context, i) {
          return _buildRow(_teamData[i]);
        });
  }

  Widget _buildRow(TeamData teamData) {
    return
      Card(
        child: ListTile(
          title: Text(
            teamData.getTeamName,
            style: _biggerFont,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.label, color: Colors.lightGreen),
                Icon(Icons.looks_one),
                Icon(Icons.looks_two),
                Icon(Icons.looks_3),
                Icon(Icons.looks_4),
                Icon(Icons.looks_5),
                Icon(Icons.arrow_forward_ios),
              ]),
          onTap: () {
            _pushTeamData(teamData);
          },
    ));
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scouting',
      theme: ThemeData(
        primaryColor: Colors.blueAccent
      ),
      home: RandomWords(),
    );
  }
}
