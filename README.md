# busy-police-IA

An artificial intelligence for solving a simplified version of the Atari game Busy Police.

![game1](https://i.imgur.com/1y2S1I5.png)

### Details

  - The problem was modeled in a game-states fashion
  - Prolog was used as an engine for our artificial agent
  - Aside from the state transitions and condition checking functions, an implementation of breadth search was used
  
### Example

Consider the following scenario (busy_police3.pl):
![game2](https://i.imgur.com/Feunzqw.png)

Using the following query:
```?- pegaLadrao([3, 1], L).```

The program outputs a list with the solution containing the path:
```L = [[1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [5, 4], [6, 4], [7, 4], [8, 4], [9, 4], [10, 4], [10, 3], [9, 3], [8, 3], [7, 3], [6, 3], [5, 3], [4, 3], [3, 3], [2, 3], [1, 3], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [8, 1], [7, 1], [6, 1], [5, 1], [4, 1], [3, 1]]```
