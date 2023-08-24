// To parse this JSON data, do
//
//     final share = shareFromJson(jsonString);

import 'dart:convert';

Share shareFromJson(String str) => Share.fromJson(json.decode(str));

String shareToJson(Share data) => json.encode(data.toJson());

class Share {
    String title;
    String subtitle;
    String value;
    String percent;

    Share({
        required this.title,
        required this.subtitle,
        required this.value,
        required this.percent,
    });

    factory Share.fromJson(Map<String, dynamic> json) => Share(
        title: json["title"],
        subtitle: json["subtitle"],
        value: json["value"],
        percent: json["percent"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "value": value,
        "percent": percent,
    };
}
