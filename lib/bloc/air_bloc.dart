import 'package:flutter_dust/models/air_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

class AirBloc {

  AirBloc(){
    fetch();
  }

  final _airSubject = BehaviorSubject<AirResult>();

  static const String myKey = 'a8abe539-9095-4c84-8f05-e8a594919fc3';

  Future<AirResult> fetchData() async {
    var url = Uri.http('api.airvisual.com', '/v2/nearest_city', { 'key' : myKey });
    var response = await http.get(url);
    return AirResult.fromJson(json.decode(response.body));
  }

  void fetch() async{
    print('fetch');
    var airResult = await fetchData();
    _airSubject.add(airResult);
  }

  Stream<AirResult> get airResult => _airSubject.stream;
}