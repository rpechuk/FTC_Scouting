import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class GameData {
  int _matchNumber;

  //auto
  int _autoSkystones;
  int _autoStones;
  bool _isRepositioned;
  int _autoStonesPlaced;
  bool _isNavigated;

  //tele-op
  int _stonesDelivered;
  int _stonesPlaced;

  //endgame
  int _stonesInTallestSkyscraper;
  bool _isCaped1;
  int _levelsUnderCap1;
  bool _isCaped2;
  int _levelsUnderCap2;
  bool _isFoundationMoved;
  bool _isParked;

  GameData (int matchNumber) {
    this._matchNumber = matchNumber;
  }

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
}

class RandomWordsState extends State<RandomWords> {
  final _teamData = <TeamData>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

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


  Widget _buildGameDataList(TeamData team) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: team._gameData.length,
        itemBuilder: /*1*/ (context, i) {
          return _buildGameRow(team._gameData[i]);
        });
  }

  Widget _buildGameRow(GameData gameData) {
    return
      Card(
          child: ListTile(
            title: Text(
              gameData.getMatchName,
              style: _biggerFont,
            ),
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
