import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'package:timmergame/timertext.dart';
import 'package:timmergame/model.dart';
import 'package:numberpicker/numberpicker.dart';

void main() => runApp(MyGameApp());

class MyGameApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: MyGameAppHome(),
      ),
    // MyGameAppHome(),
    );
  }
}

class MyGameAppHome extends StatefulWidget{
  MyGameAppHome({Key key}) : super(key: key);
  @override
  _MyGameAppState createState() => new  _MyGameAppState();
}

class _MyGameAppState extends State<MyGameAppHome>{
  
  final Dependencies dependencies = new Dependencies();
  AnimationController animationController;

  List<GameButton> buttonsList;
  int gridLength = 0;
  int nextPress = 0;
  int _currentValue = 3;

  var fontsizes = {
    3: 20.0,
    4: 11.5,
    5: 10.5,
    6: 10.2,
    7: 9.7,
    8: 9.5,
    9: 9.2,
    10: 9.0
  };
  // bool _visible = true;

  @override
  void initState() {
    super.initState();
    gridLength = 3;
    _currentValue=3;
    buttonsList = doInit();
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Number Game'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Select Grid Size"),
                    content: new Row(
                    children: <Widget>[
                      new Expanded(
                        child:
                        new NumberPicker.integer(
                        initialValue: _currentValue,
                        minValue: 3,
                        maxValue: 10,
                        onChanged:  (newValue) {
                         setState(() => _currentValue = newValue);
                        }
                        ),
                      )
                    ],
                  ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("Close"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                      new FlatButton(
                        child: new Text("Set"),
                        onPressed: (){
                          dependencies.stopwatch.stop();
                          dependencies.stopwatch.reset();
                          setState(() {
                            gridLength = _currentValue;//int.tryParse(_currentValue);
                            buttonsList = doInit();
                          });
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
              );
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
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                color: Colors.blue,
                  height: 50.0,
                  width: 50.0,
              ),
              
              new Expanded(
                child: new GridView.builder(
                  padding: const EdgeInsets.fromLTRB(3, 8, 3, 1),
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridLength,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0
                  ),
                  itemCount: gridLength*gridLength,
                  itemBuilder: (context, i) => new SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: new RaisedButton(
                      padding: const EdgeInsets.all(9.0),
                      child: new Text(
                        '${buttonsList[i].id}',
                         style: new TextStyle(color: Colors.white, fontSize: fontsizes[gridLength]),
                        ),
                      color: buttonsList[i].bg,
                      splashColor: (nextPress == buttonsList[i].id)?Colors.green:Colors.red,
                      disabledColor: Colors.white,
                      onPressed: !buttonsList[i].showhide ? null : () {
                        if(nextPress == buttonsList[i].id){
                        dependencies.stopwatch.start();
                        setState(() {
                          if(buttonsList.length > (nextPress)+(gridLength*gridLength)){
                              buttonsList[i] = buttonsList[(nextPress)+(gridLength*gridLength)];
                          }else{
                              buttonsList[i].showhide = !buttonsList[i].showhide;
                          }
                          if(nextPress == (gridLength*gridLength)*2){
                              dependencies.stopwatch.stop();
                              final snackBar = SnackBar(
                                content: Text('Game Over'),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                          }
                        });
                        nextPress =nextPress+1;
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
              onPressed: (){
                dependencies.stopwatch.stop();
                dependencies.stopwatch.reset();
                setState(() {
                  buttonsList = doInit();
                });
              },
            ),
            ],
      ),
  );
}

}
