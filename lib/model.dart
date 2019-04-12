import 'package:flutter/material.dart';
// import 'dart:convert';

class GameButton{
  final id;
  String nb;
  Color bg;
  bool showhide;
  GameButton({
    this.id,
    this.nb = '',
    this.bg = Colors.blue,
    this.showhide = true
  });
}
// timer logic
class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}
// for timer
class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners = <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle = const TextStyle(fontSize: 30.0, fontFamily: "Bebas Neue",color: Colors.white);
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}


class Note {
  int _id;
  int _grid;
  String _title;
  String _description;
 
  Note(this._grid,this._title, this._description);
 
  Note.map(dynamic obj) {
    this._id = obj['id'];
    this._grid = obj['grid'];
    this._title = obj['title'];
    this._description = obj['description'];
  }
 
  int get id => _id;
  int get grid => _grid;
  String get title => _title;
  String get description => _description;
 
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['grid'] = _grid;
    map['title'] = _title;
    map['description'] = _description;
 
    return map;
  }
 
  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._grid = map['grid'];
    this._title = map['title'];
    this._description = map['description'];
  }
}
