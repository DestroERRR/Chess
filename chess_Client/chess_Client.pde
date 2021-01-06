import processing.net.*;

Client myClient;

color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
int row1, col1, row2, col2;
int rowB, colB;
int promo = 0; 

char grid[][] = {
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};

int go = 1;

boolean zkey;

char lastpiece;

boolean promote = false; 

void setup() {
  size(800, 800);
  
  zkey = false; 
  
  myClient = new Client (this, "127.0.0.1",1234);
  
  firstClick = true;

  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");
}

void draw() {
  strokeWeight(1);
  stroke(2);
  drawBoard(); 
  highlight();
  drawPieces();
  receiveMove();
  promotion();
}

void promotion(){
  
  if(promote == true){
    
       if (promo == 1) grid[row2][col2] = 'Q';
       if (promo == 2) grid[row2][col2] = 'R';
       if (promo == 3) grid[row2][col2] = 'B';
       if (promo == 4) grid[row2][col2] = 'N';
       promo = 0;
       
  } promote = false; 
  
  if ('P' == grid[row2][col2]) {
   if(row2 == 7){ 
     promote = true;
    //println("promotion!"); 
   } 
  }
  
  
}

void receiveMove(){
  if (myClient.available() > 0){
   String incoming = myClient.readString(); 
   int r1 = int(incoming.substring(0, 1));
   int c1 = int(incoming.substring(2, 3));
   int r2 = int(incoming.substring(4, 5));
   int c2 = int(incoming.substring(6, 7));
   int id = int(incoming.substring(8, 9));

   
   if(id == 0){
   grid [r2][c2] = grid [r1][c1];
   grid [r1][c1] = ' ';
   go = 2; //we are receivng the server message; if go is 2 black is able to move
   } else if (id == 1 && go == 2) {
     grid[r1][c1] = grid[r2][c2];
     grid[r2][c2] = ' ';
     
     
   } else if (id == 2) { 
     
   }
   
   
   
   
  }
}
void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 
      if ( (r%2) == (c%2) ) { 
        fill(lightbrown);
      } else { 
        fill(darkbrown);
      }
      rect(c*100, r*100, 100, 100);
    }
  }
}

void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}

void takeback() {
 if (go == 1) {
  grid[row1][col1] = grid[row2][col2];
  grid[row2][col2] = lastpiece;
 }
}

void highlight(){
 if (firstClick == false){
    noFill();
    stroke(0,200,0);
    strokeWeight(6);
    rect(col1*100, row1*100, 100, 100);
 }  
    
 }


void mouseReleased() {
  if (firstClick) {
    row1 = rowB = mouseY/100;
    col1 = colB = mouseX/100;
    if ( grid [row1][col1] == ' ' || go == 1){
    firstClick = true;
    } else firstClick = false;
  } else {
    row2 = mouseY/100;
    col2 = mouseX/100;
    if (!(row2 == row1 && col2 == col1) && go == 2) {
      lastpiece = grid[row2][col2];
      grid[row2][col2] = grid[row1][col1];
      grid[row1][col1] = ' ';
      myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + "0");
      firstClick = true;
      go = 1;
    }
  }
}


void keyReleased() {
 if (key == 'z' || key == 'Z') {
   takeback();
   go = 2;
   myClient.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + "1");
 }
 
 if (key == 'q' || key == 'Q' && promote == true && go == 1) {
    promo = 1; //queen
  } 
  
  if (key == 'r' || key == 'R' && promote == true && go == 1) {
    promo = 2; //rook
  }
  
  if (key == 'b' || key == 'B' && promote == true && go == 1) {
    promo = 3;  //bishop
  }
  
  if (key == 'n' || key == 'N' && promote == true && go == 1) {
    promo = 4; //knight 
  }
  
 
}
