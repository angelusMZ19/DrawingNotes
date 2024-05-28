import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'DrawNote.dart';

class DrawScreen extends StatefulWidget {
  final DrawingNote note;
  final Function(DrawingNote) onSave;

  DrawScreen({
    required this.note,
    required this.onSave,
  });

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawScreen> {
  late List<Stroke> _strokes;

  Color currentColor = Colors.black;
  Color bgColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _strokes = widget.note.strokes;
  }

  void _startStroke(double x, double y) {
    setState(() {
      _strokes.add(Stroke(Path()..moveTo(x, y), currentColor));
    });
  }

  void _moveStroke(double x, double y) {
    setState(() {
      _strokes.last.path.lineTo(x, y);
    });
  }

  void _clearBoard() {
    setState(() {
      _strokes.clear();
    });
  }

  void _toggleEraser() {
    setState(() {
      currentColor = currentColor == bgColor ? Colors.black : bgColor;
    });
  }

  void _saveNote() {
    widget.onSave(DrawingNote(
      id: widget.note.id,
      strokes: _strokes,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing Note ${widget.note.id}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearBoard,
          ),
          IconButton(
            icon: Icon(MdiIcons.eraser),
            onPressed: _toggleEraser,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: GestureDetector(
        onPanDown: (details) => _startStroke(
          details.localPosition.dx,
          details.localPosition.dy,
        ),
        onPanUpdate: (details) => _moveStroke(
          details.localPosition.dx,
          details.localPosition.dy,
        ),
        child: Container(
          color: bgColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomPaint(
            painter: DrawingPainter(_strokes),
          ),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;

  DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..strokeWidth = 5
        ..color = stroke.color
        ..style = PaintingStyle.stroke;

      canvas.drawPath(stroke.path, paint);
    }
  }

  void dropDraw(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..strokeWidth = 10
        ..color = stroke.color
        ..style = PaintingStyle.stroke;

      canvas.drawPath(stroke.path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
