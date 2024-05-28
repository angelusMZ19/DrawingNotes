import 'package:flutter/material.dart';

class DrawingNote {
  final String id;
  final List<Stroke> strokes;

  DrawingNote({
    required this.id,
    required this.strokes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'strokes': strokes
            .map((s) => {
                  'color': s.color.value,
                  'path': s.path
                      .getBounds()
                      .toString() // Simple serialization (improve as needed)
                })
            .toList(),
      };

  factory DrawingNote.fromJson(Map<String, dynamic> json) {
    return DrawingNote(
      id: json['id'],
      strokes: (json['strokes'] as List)
          .map((s) => Stroke(
                Path()..addRect(Rect.fromLTRB(0, 0, 100, 100)), // Example path
                Color(s['color']),
              ))
          .toList(),
    );
  }
}

class Stroke {
  final Path path;
  final Color color;

  Stroke(this.path, this.color);
}
