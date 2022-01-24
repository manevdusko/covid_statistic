import 'dart:convert';

List<Stat> postFromJson(String str) =>
    List<Stat>.from(json.decode(str).map((x) => Stat.fromMap(x)));

class Stat {
  final int year,
      month,
      day,
      kriticni,
      hospitalizirani,
      tests,
      positive,
      vakcinirani,
      vakcinirani2,
      pocinati;

  Stat(
      {required this.year,
      required this.month,
      required this.day,
      required this.tests,
      required this.positive,
      required this.vakcinirani,
      required this.vakcinirani2,
      required this.hospitalizirani,
      required this.kriticni,
      required this.pocinati});

  factory Stat.fromMap(Map<String, dynamic> json) => Stat(
        day: json["day"] ?? 0,
        year: json["year"] ?? 0,
        month: json["month"] ?? 0,
        tests: json["performedTests"] ?? 0,
        positive: json["positiveTests"] ?? 0,
        vakcinirani: json["vaccination"]["administered"]["toDate"] ?? 0,
        vakcinirani2: json["vaccination"]["administered2nd"]["toDate"] ?? 0,
        hospitalizirani: json["statePerTreatment"]["inHospital"] ?? 0,
        pocinati: json["statePerTreatment"]["deceased"] ?? 0,
        kriticni: json["statePerTreatment"]["critical"] ?? 0,
      );
}
