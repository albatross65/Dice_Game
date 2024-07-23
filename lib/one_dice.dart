import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(OneDice());
}

class OneDice extends StatelessWidget {
  const OneDice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiceWithStateful(),
    );
  }
}

class DiceWithStateful extends StatefulWidget {
  const DiceWithStateful({super.key});

  @override
  State<DiceWithStateful> createState() => _DiceWithStatefulState();
}

class _DiceWithStatefulState extends State<DiceWithStateful>
    with SingleTickerProviderStateMixin {
  int diceNumber = 1;
  int score1 = 0;
  int score2 = 0;
  int currentPlayer = 1;
  bool isRolling = false;
  bool gameOver = false;
  String winner = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  void rollDice() {
    setState(() {
      isRolling = true;
      _controller.reset();
      _controller.forward().then((_) {
        setState(() {
          diceNumber = Random().nextInt(6) + 1;
          if (currentPlayer == 1) {
            score1 += diceNumber;
            currentPlayer = 2;
          } else {
            score2 += diceNumber;
            currentPlayer = 1;
          }
          isRolling = false;
          checkWinner();
        });
      });
    });
  }

  void checkWinner() {
    if (score1 >= 50 || score2 >= 50) {  // Winning score updated to 50
      gameOver = true;
      if (score1 > score2) {
        winner = "Player 1 wins!";
      } else if (score2 > score1) {
        winner = "Player 2 wins!";
      } else {
        winner = "It's a tie!";
      }
    }
  }

  void restartGame() {
    setState(() {
      score1 = 0;
      score2 = 0;
      diceNumber = 1;
      currentPlayer = 1;
      gameOver = false;
      winner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffabecd6),
                Color(0xfffaaca8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          '1 Dice Game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 2.5,
            shadows: [
              Shadow(
                color: Colors.black38,
                blurRadius: 2,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(), // Expand to fill available space
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfffaaca8), // Light blue color
              Color(0xffabecd6), // Lighter blue color
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: GestureDetector(
                onTap: isRolling || gameOver ? null : rollDice,
                child: RotationTransition(
                  turns: _animation,
                  child: Image.asset(
                    'assets/d$diceNumber.png',
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Player 1 Score: $score1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Player 2 Score: $score2',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            if (gameOver)
              Column(
                children: [
                  Text(
                    winner,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: restartGame,
                    child: Text("Restart"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
