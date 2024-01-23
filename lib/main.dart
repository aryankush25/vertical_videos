import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drag and Drop POC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Map<Key, Offset> items = {};
  final GlobalKey stackKey = GlobalKey();

  void addItem(Offset initialPosition) {
    var newItemKey = UniqueKey();
    setState(() {
      items[newItemKey] = initialPosition;
    });
  }

  void updateItemPosition(Key itemKey, Offset globalPosition) {
    RenderBox? renderBox =
        stackKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      Offset startPosition = renderBox.localToGlobal(Offset.zero);
      Offset newPosition = globalPosition - startPosition;

      setState(() {
        items[itemKey] = newPosition;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Drag and Drop POC'),
      ),
      body: Stack(
        key: stackKey,
        children: items.entries.map((entry) {
          return _buildDraggableItem(entry.key, entry.value);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addItem(const Offset(100, 100)),
        tooltip: 'Add Emoji',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDraggableItem(Key key, Offset initialPosition) {
    return Positioned(
      left: initialPosition.dx,
      top: initialPosition.dy,
      child: Draggable(
        data: key,
        feedback: const Material(
          elevation: 4.0,
          child: EmojiText('🙂'),
        ),
        onDragEnd: (details) => updateItemPosition(key, details.offset),
        child: const EmojiText('🙂'),
      ),
    );
  }
}

class EmojiText extends StatelessWidget {
  final String emoji;

  const EmojiText(this.emoji, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: const TextStyle(fontSize: 40),
    );
  }
}
