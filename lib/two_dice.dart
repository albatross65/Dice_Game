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
      home: DiceWithStateful2(),
    );
  }
}

class DiceWithStateful2 extends StatefulWidget {
  const DiceWithStateful2({super.key});

  @override
  State<DiceWithStateful2> createState() => _DiceWithStateful2State();
}

class _DiceWithStateful2State extends State<DiceWithStateful2>
    with SingleTickerProviderStateMixin {
  int diceNumber1 = 2;
  int diceNumber2 = 4;
  int score1 = 0;
  int score2 = 0;
  bool isRolling1 = false;
  bool isRolling2 = false;
  bool gameOver = false;
  String winner = '';
  bool isPlayer1Turn = true; // Track whose turn it is
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

  void rollDice(int dice) {
    if ((dice == 1 && !isPlayer1Turn) ||
        (dice == 2 && isPlayer1Turn) ||
        gameOver ||
        (dice == 1 && isRolling1) ||
        (dice == 2 && isRolling2)) {
      return; // If not the player's turn or game is over or dice is already rolling
    }

    setState(() {
      if (dice == 1) {
        isRolling1 = true;
        _controller.reset();
        _controller.forward().then((_) {
          setState(() {
            diceNumber1 = Random().nextInt(6) + 1;
            score1 += diceNumber1;
            isRolling1 = false;
            checkWinner();
            if (!gameOver) {
              isPlayer1Turn = false; // Switch to Player 2's turn
            }
          });
        });
      } else if (dice == 2) {
        isRolling2 = true;
        _controller.reset();
        _controller.forward().then((_) {
          setState(() {
            diceNumber2 = Random().nextInt(6) + 1;
            score2 += diceNumber2;
            isRolling2 = false;
            checkWinner();
            if (!gameOver) {
              isPlayer1Turn = true; // Switch to Player 1's turn
            }
          });
        });
      }
    });
  }

  void checkWinner() {
    if (score1 >= 50 || score2 >= 50) {
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
      diceNumber1 = 2;
      diceNumber2 = 4;
      gameOver = false;
      winner = '';
      isPlayer1Turn = true; // Reset to Player 1's turn
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
          '2 Dice Game',
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: isPlayer1Turn && !isRolling1 && !gameOver
                          ? () => rollDice(1)
                          : null,
                      child: Column(
                        children: [
                          RotationTransition(
                            turns: isPlayer1Turn ? _animation : AlwaysStoppedAnimation(0),
                            child: Image.asset(
                              'assets/d$diceNumber1.png',
                              height: 150,
                              width: 150,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Player 1',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: !isPlayer1Turn && !isRolling2 && !gameOver
                          ? () => rollDice(2)
                          : null,
                      child: Column(
                        children: [
                          RotationTransition(
                            turns: !isPlayer1Turn ? _animation : AlwaysStoppedAnimation(0),
                            child: Image.asset(
                              'assets/d$diceNumber2.png',
                              height: 150,
                              width: 150,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Player 2',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: restartGame,
                      child: Text("Restart"),
                      style: ButtonStyle(),
                    ),
                  ],
                ),
            ],
          ),
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
