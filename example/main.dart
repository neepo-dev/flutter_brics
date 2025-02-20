import 'package:flutter/material.dart';
import 'package:brics/brics.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Brics Examples')),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            spacing: 30,
            children: [

              // Simple example
              Brics(
                children: [
                  Bric(
                    size: {
                      BricWidth.xs: 6,
                      BricWidth.md: 4,
                      BricWidth.lg: 4,
                    },
                    child: ExampleBox(text: 'Box 1', color: Colors.lightGreen),
                  ),
                  Bric(
                      size: {
                        BricWidth.xs: 6,
                        BricWidth.md: 8,
                        BricWidth.lg: 4,
                      },
                      child: ExampleBox(text: 'Box 2', color: Colors.blueGrey)
                  ),
                  Bric(
                    size: {
                      BricWidth.md: 12,
                      BricWidth.lg: 4,
                    },
                    child: ExampleBox(text: 'Box 3', color: Colors.lightBlue),
                  ),
                ],
              ),

              // Complex example
              Container(
                color: Colors.black12,
                child: Brics(
                  padding: EdgeInsets.all(10),
                  maxWidth: 800,
                  gap: 10,
                  crossGap: 10,
                  children: [

                    Bric(
                      size: {
                        BricWidth.xs: 12,
                        BricWidth.sm: 6,
                        BricWidth.md: 4,
                      },
                      child: ExampleCard(text: 'Card 1'),
                    ),
                    Bric(
                      size: {
                        BricWidth.xs: 12,
                        BricWidth.sm: 6,
                        BricWidth.md: 4,
                      },
                      child: ExampleCard(text: 'Card 2'),
                    ),
                    Bric(
                      size: {
                        BricWidth.xs: 12,
                        BricWidth.sm: 4,
                        BricWidth.md: 4,
                      },
                      child: ExampleCard(text: 'Card 3'),
                    ),
                    Bric(
                      size: {
                        BricWidth.xs: 12,
                        BricWidth.sm: 4,
                        BricWidth.md: 2,
                      },
                      child: ExampleCard(text: 'Card 4'),
                    ),
                    Bric(
                      size: {
                        BricWidth.xs: 12,
                        BricWidth.sm: 4,
                        BricWidth.md: 8,
                      },
                      child: ExampleCard(text: 'Card 5'),
                    ),
                    Bric(
                      size: {
                        BricWidth.xs: 12,
                        BricWidth.sm: 6,
                        BricWidth.md: 2,
                      },
                      child: ExampleCard(text: 'Card 6'),
                    ),
                    Bric(
                      size: {
                        BricWidth.xs: 12,
                        BricWidth.sm: 6,
                        BricWidth.md: 12,
                      },
                      child: ExampleCard(text: 'Card 7'),
                    ),

                  ],
                ),
              ),

              // Inside Dialog example
              OutlinedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Brics in AlertDialog'),
                    content: Brics(
                        gap: 10,
                        crossGap: 10,

                        // set the width for Dialog
                        width: 500,

                        children: [

                          Bric(
                            size: const { BricWidth.sm: 6 },
                            child: ExampleCard(text: 'Card 1'),
                          ),
                          Bric(
                            size: const { BricWidth.sm: 6 },
                            child: ExampleCard(text: 'Card 2'),
                          ),

                        ]
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
                child: Text('Dialog Example'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class ExampleBox extends StatelessWidget {
  final String text;
  final Color color;
  const ExampleBox({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: color,
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

class ExampleCard extends StatelessWidget {
  final String text;
  const ExampleCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: SizedBox(height: 40, child: Center(child: Text(text))),
    );
  }
}