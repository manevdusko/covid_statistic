import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Stat.dart';

//get data from api
Future<Stat> getCovidData(DateTime forDay) async {
  final response = await http.get(Uri.https('api.treker.mk', 'api/stats'));

  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
    List<Stat> lista = parsed.map<Stat>((json) => Stat.fromMap(json)).toList();
    Stat fStat = Stat(
        day: 0,
        month: 0,
        year: 0,
        tests: 0,
        positive: 0,
        vakcinirani: 0,
        vakcinirani2: 0,
        hospitalizirani: 0,
        pocinati: 0,
        kriticni: 0);
    for (Stat s in lista) {
      if (forDay.day == s.day &&
          forDay.month == s.month &&
          forDay.year == s.year) {
        fStat = s;
      }
    }
    return fStat;
  } else {
    throw Exception("Failed to load data");
  }
}

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<int> data;
  DateTime _myDateTime = DateTime.now();
  String time = "";

  late Future<Stat> statistic;

  @override
  void initState() {
    super.initState();
    statistic = getCovidData(_myDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Ковид статистика',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
            appBar: AppBar(title: Text("Ковид статистика")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<Stat>(
                    future: statistic,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: double.infinity,
                          child: Card(
                              color: Theme.of(context).colorScheme.secondary,
                              child: Column(
                                children: [
                                  Text(
                                    (() {
                                      if (snapshot.data!.tests == 0) {
                                        return "";
                                      }

                                      return "Статистика за: ${snapshot.data!.day}.${snapshot.data!.month}.${snapshot.data!.year}";
                                    })(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    (() {
                                      if (snapshot.data!.tests == 0) {
                                        return "";
                                      }

                                      return "Вкупно направени тестови: ${snapshot.data!.tests}";
                                    })(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    (() {
                                      if (snapshot.data!.tests == 0) {
                                        return "За избраниот датум нема податоци";
                                      }

                                      return "Позитивни: ${snapshot.data!.positive}";
                                    })(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    (() {
                                      if (snapshot.data!.tests == 0) {
                                        return "";
                                      }

                                      return "Хоспитализирани: ${snapshot.data!.hospitalizirani}";
                                    })(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    (() {
                                      if (snapshot.data!.tests == 0) {
                                        return "";
                                      }

                                      return "Критични: ${snapshot.data!.kriticni}";
                                    })(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    (() {
                                      if (snapshot.data!.tests == 0) {
                                        return "";
                                      }

                                      return "Починати: ${snapshot.data!.pocinati}";
                                    })(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    (() {
                                      if (snapshot.data!.tests == 0) {
                                        return "";
                                      }

                                      return "Вакцинирани: ${snapshot.data!.vakcinirani2}";
                                    })(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              )),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _myDateTime = (await showDatePicker(
                          context: context,
                          initialDate: _myDateTime,
                          firstDate: DateTime(2021),
                          lastDate: DateTime.now()))!;

                      setState(() {
                        statistic = getCovidData(_myDateTime);
                        time = _myDateTime.toString();
                      });
                    },
                    child: Text('Избери датум'),
                  ),
                ],
              ),
            )));
  }
}
