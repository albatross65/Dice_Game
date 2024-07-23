import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(FourDice());
}

class FourDice extends StatelessWidget {
  const FourDice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiceWithStateful4(),
    );
  }
}

class DiceWithStateful4 extends StatefulWidget {
  const DiceWithStateful4({super.key});

  @override
  State<DiceWithStateful4> createState() => _DiceWithStateful4State();
}

class _DiceWithStateful4State extends State<DiceWithStateful4>
    with SingleTickerProviderStateMixin {
  int diceNumber1 = 2;
  int diceNumber2 = 4;
  int diceNumber3 = 6;
  int diceNumber4 = 1;
  int score1 = 0;
  int score2 = 0;
  int score3 = 0;
  int score4 = 0;
  bool isRolling1 = false;
  bool isRolling2 = false;
  bool isRolling3 = false;
  bool isRolling4 = false;
  bool gameOver = false;
  String winner = '';
  String secondWinner = '';
  int currentPlayer = 1; // Track current player's turn
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
    setState(() {
      if (dice == 1 && currentPlayer == 1 && !isRolling1 && !gameOver) {
        isRolling1 = true;
        _controller.reset();
        _controller.forward().then((_) {
          setState(() {
            diceNumber1 = Random().nextInt(6) + 1;
            score1 += diceNumber1;
            isRolling1 = false;
            checkWinner();
            if (!gameOver) {
              currentPlayer = 2; // Next player's turn
            }
          });
        });
      } else if (dice == 2 && currentPlayer == 2 && !isRolling2 && !gameOver) {
        isRolling2 = true;
        _controller.reset();
        _controller.forward().then((_) {
          setState(() {
            diceNumber2 = Random().nextInt(6) + 1;
            score2 += diceNumber2;
            isRolling2 = false;
            checkWinner();
            if (!gameOver) {
              currentPlayer = 3; // Next player's turn
            }
          });
        });
      } else if (dice == 3 && currentPlayer == 3 && !isRolling3 && !gameOver) {
        isRolling3 = true;
        _controller.reset();
        _controller.forward().then((_) {
          setState(() {
            diceNumber3 = Random().nextInt(6) + 1;
            score3 += diceNumber3;
            isRolling3 = false;
            checkWinner();
            if (!gameOver) {
              currentPlayer = 4; // Next player's turn
            }
          });
        });
      } else if (dice == 4 && currentPlayer == 4 && !isRolling4 && !gameOver) {
        isRolling4 = true;
        _controller.reset();
        _controller.forward().then((_) {
          setState(() {
            diceNumber4 = Random().nextInt(6) + 1;
            score4 += diceNumber4;
            isRolling4 = false;
            checkWinner();
            if (!gameOver) {
              currentPlayer = 1; // Next player's turn
            }
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
    } else if (score4 >= 50 && winner.isEmpty) {
      winner = "Player 4 wins!";
      score4 = -1; // To exclude this player from further rolls
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
      } else if (score4 != -1 && score4 >= 50) {
        gameOver = true;
        secondWinner = "Second Winner is Player 4!";
      }
    }
  }

  void restartGame() {
    setState(() {
      score1 = 0;
      score2 = 0;
      score3 = 0;
      score4 = 0;
      diceNumber1 = 2;
      diceNumber2 = 4;
      diceNumber3 = 6;
      diceNumber4 = 1;
      gameOver = false;
      winner = '';
      secondWinner = '';
      currentPlayer = 1; // Reset to Player 1's turn
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
          '4 Dice Game',
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: currentPlayer == 1 && !isRolling1 && !gameOver
                                  ? () => rollDice(1)
                                  : null,
                              child: RotationTransition(
                                turns: currentPlayer == 1 ? _animation : AlwaysStoppedAnimation(0),
                                child: Image.asset(
                                  'assets/d$diceNumber1.png',
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Player 1',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: currentPlayer == 2 && !isRolling2 && !gameOver
                                  ? () => rollDice(2)
                                  : null,
                              child: RotationTransition(
                                turns: currentPlayer == 2 ? _animation : AlwaysStoppedAnimation(0),
                                child: Image.asset(
                                  'assets/d$diceNumber2.png',
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Player 2',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: currentPlayer == 3 && !isRolling3 && !gameOver
                                  ? () => rollDice(3)
                                  : null,
                              child: RotationTransition(
                                turns: currentPlayer == 3 ? _animation : AlwaysStoppedAnimation(0),
                                child: Image.asset(
                                  'assets/d$diceNumber3.png',
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Player 3',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: currentPlayer == 4 && !isRolling4 && !gameOver
                                  ? () => rollDice(4)
                                  : null,
                              child: RotationTransition(
                                turns: currentPlayer == 4 ? _animation : AlwaysStoppedAnimation(0),
                                child: Image.asset(
                                  'assets/d$diceNumber4.png',
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Player 4',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
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
              Text(
                'Player 4 Score: $score4',
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
