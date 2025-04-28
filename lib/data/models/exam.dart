// lib/data/models/exam.dart
import 'package:flutter/material.dart';

class Exam {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}