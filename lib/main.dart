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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
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
}

class MyHomePage extends StatelessWidget {
  @override

  //every widget defines a build()-method ->automatically called when widgets circumstances changes
  // ->Every build()- Method must return a widget or a nested tree of widgets
  Widget build(BuildContext context) {
    //Widget tracks changes to the apps current state
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A random AWESOME idea:'), 
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          ),
          ],
      ),
    );
  }
}