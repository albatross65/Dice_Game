import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(ThreeDice());
}

class ThreeDice extends StatelessWidget {
  const ThreeDice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiceWithStateful3(),
    );
  }
}

class DiceWithStateful3 extends StatefulWidget {
  const DiceWithStateful3({super.key});

  @override
  State<DiceWithStateful3> createState() => _DiceWithStateful3State();
}

class _DiceWithStateful3State extends State<DiceWithStateful3>
    with SingleTickerProviderStateMixin {
  int diceNumber1 = 2;
  int diceNumber2 = 4;
  int diceNumber3 = 6;
  int score1 = 0;
  int score2 = 0;
  int score3 = 0;
  bool isRolling1 = false;
  bool isRolling2 = false;
  bool isRolling3 = false;
  bool gameOver = false;
  String winner = '';
  String secondWinner = '';
  int currentPlayer = 1; // Track the current player
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
    if ((dice == 1 && currentPlayer != 1) ||
        (dice == 2 && currentPlayer != 2) ||
        (dice == 3 && currentPlayer != 3)) {
      return; // If it's not the player's turn, do nothing
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
            currentPlayer = 2; // Switch to the next player
            checkWinner();
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
            currentPlayer = 3; // Switch to the next player
            checkWinner();
          });
        });
      } else if (dice == 3) {
        isRolling3 = true;
        _controller.reset();
        _controller.forward().then((_) {
          setState(() {
            diceNumber3 = Random().nextInt(6) + 1;
            score3 += diceNumber3;
            isRolling3 = false;
            currentPlayer = 1; // Switch to the next player
            checkWinner();
          });
        });
      }
    });
  }

  void checkWinner() {
    if (score1 >= 50 && winner.isEmpty) {
      winner = "Player 1 wins!";
      score1 = -1; // To exclude this player from further rolls
    } else if (score2 >= 50 && winner.isEmpty) {
      winner = "Player 2 wins!";
      score2 = -1; // To exclude this player from further rolls
    } else if (score3 >= 50 && winner.isEmpty) {
      winner = "Player 3 wins!";
      score3 = -1; // To exclude this player from further rolls
    }

    if (winner.isNotEmpty) {
      if (score1 != -1 && score1 >= 50) {
        gameOver = true;
        secondWinner = "Second Winner is Player 1!";
      } else if (score2 != -1 && score2 >= 50) {
        gameOver = true;
        secondWinner = "Second Winner is Player 2!";
      } else if (score3 != -1 && score3 >= 50) {
        gameOver = true;
        secondWinner = "Second Winner is Player 3!";
      }
    }

    if (gameOver) {
      setState(() {
        // Do nothing, just refresh the UI
      });
    }
  }

  void restartGame() {
    setState(() {
      score1 = 0;
      score2 = 0;
      score3 = 0;
      diceNumber1 = 2;
      diceNumber2 = 4;
      diceNumber3 = 6;
      gameOver = false;
      winner = '';
      secondWinner = '';
      currentPlayer = 1; // Reset to the first player
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
          '3 Dice Game',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: currentPlayer == 1 && !isRolling2 && !isRolling3 && !gameOver
                              ? () => rollDice(1)
                              : null,
                          child: Column(
                            children: [
                              RotationTransition(
                                turns: currentPlayer == 1 ? _animation : AlwaysStoppedAnimation(0),
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
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: currentPlayer == 2 && !isRolling1 && !isRolling3 && !gameOver
                              ? () => rollDice(2)
                              : null,
                          child: Column(
                            children: [
                              RotationTransition(
                                turns: currentPlayer == 2 ? _animation : AlwaysStoppedAnimation(0),
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
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: currentPlayer == 3 && !isRolling1 && !isRolling2 && !gameOver
                          ? () => rollDice(3)
                          : null,
                      child: Column(
                        children: [
                          RotationTransition(
                            turns: currentPlayer == 3 ? _animation : AlwaysStoppedAnimation(0),
                            child: Image.asset(
                              'assets/d$diceNumber3.png',
                              height: 150,
                              width: 150,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Player 3',
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
              Text(
                'Player 3 Score: $score3',
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
                    Text(
                      secondWinner,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
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
