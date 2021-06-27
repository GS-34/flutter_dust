import 'package:flutter/material.dart';
import 'package:flutter_dust/bloc/air_bloc.dart';

import 'dart:convert';

import 'models/air_result.dart';

void main() {
  runApp(const MyApp());
}

final airBloc = AirBloc();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AirResult>(
      stream: airBloc.airResult,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return _buildBody(snapshot.data);
        } else{
          return Center(child : CircularProgressIndicator());
        }

      }
    );
  }

  Widget _buildBody(AirResult? _result) {
    return Padding(
    padding: EdgeInsets.all(8),
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '현재 위치 미세먼지',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('이미지'),
                        Text(//미세먼지 값
                          '${_result!.data.current.pollution.aqius}',
                          style: TextStyle(fontSize: 40),
                        ),
                        Text(
                          _getText(_result),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    color: _getColor(_result),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              child: Image.network('https://www.airvisual.com/images/50d.png'),
                              width: 25,
                              height: 25,
                            ),
                            SizedBox(width: 16),
                            Text(
                              '${_result!.data.current.weather.tp}°',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Text('습도 ${_result!.data.current.weather.hu}%'),
                        Text('풍속 ${_result!.data.current.weather.ws} m/s'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                onPressed: () {
                  airBloc.fetch();
                },
                color: Colors.orange,
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
  }

  Color _getColor(AirResult? result) {

    int aqius = result!.data.current.pollution.aqius;

    if(aqius <= 50){
      return Colors.greenAccent;
    } else if (aqius <= 100) {
      return Colors.yellow;
    } else if (aqius <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getText(AirResult? result) {
    int aqius = result!.data.current.pollution.aqius;

    if(aqius <= 50){
      return '좋음';
    } else if (aqius <= 100) {
      return '보통';
    } else if (aqius <= 150) {
      return '나쁨';
    } else {
      return '최악';
    }

  }
}
