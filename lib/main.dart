import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'package:timmergame/timertext.dart';
import 'package:timmergame/model.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:async';
import 'package:share/share.dart';
import 'package:timmergame/Database.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyGameApp());

class MyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartBrain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: MyGameAppHome(),
      ),
    );
  }
}

class MyGameAppHome extends StatefulWidget{
  MyGameAppHome({Key key}) : super(key: key);
  @override
  _MyGameAppState createState() => new  _MyGameAppState();
}

class _MyGameAppState extends State<MyGameAppHome>{

  List notes;
  var db = new DatabaseHelper();
  // int maxgridSize = 1;

  Future getvaluesmain() async {
  // print('=== getAllNotes() ===');
  int maxgridSize = await db.getCount();
  // print(maxgridSize);
  if(maxgridSize !=null){
  
  dependencies.stopwatch.stop();
  dependencies.stopwatch.reset();
  
  setState(() {
    gridLength = maxgridSize;
    _currentValue = maxgridSize;
    buttonsList = doInit();
  });
  
  }
  }
  Future getNotes() async {
  // print(maxgridSize);
  var localnotes = await db.getAllNotes();
    setState(() {
      notes = localnotes;
    });
  // notes.forEach((note) => print(note));
  }

  final Dependencies dependencies = new Dependencies();
  AnimationController animationController;

  List<GameButton> buttonsList;
  int gridLength = 0;
  int nextPress = 0;
  int _currentValue = 1;
  
  @override
  void initState() {
    super.initState();
    gridLength = 1;
    _currentValue=1;
    buttonsList = doInit();
    getvaluesmain();
    getNotes();
  }

  
  List shuffle(List items) {
    var random = new Math.Random();
    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
    }
    return items;
  }

  List<GameButton> doInit() {
   nextPress = 1;
   var numberlist = [];
   var sequncenumbers = [];
   var totalGridNumbers = gridLength*gridLength;
   var endNumber = 0;
   for (var i = 1; i <= totalGridNumbers; i++) {
    numberlist.add(i);
    endNumber = i;
   }
   var fromStartingNumber = endNumber;
   for (var i = fromStartingNumber; i <= totalGridNumbers+fromStartingNumber; i++) {
    sequncenumbers.add(i);
   }
   List<GameButton> newObjectList = [];
   shuffle(numberlist).forEach((val)=>{
     newObjectList.add(new GameButton(id:val))
   });
   sequncenumbers..forEach((val)=>{
     newObjectList.add(new GameButton(id:val))
   });
   return newObjectList;
  }

     void _showDialog() {
          showDialog<int>(
            context: context,
            builder: (BuildContext context) {
              return new NumberPickerDialog.integer(
                minValue: 1,
                maxValue: 10,
                title: new Text("Select Grid Size"),
                initialIntegerValue: _currentValue,
              );
            }
          ).then((value) {
            if (value != null) {
              setState(() => _currentValue = value);
              dependencies.stopwatch.stop();
              dependencies.stopwatch.reset();
              setState(() {
              gridLength = _currentValue;
              buttonsList = doInit();
              });
            }
          });
        }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.history),
          tooltip: 'Challenges',
          onPressed: () => {
              //main(),
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                builder: (BuildContext context) {
                  
                  
                  return new Scaffold(
                    appBar: new AppBar(
                      title: const Text('Best Challenges'),
                    ),
                    body: 
                    
                    new Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: notes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
                          elevation: 8.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: new BorderRadius.all(Radius.circular(6.0)),
                            ),
                            child: new ListTile(
                              contentPadding:EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              leading: Container(
                              padding: EdgeInsets.only(right: 8.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                    right: new BorderSide(width: 1.0, color: Colors.white24)
                                  ),
                                  ),
                              child: Text(
                                notes[index]['title'],
                                style: dependencies.textStyle
                                // style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              trailing:
                              Icon(Icons.history, color: Colors.white, size: 30.0),
                              
                              title: new Column(
                              children:<Widget>[
                                  new Text(
                                  (notes[index]['grid']).toString()+' X '+(notes[index]['grid']).toString(),
                                  //'$notes[index][\'grid\'] X $notes[index][\'grid\']',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  new Text(
                                    notes[index]['description'],
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  )
                              ] 
                              )
                            ),
                          ),
                        );
                      },
                    ),
                  ),


                  );
                },
              fullscreenDialog: true
              )
            ),
          },
        ),
        title: Text('Challenge - ${gridLength}X${gridLength}'),
        automaticallyImplyLeading:true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Share',
            onPressed: (){
              Share.share('Check out SmartBrain App, Train your brain click below link to install - https://play.google.com/store/apps/details?id=com.gvnreddy.timmergame');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: (){
              _showDialog();
            },
          ),
        ],
        ),
      body: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: new TimerText(dependencies: dependencies),
                padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                color: Colors.blue,
                  height: 60.0,
                  width: 50.0,
              ),
              new Expanded(
                child: new GridView.builder(
                  physics: new NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  // primary: true,
                  padding: const EdgeInsets.fromLTRB(3, 8, 3, 1),
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridLength,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0
                  ),
                  itemCount: gridLength*gridLength,
                  itemBuilder: (context, i) => new SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: 
                      new GestureDetector(
                        // Our Custom Button!
                          child: Container(
                            padding: EdgeInsets.all(8.9),
                            decoration: BoxDecoration(
                              color: buttonsList[i].bg,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: 
                            FittedBox(
                            child: Center(
                              child: new Text(
                              '${buttonsList[i].id}',
                               textAlign: TextAlign.center,
                               style: new TextStyle(
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold
                                 ),
                            ),
                            ),
                            fit: BoxFit.contain,
                            )
                          ),
                          onTap: !buttonsList[i].showhide ? null : () {
                            if(buttonsList[i].showhide){
                              if(nextPress == buttonsList[i].id){
                              dependencies.stopwatch.start();
                              setState(() {
                                if(buttonsList.length > (nextPress)+(gridLength*gridLength)){
                                    buttonsList[i] = buttonsList[(nextPress)+(gridLength*gridLength)];
                                }else{
                                    buttonsList[i].showhide = !buttonsList[i].showhide;
                                    buttonsList[i].bg = Colors.white;
                                }
                                if(nextPress == (gridLength*gridLength)*2){
                                    dependencies.stopwatch.stop();
                                    _askUser();
                                }
                              });
                              nextPress =nextPress+1;
                              }
                            }
                          },
                          
                      )
                  )
                )  
              ),
              new RaisedButton(
                child: new Text(
                  "Reset",
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.blue,
                padding: const EdgeInsets.all(20.0),
                onPressed: ()=>_resetGame(),
              ),
            ],
      ),
  );
}
// csutorm methonds implementations

  Future _resetGame() async{
        dependencies.stopwatch.stop();
        dependencies.stopwatch.reset();
        setState(() {
        buttonsList = doInit();
        });
  }

  Future _nextStep() async {
    dependencies.stopwatch.stop();
    dependencies.stopwatch.reset();
    setState(() {
      //print(gridLength);
      gridLength = gridLength+1;
      buttonsList = doInit();
    });
    Navigator.of(context).pop();
  }
    Future _askUser() async {
    DateTime now = DateTime.now();
    // dependencies.stopwatch.

    int milliseconds = dependencies.stopwatch.elapsedMilliseconds;
    final int hundreds = (milliseconds / 10).truncate();
    final int seconds = (hundreds / 100).truncate();
    final int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    String lapString = "$minutesStr:$secondsStr:$hundredsStr";
    // print("$minutesStr:$secondsStr:$hundredsStr");

    String formattedDate = DateFormat('dd-MMM-yyyy').format(now);
    await db.saveNoteAll(new Note(gridLength,lapString, formattedDate));
    // var gridvalues = await db.getGrid(gridLength);
    // print(gridvalues.grid);
    // print('----------');
    getNotes();
    await 
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // TimerText display = new TimerText(dependencies: dependencies);
          return 
          new SimpleDialog(
          title: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                    new Text("Great Job!  ",style: TextStyle(color: Colors.blueAccent)),
                    new Container(
                      child: new Text(lapString,style: dependencies.textStyle),
                      padding: EdgeInsets.fromLTRB(10, 6, 10, 4),
                      color: Colors.blue,
                    ),
                    new RaisedButton(
                          onPressed: (){
                              Navigator.of(context, rootNavigator: true).pop();
                              _resetGame();
                          },
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Challenge Again?', style: TextStyle(color: Colors.white),),
                              Icon(Icons.settings_backup_restore, color: Colors.white,),
                            ],
                          ),
                          color: Colors.blue,
                        ),
                    new RaisedButton(
                          onPressed: (){
                            _nextStep();
                          },
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Try Next!', style: TextStyle(color: Colors.white),),
                              Icon(Icons.play_arrow, color: Colors.white,),
                            ],
                          ),
                          color: Colors.blue,
                        ),
              ],
            ),
          ),
        ); 
    }
    );
  }
}