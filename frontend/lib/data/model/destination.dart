import 'package:flutter/material.dart';

class Destination {
  Destination({required this.id, required this.icon, required this.labelKey});

  factory Destination.fromJson(Map<String, dynamic> json, String id) {
    return Destination(id: id, icon: json['icon'], labelKey: json['labelKey']);
  }

  String id;
  IconData icon;
  String labelKey;
}
