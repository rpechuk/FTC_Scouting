import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());
// chang contents of this class to accept "app key"
class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  change() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', false);
  }

}

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

  Map<String, dynamic> toJson() => {
    'autoSkystones': _autoSkystones.toString(),
    'autoStones': _autoStones.toString(),
    'isRepositioned': _isRepositioned.toString(),
    'autoStonesPlaced': _autoStonesPlaced.toString(),
    'isNavigated': _isNavigated.toString(),
    'stonesDelivered': _stonesDelivered.toString(),
    'stonesPlaced': _stonesPlaced.toString(),
    'stonesInTallestSkyscraper': _stonesInTallestSkyscraper.toString(),
    'isCaped1': _isCaped1.toString(),
    'levelsUnderCap1': _levelsUnderCap1.toString(),
    'isCaped2': _isCaped2.toString(),
    'levelsUnderCap2': _levelsUnderCap2.toString(),
    'isFoundationMoved': _isFoundationMoved.toString(),
    'isParked': _isParked.toString(),
  };
// ToDo: FIX ME int.parse is being wierd
//  GameData.fromJson(Map<String, dynamic> json)
//  : _autoSkystones = int.parse(json['autoSkystones']),
//        _autoStones = int.parse(json['autoStones']),
//        _isRepositioned = (json['isRepositioned']).toString().toLowerCase() == 'true',
//        _autoStonesPlaced = int.parse(json['autoStonesPlaced']),
//        _isNavigated = (json['isNavigated']).toString().toLowerCase() == 'true',
//        _stonesDelivered = int.parse(json['stonesDelivered']),
//        _stonesPlaced = int.parse(json['stonesPlaced']),
//        _stonesInTallestSkyscraper = int.parse(json['stonesInTallestSkyscraper']),
//        _isCaped1 = (json['isCaped1']).toString().toLowerCase() == 'true',
//        _levelsUnderCap1 = int.parse(json['levelsUnderCap1']),
//        _isCaped2 = (json['isCaped2']).toString().toLowerCase() == 'true',
//        _levelsUnderCap2 = int.parse(json['levelsUnderCap2']),
//        _stonesInTallestSkyscraper = int.parse(json['stonesInTallestSkyscraper']),
//        _isFoundationMoved = (json['isFoundationMoved']).toString().toLowerCase() == 'true',
//        _isParked = (json['isParked']).toString().toLowerCase() == 'true';
}

class TeamData {
  int _teamNumber;
  final _gameData = <GameData>[];

  TeamData(int teamNumber) {
    this._teamNumber = teamNumber;
    for (int i = 0; i < 6; i++) {
      _gameData.add(new GameData(i));
    }
  }
  int get getTeamNumber => this._teamNumber;

  String get getTeamName => this._teamNumber.toString();

  List<GameData> get getGameDataArray => this._gameData;

  Map<String, dynamic> toJson() => {
    'teamNumber' : _teamNumber.toString(),
    'm0' : json.encode(_gameData[0]),
    'm1' : json.encode(_gameData[1]),
    'm2' : json.encode(_gameData[2]),
    'm3' : json.encode(_gameData[3]),
    'm4' : json.encode(_gameData[4]),
    'm5' : json.encode(_gameData[5]),
  };
}

class TeamSelectorState extends State<TeamSelector> {
  final _teamData = <TeamData>[];
  SharedPref sharedPref = SharedPref();

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    if (firstTime != null && !firstTime) {// Not first time
    } else {// First time
      navigationPageWel();
    }
  }

  void navigationPageHome() {
    Navigator.of(context).pushReplacementNamed('/HomePage');
  }

  void navigationPageWel() {
    Navigator.of(context).pushReplacementNamed('/WelcomePage');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

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
          return Scaffold(
            appBar: AppBar(
              title: Text(teamData.getTeamName + ": " +gameData.getMatchName),
            ),
            body: Center(
              child: ScoreEditor(gameData),
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
          onLongPress: () {
            setState(() {_teamData.remove(teamData);});
          },
    ));
  }
}

class TeamSelector extends StatefulWidget {
  @override
  TeamSelectorState createState() => TeamSelectorState();
}

class KeySelector extends StatefulWidget {
  @override
  KeySelectorState createState() => KeySelectorState();
}

class KeySelectorState extends State<KeySelector> {
  SharedPref sharedPref = SharedPref();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Key'),
      ),
      body: TextField(
          onSubmitted: (String value) {
            sharedPref.change();
            if(sharedPref.read(value) != null){
              //enter string into the database/access value from here
            } else {
              sharedPref.save(value, value);
              //make new colum in database
            }
            Navigator.pushNamed(context, '/HomePage');
          },
          decoration: InputDecoration(
              hintText: "Enter Key",
              icon: Icon(Icons.vpn_key)
          )
      ),
    );
  }
}

class ScoreEditorState extends State<ScoreEditor> {
  GameData _gameData;

  ScoreEditorState (GameData gameData){
        _gameData = gameData;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  _gameData._autoSkystones = int.parse(value);
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
                  _gameData._autoStones = int.parse(value);
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
                  _gameData._autoStonesPlaced = int.parse(value);
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
            value: _gameData.getReposition,
            onChanged: (newVal) {
              _gameData._isRepositioned = newVal;
            },
          ),
          SwitchListTile(
            title: new Text("Is the robot Navigated?"),
            value: _gameData.getNavigation,
            onChanged: (newVal) {
              _gameData._isNavigated = newVal;
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
                  _gameData._stonesDelivered = int.parse(value);
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
                  _gameData._stonesPlaced = int.parse(value);
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
                  _gameData._stonesInTallestSkyscraper = int.parse(value);
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
            title: new Text("Is Cap placed?"),
            value: _gameData._isCaped1,
            onChanged: (newVal) {
              _gameData._isCaped1 = newVal;
              setState(() {});
            },
          ),
          Visibility(
            child: TextField(
                onSubmitted: (String value) {
                  setState(() {
                    _gameData._stonesInTallestSkyscraper = int.parse(value);
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Number of stones under Cap 1",
                )
            ),
            visible: _gameData._isCaped1,
          ),

        ],
      ),
    );
  }

}

class ScoreEditor extends StatefulWidget {
  GameData _gameData;
  ScoreEditor(GameData gameData){
    _gameData = gameData;
  }
  @override
  ScoreEditorState createState() => ScoreEditorState(_gameData);
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
      home: new TeamSelector(),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => new TeamSelector(),
        '/WelcomePage': (BuildContext context) => new KeySelector()
      },
    );
  }
}
