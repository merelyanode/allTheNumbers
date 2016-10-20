/*

 #myrandomnumber Tutorial
 blprnt@blprnt.com
 April, 2010
 
 */

//This is the Google spreadsheet manager and the id of the spreadsheet that we want to populate, along with our Google username & password
SimpleSpreadsheetManager sm;
String sUrl = "https://docs.google.com/spreadsheets/d/1ARBWSqKYl3NwdcOtZRCxpB5yfaqvp0Sbco7BhqMLLfI";
String googleUser = "xdotmdotl";
String googlePass = "caroline452";
  
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





 
 //Function to get an Array of integers from a Google Spreadsheet
  int[] getNumbers() {
      println("Asking Google for numbers...");
      sm = new SimpleSpreadsheetManager();
      sm.init("RandomNumbers", googleUser, googlePass);
      sm.fetchSheetByKey(sUrl, 0);
      
      int n = sm.currentListEntries.size();
      int[] returnArray = new int[n];
      for (int i = 0; i < n; i++) {
         returnArray[i] = int(sm.getCellValue("Number", i));
      };
      println("Got " + n + " numbers.");
      return(returnArray);
  };
  
  //Function to generate a random list of integers
  int[] getRandomNumbers(int c) {

      int[] returnArray = new int[c];
      for (int i = 0; i < c; i++) {
         returnArray[i] = ceil(random(0,99));
      };
      return(returnArray);
  };
/*

SimpleSpreadsheetManager Class
blprnt@blprnt.com
July, 2009

This is a quick & dirty class for accessing data from the Google Spreadsheet API.


*/

import com.google.gdata.client.spreadsheet.*;
import com.google.gdata.data.*;
import com.google.gdata.data.spreadsheet.*;
import com.google.gdata.util.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class SimpleSpreadsheetManager {

  SpreadsheetService myService;
  SpreadsheetEntry spreadsheetEntry;
  SpreadsheetFeed sheetFeed;
  WorksheetEntry worksheetEntry;

  List spreadsheets;

  String user;
  String pass;
  
  ListFeed currentListFeed;
  CellFeed currentCellFeed;
  List currentCells;
  List currentListEntries;
  
  int currentTotalRows;
  int currentTotalCols;
  
  String currentTitle;
  String[] tagArray;
  
  URL listFeedUrl;


  SimpleSpreadsheetManager() {
    
  };
  
  /*
  
  INIT FUNCTION
  Opens session, uses username & password for authentication
  
  */

  void init(String sessionName, String u, String p) {
    user = u;
    pass = p;
    myService = new SpreadsheetService(sessionName);
    try {
      myService.setUserCredentials(user, pass);
    } 
    catch (Exception e) {
      println("ERROR IN AUTHENTICATION");
    };

  };
  
  /*
  
  FETCH SHEET BY KEY
  Gets a spreadsheet listfeed using the unique key - this is in the URL of the spreadsheet
  The retrieved sheet is both returned and set as the currentListFeed
  
  */
  
  ListFeed fetchSheetByKey(String k, int wi) {
    
    ListFeed f = new ListFeed();
    CellFeed cf = new CellFeed();
    WorksheetFeed w = new WorksheetFeed();
    
    //GET WORKSHEETS FEED
    try {
      URL worksheetFeedUrl = new URL("http://spreadsheets.google.com/feeds/worksheets/" + k + "/private/full");
      WorksheetFeed wf2 = new WorksheetFeed();
      w = myService.getFeed(worksheetFeedUrl, wf2.getClass());
    }
    catch(Exception e) {
      println("ERROR RETRIEVING WORKSHEET FEED");
    };
    
    List worksheets = w.getEntries();
    WorksheetEntry we = (WorksheetEntry) worksheets.get(wi);   
    println("RETRIEVED WORKSHEET " + we.getTitle().getPlainText()); 
    
    //GET LIST FEED URL
    try {
      listFeedUrl = we.getListFeedUrl();//new URL("http://spreadsheets.google.com/feeds/list/" + k + "/od6/private/full");
      ListFeed lf2 = new ListFeed();
      f = myService.getFeed(listFeedUrl, lf2.getClass());
    }
    catch(Exception e) {
      println("ERROR RETRIEVING LIST FEED");
    };
    
    //GET CELL FEED
    try {
      URL cellFeedUrl = we.getCellFeedUrl();//new URL("http://spreadsheets.google.com/feeds/cells/" + k + "/od6/private/full");
      CellFeed lf2 = new CellFeed();
      cf = myService.getFeed(cellFeedUrl, lf2.getClass());

    }
    catch(Exception e) {
      println("ERROR RETRIEVING LIST FEED");
    };
    
    currentListFeed = f;
    currentCellFeed = cf;
    currentCells = cf.getEntries();
    currentListEntries = f.getEntries();
    
    currentTitle = we.getTitle().getPlainText();
    currentTotalRows = currentListEntries.size();
   if (currentListEntries.size() > 0) {
    ListEntry le = (ListEntry) currentListEntries.get(0);  
    currentTotalCols = le.getCustomElements().getTags().size();

    Set<String> tags = le.getCustomElements().getTags();
    tagArray = new String[tags.size()];
    tagArray = tags.toArray(tagArray);
   };
    
    return(f);
  };
  
  /*
  
  GET CELL VALUE
  Returns the value held in an individual sheet cell.
  
  */
  
  String getCellValue(int c, int r) {
    
    ListEntry le = (ListEntry) currentListEntries.get(r);    
    Set<String> tags = le.getCustomElements().getTags();
    String[] tagArray = new String[tags.size()];
    tagArray = tags.toArray(tagArray);
    
    return(le.getCustomElements().getValue(tagArray[c]));
   
  };
  
  String getCellValue(String tag, int r) {
 
    ListEntry le = (ListEntry) currentListEntries.get(r);    
    return(le.getCustomElements().getValue(tag));
   
  };
  
  void setCellValue(String tag, int r, String val) {
 
    ListEntry le = (ListEntry) currentListEntries.get(r);    
    le.getCustomElements().setValueLocal(tag, val);
    try {
      ListEntry updatedRow = le.update();
    }
    catch (Exception e){
      
    };
   
  };
  
  void setNewCellValue(String tag, int r, String val) {
 
    ListEntry le = new ListEntry();  
    
    try {
     le.getCustomElements().setValueLocal(tag, val);
     ListEntry insertedRow = myService.insert(listFeedUrl, le);
      ListEntry updatedRow = insertedRow.update();
    }
    catch (Exception e){
      
    };
   
  };
  
};







