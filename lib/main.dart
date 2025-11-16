import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

//Widgets are the elements from which you build every Flutter app
//sets up the whole app (app-wide-state, visual theme. sets "home"-widget, etc.)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(0, 255, 0, 1.0)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

//MyAppState defines the Apps state.
//defines Data the app needs to function
/*
- extends ChangeNotifier: notify other classes about its own changes
- the state is created and provided to the whole app using a ChangeNotifierProvider.
-> Allows any widget to get hold of the state
*/
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext(){
    current = WordPair.random();
    //notifyListers() is a method of ChangeNotifier that ensures anyone watching MyAppState is notified.
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override

  //every widget defines a build()-method ->automatically called when widgets circumstances changes
  // ->Every build()- Method must return a widget or a nested tree of widgets
  Widget build(BuildContext context) {
    //Widget tracks changes to the apps current state
    var appState = context.watch<MyAppState>();
    var pair = appState.current; 

        IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          //vertical alignment
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            //SizedBox is commonly used to create visual gaps (like padding)
            SizedBox(height: 10),
            Row(
              //tell Row not to take away all horizontal space
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text("like")
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
            ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    //custom theme and style
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase, 
          style: style,
          //semanticsLabel for accessibility, e.g. screenreaders.
          semanticsLabel: "${pair.first} ${pair.second}",
          ),
      ),
    );
  }
}