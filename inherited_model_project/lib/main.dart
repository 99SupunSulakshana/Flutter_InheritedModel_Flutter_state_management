import 'package:flutter/material.dart';
import 'dart:math' show Random;
import 'dart:developer' as devtools show log;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Inherited Model',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Inherited Model'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var color1 = Colors.yellow;
  var color2 = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: AvailableColorWidget(
            color1: color1,
            color2: color2,
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          color1 = colors.getRandomElement();
                        });
                      },
                      child: const Text('Change color1'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          color2 = colors.getRandomElement();
                        });
                      },
                      child: const Text('Change color2'),
                    ),
                  ],
                ),
                const ColorWidget(color: AvailableColors.one),
                const ColorWidget(color: AvailableColors.two)
              ],
            )));
  }
}

enum AvailableColors { one, two }

class AvailableColorWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  AvailableColorWidget({
    Key? key,
    required this.color1,
    required this.color2,
    required Widget child,
  }) : super(key: key, child: child);

  static AvailableColorWidget? Of(
      BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorWidget>(context,
        aspect: aspect);
  }

  @override
  bool updateShouldNotify(covariant AvailableColorWidget oldWidget) {
    devtools.log('updateShouldNotify');
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorWidget oldWidget,
      Set<AvailableColors> dependencies) {
    devtools.log('updateShouldNotify');
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }

    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }

    return false;
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors color;

  const ColorWidget({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devtools.log('Color1 widget got rebuilt!');
        break;

      case AvailableColors.two:
        devtools.log('Color2 widget got rebuilt!');
        break;
    }

    final provider = AvailableColorWidget.Of(context, color);

    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider?.color1 : provider?.color2,
    );
  }
}

final colors = [
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.brown,
  Colors.deepPurple
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}
