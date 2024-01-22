import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drag and Drop POC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<Key, Offset> items = {};

  void addItem(Offset initialPosition) {
    var newItemKey = UniqueKey();
    setState(() {
      items[newItemKey] = initialPosition;
    });
  }

  void updateItemPosition(Key itemKey, Offset newPosition) {
    setState(() {
      items[itemKey] = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Drag and Drop POC'),
      ),
      body: Stack(
        children: items.entries.map((entry) {
          return _buildDraggableItem(entry.key, entry.value);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addItem(Offset(100, 100)),
        tooltip: 'Add Emoji',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDraggableItem(Key key, Offset initialPosition) {
    return Positioned(
      left: initialPosition.dx,
      top: initialPosition.dy,
      child: Draggable(
        data: key,
        child: EmojiText('🙂'),
        feedback: Material(
          child: EmojiText('🙂'),
          elevation: 4.0,
        ),
        onDragEnd: (details) => updateItemPosition(key, details.offset),
      ),
    );
  }
}

class EmojiText extends StatelessWidget {
  final String emoji;

  EmojiText(this.emoji);

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: TextStyle(fontSize: 40),
    );
  }
}
