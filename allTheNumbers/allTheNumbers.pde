/*
 a modification of:

 #myrandomnumber Tutorial
 blprnt@blprnt.com
 April, 2010
 
 */

//This is the Google spreadsheet manager and the id of the spreadsheet that we want to populate, along with our Google username & password
SimpleSpreadsheetManager sm;
String sUrl = "https://docs.google.com/spreadsheets/d/1ARBWSqKYl3NwdcOtZRCxpB5yfaqvp0Sbco7BhqMLLfI";
String googleUser = "user";
String googlePass = "pass";
int[] numbers;
  
void setup() {
  //This code happens once, right when our sketch is launched
 size(800,800);
 background(0);
 smooth();
 //Ask for list of numbers
int[] numbers = getNumbers();
};

void draw() {
  //This code happens once every frame.
  fill(255,40);
  noStroke();
  for (int i = 0; i < numbers.length; i++) {
    ellipse(numbers[i]  *8, width/2, 8,8);
    };
 
};





