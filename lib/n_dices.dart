import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(DynamicDiceGame());
}

class DynamicDiceGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiceWithStatefulln(),
    );
  }
}

class DiceWithStatefulln extends StatefulWidget {
  @override
  State<DiceWithStatefulln> createState() => _DiceWithStatefullnState();
}

class _DiceWithStatefullnState extends State<DiceWithStatefulln> with SingleTickerProviderStateMixin {
  List<int> diceNumbers = [1, 2]; // Minimum of 2 dice
  List<int> scores = [0, 0];
  List<bool> isRolling = [false, false];
  bool gameOver = false;
  String winner = '';
  String secondWinner = '';
  late AnimationController _controller;
  late Animation<double> _animation;
  int rollingIndex = -1; // Track which dice is rolling
  int currentPlayerIndex = 0; // Track whose turn it is
  bool isRollingTurn = false; // Track if any dice is currently rolling

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  void rollDice(int index) {
    if (isRollingTurn || isRolling[index] || gameOver || index != currentPlayerIndex) return; // Check if a dice is currently rolling or game is over

    setState(() {
      rollingIndex = index;
      isRollingTurn = true;
      isRolling[index] = true;
      _controller.reset();
      _controller.forward().then((_) {
        setState(() {
          diceNumbers[index] = Random().nextInt(6) + 1;
          scores[index] += diceNumbers[index];
          isRolling[index] = false;
          rollingIndex = -1;
          isRollingTurn = false; // Reset turn status after rolling
          checkWinner();
          // Move to next player
          currentPlayerIndex = (currentPlayerIndex + 1) % diceNumbers.length;
        });
      });
    });
  }

  void checkWinner() {
    int winnerIndex = -1;
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] >= 50 && winner.isEmpty) {
        winner = "Player ${i + 1} wins!";
        scores[i] = -1; // To exclude this player from further rolls
        winnerIndex = i;
        break;
      }
    }

    if (winnerIndex != -1) {
      for (int i = 0; i < scores.length; i++) {
        if (scores[i] != -1 && scores[i] >= 50) {
          gameOver = true;
          secondWinner = "Second Winner is Player ${i + 1}!";
          break;
        }
      }
    }
  }

  void restartGame() {
    setState(() {
      for (int i = 0; i < scores.length; i++) {
        scores[i] = 0;
        diceNumbers[i] = Random().nextInt(6) + 1;
      }
      gameOver = false;
      winner = '';
      secondWinner = '';
      isRollingTurn = false; // Reset turn status on restart
      currentPlayerIndex = 0; // Reset to first player
    });
  }

  void addDice() {
    setState(() {
      diceNumbers.add(1);
      scores.add(0);
      isRolling.add(false);
      // Adjust current player index if necessary
      if (currentPlayerIndex >= diceNumbers.length) {
        currentPlayerIndex = 0;
      }
    });
  }

  void removeDice() {
    if (diceNumbers.length > 2) { // Minimum 2 dice
      setState(() {
        diceNumbers.removeLast();
        scores.removeLast();
        isRolling.removeLast();
        // Adjust current player index if necessary
        if (currentPlayerIndex >= diceNumbers.length) {
          currentPlayerIndex = 0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffabecd6), Color(0xfffaaca8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Multiple Dice Game',
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
              Color(0xfffaaca8),
              Color(0xffabecd6),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 dice per row for better visibility
                  crossAxisSpacing: 20, // Space between dice horizontally
                  mainAxisSpacing: 20, // Space between dice vertically
                ),
                itemCount: diceNumbers.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: isRolling[index] || gameOver || isRollingTurn || index != currentPlayerIndex
                            ? null
                            : () => rollDice(index),
                        child: RotationTransition(
                          turns: rollingIndex == index ? _animation : AlwaysStoppedAnimation(0),
                          child: Image.asset(
                            'assets/d${diceNumbers[index]}.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Player ${index + 1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 30),
              Column(
                children: List.generate(scores.length, (index) {
                  return Text(
                    'Player ${index + 1} Score: ${scores[index] == -1 ? "50+" : scores[index]}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                }),
              ),
              SizedBox(height: 30),
              if (gameOver)
                Column(
                  children: [
                    Text(
                      winner,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    Text(
                      secondWinner,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: restartGame,
                      child: Text("Restart"),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: addDice,
                    child: Text("Add Dice"),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: removeDice,
                    child: Text("Remove Dice"),
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
