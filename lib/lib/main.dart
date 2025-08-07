import 'package:flutter/material.dart';

void main() {
  runApp(SetLyricPrompterApp());
}

class SetLyricPrompterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SetLyric Prompter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LyricListScreen(),
    );
  }
}

class LyricListScreen extends StatefulWidget {
  @override
  _LyricListScreenState createState() => _LyricListScreenState();
}

class _LyricListScreenState extends State<LyricListScreen> {
  final List<Map<String, String>> _lyrics = [
    {'title': 'Song 1', 'lyrics': 'These are the lyrics for song 1...'},
    {'title': 'Song 2', 'lyrics': 'These are the lyrics for song 2...'},
  ];

  void _addLyric(String title, String lyrics) {
    setState(() {
      _lyrics.add({'title': title, 'lyrics': lyrics});
    });
  }

  void _deleteLyric(int index) {
    setState(() {
      _lyrics.removeAt(index);
    });
  }

  void _showAddLyricDialog() {
    String title = '';
    String lyrics = '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add New Lyrics'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Song Title'),
                onChanged: (val) => title = val,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Lyrics'),
                maxLines: 5,
                onChanged: (val) => lyrics = val,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (title.isNotEmpty && lyrics.isNotEmpty) {
                _addLyric(title, lyrics);
              }
              Navigator.of(ctx).pop();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SetLyric Prompter'),
      ),
      body: ListView.builder(
        itemCount: _lyrics.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(_lyrics[index]['title']!),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => LyricDisplayScreen(
                  title: _lyrics[index]['title']!,
                  lyrics: _lyrics[index]['lyrics']!,
                ),
              ));
            },
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteLyric(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddLyricDialog,
      ),
    );
  }
}

class LyricDisplayScreen extends StatefulWidget {
  final String title;
  final String lyrics;

  LyricDisplayScreen({required this.title, required this.lyrics});

  @override
  _LyricDisplayScreenState createState() => _LyricDisplayScreenState();
}

class _LyricDisplayScreenState extends State<LyricDisplayScreen> {
  double _scrollSpeed = 50.0; // pixels per second
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() async {
    await Future.delayed(Duration(seconds: 1));
    while (_scrollController.hasClients) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(
          seconds: (_scrollController.position.maxScrollExtent / _scrollSpeed)
              .round(),
        ),
        curve: Curves.linear,
      );
      await Future.delayed(Duration(seconds: 2));
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(16.0),
        child: Text(
          widget.lyrics,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
