
// scanCharData
// プリントに書き込まれた文字を抽出するプログラム
// note: 個人情報があるためデータは削除しとく

import gab.opencv.*;
import java.util.Comparator;
import java.util.Collections;
import java.util.ArrayList;
import org.opencv.core.Rect;
import java.awt.Rectangle;

PImage src, dst;
OpenCV opencv;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;
ArrayList<Line> lines;
String [] ClassNames = {
  "1B", "1C", "1D"
};
String [] users;
String [] str;
String [] filePath;

int phase_count = 0;
int user = 0;
int t=0;
void setup() {

  // 読み込みたいファイルを指定
  String [] lines = loadStrings("5A.txt");
  int UserName = -1;
  String preClassName = "";

  for ( int count = 0; count < lines.length; count++ ) {
    String [] elements = lines[count].split(",");
    String filename = elements[0];
    String ClassName = elements[1];

    if ( !ClassName.equals(preClassName) ) {
      UserName = 0;
    }

    String dstFileName = "dst/" + ClassName + "/" + UserName + "/" +(count%7)+"/";


    if (count%7 != 0) {
      src = loadImage( filename );
      src.save( dstFileName + "original.png");
      
      int threshold = 0;
      int rect_count = 0;
      boolean loadSuccessful = true;
      int rectMaxCount = 0;
      if (  t % 2 == 1 ) {
        rectMaxCount = 74;
      } else {
        rectMaxCount = 75;
      }
      while ( rect_count !=  rectMaxCount) {
        // 輪郭点の抽出
        rect_count = 0;
        opencv = new OpenCV(this, src);
        opencv.gray();
        opencv.threshold(threshold);
        contours = opencv.findContours();
        println("found " + contours.size() + " contours");

        for (int i=0; i<contours.size (); i++) {
          if ( contours.get(i).area() > 120000 && contours.get(i).area() < 1000000) {
            rect_count++;
          }
        }
        println(rect_count);
        threshold+=5;
      }

      opencv = new OpenCV(this, src);
      opencv.gray();
      opencv.threshold(threshold);
      contours = opencv.findContours();

      ArrayList<Rectangle> SortedRects = new ArrayList();
      ArrayList<Rectangle> TempRects = new ArrayList();
      Rectangle temp;
      Rectangle preRect = new Rectangle(0, 0, 0, 0);
      Rectangle curRect = new Rectangle(0, 0, 0, 0);
      int load_count = 0;



      for (int i=0; i<contours.size (); i++) {

        // マス目より大きいものだけとってくる
        if ( contours.get(i).area() > 100000 && contours.get(i).area() < 1000000) {

          curRect = contours.get(i).getBoundingBox();
          TempRects.add(curRect);

          load_count++;
          
          if ( t%2 ==  0 ) {
            if ( load_count == 15 || load_count == 30  || load_count == 45 || load_count == 60 || load_count == 75 ) {

              preRect = new Rectangle(0, 0, 0, 0);

              // t列目をx座標の小さい順にソートする(TempRects)
              Collections.sort(TempRects, new RectangleComparator());

              // ソートしたものをSortedRectsに追加する
              for ( Rectangle rect : TempRects ) {
                SortedRects.add( rect );
              }

              // TempRectsを初期化
              TempRects = new ArrayList();
            }
          }
          if ( t%2 == 1 ) {
            if ( load_count == 14 || load_count == 29  || load_count == 44 || load_count == 59 || load_count == 74 ) {
              preRect = new Rectangle(0, 0, 0, 0);
              // t列目をx座標の小さい順にソートする(TempRects)
              Collections.sort(TempRects, new RectangleComparator());

              // ソートしたものをSortedRectsに追加する
              for ( Rectangle rect : TempRects ) {
                SortedRects.add( rect );
              }

              // TempRectsを初期化
              TempRects = new ArrayList();
            }
          }
        }
      }

      load_count = 0;
      //if ( SortedRects.size() == 74 ||  SortedRects.size() == 75 ) {
      for ( Rectangle rect : SortedRects ) {
        println( "progress:" + ClassName + "の" + UserName + "さん" +load_count+ "/" + 75 );
        src.save( dstFileName + load_count + ".png" );
        PImage img = loadImage( dstFileName +load_count + ".png" );
        img = img.get(rect.x+10, rect.y+10, rect.width-20, rect.height-20);
        img.save( dstFileName + load_count + ".png" );
        load_count++;
      }
      t++;
    }
    else{
      UserName++;
    }
    
    preClassName = ClassName;
    
  }
}

public class RectangleComparator implements Comparator<Rectangle> { 
  @Override public int compare(Rectangle rect1, Rectangle rect2) { 
    return rect1.x < rect2.x ? -1 : 1;
  }
} 

String[] getFileName(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

