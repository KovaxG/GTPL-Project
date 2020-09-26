/* GTPL
 * Game: TicTacToe
 * Type: SinglePlayer
 * Lang: Java (Processing)
 */

enum Player { X, O }
enum Cell { X, O, Empty}

Player current = Player.X;

Cell[][] board = {
  {Cell.Empty, Cell.Empty, Cell.Empty}, 
  {Cell.Empty, Cell.Empty, Cell.Empty},
  {Cell.Empty, Cell.Empty, Cell.Empty}
};

int windowSize = 500;
int cellSize = windowSize / 3;
boolean gameOver = false;

color winColor = color(0, 255, 0);

void setup() {
  // These sadly need to be numbers, variables are not allowed.
  // Make sure this always matches windowSize!
  size(500, 500);
  
  fill(0);
  strokeWeight(5);
  stroke(255);
  
  background(0);
  drawHashtag();
}

void draw() {
  drawSymbols();
}

void drawHashtag() {
  stroke(100);
  
  // horizontal
  line(0, cellSize,   windowSize, cellSize  );
  line(0, cellSize*2, windowSize, cellSize*2);
  
  // vertical
  line(cellSize,   0, cellSize,   windowSize);
  line(cellSize*2, 0, cellSize*2, windowSize);
}

void drawSymbols() {
  for (int x = 0; x < 3; x++) 
    for (int y = 0; y < 3; y++) 
      drawSymbol(board[y][x], x, y, color(255));
      
  performChecks();
}

void performChecks() {
  for (int i = 0; i < 3; i++) {
    // horizontal checks
    if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != Cell.Empty) {
      gameOver = true;
      drawSymbol(board[i][0], 0, i, winColor);
      drawSymbol(board[i][1], 1, i, winColor);
      drawSymbol(board[i][2], 2, i, winColor);
    }
    
    // vertical checks
    if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != Cell.Empty) {
      gameOver = true;
      drawSymbol(board[0][i], i, 0, winColor);
      drawSymbol(board[1][i], i, 1, winColor);
      drawSymbol(board[2][i], i, 2, winColor);
    }
  }
  
  // main diag check
  if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[1][1] != Cell.Empty) {
    gameOver = true;
    drawSymbol(board[0][0], 0, 0, winColor);
    drawSymbol(board[1][1], 1, 1, winColor);
    drawSymbol(board[2][2], 2, 2, winColor);
  }
    
  // main diag check
  if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[1][1] != Cell.Empty) {
    gameOver = true;
    drawSymbol(board[0][2], 2, 0, winColor);
    drawSymbol(board[1][1], 1, 1, winColor);
    drawSymbol(board[2][0], 0, 2, winColor);
  }
}

void drawSymbol(Cell cell, int x, int y, color col) {
  stroke(col);
  switch(cell) {
    case X:
      float padding = cellSize * 0.15;
      line(x * cellSize + padding, y * cellSize + padding,     (x+1) * cellSize - padding, (y+1) * cellSize - padding);
      line(x * cellSize + padding, (y+1) * cellSize - padding, (x+1) * cellSize - padding, y * cellSize + padding);
      break;
    case O:
      circle((x + 0.5) * cellSize, (y + 0.5) * cellSize, cellSize * 0.75);
      break;
    case Empty:
      break;
  }
}

void mousePressed() {
  if (gameOver) return;
  
  int x = mouseX / cellSize;
  int y = mouseY / cellSize;
  
  switch(board[y][x]) {
    case Empty:
      switch(current) {
        case X:
          board[y][x] = Cell.X;
          current = Player.O;
          break;
        case O:
          board[y][x] = Cell.O;
          current = Player.X;
          break;
      }
    default:
      break;
  }
}
