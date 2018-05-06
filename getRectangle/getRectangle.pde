
// 四角を抽出するプログラム

import gab.opencv.*;
import java.awt.Rectangle;

OpenCV opencv;

ArrayList<Contour> contours;

void setup() {

  PImage img = loadImage("data/image.png");
  size(img.width, img.height);
  image(img, 0, 0);

  opencv = new OpenCV(this, img);
  opencv.gray(); // グレイスケール変換
  opencv.threshold(50); // 閾値に基づき二値化
  contours = opencv.findContours(); //輪郭抽出
  
  // 面積が1000より大きければ抽出し,赤で囲み"dstXX(取得した回数).png"というファイル名で保存する
  int getCount = 1;
  for (int i=0; i<contours.size (); i++) {
    if ( contours.get(i).area() > 1000) {
      //println(i);
      Rectangle rect = contours.get(i).getBoundingBox();
      stroke(255, 0, 0);
      noFill();
      rect(rect.x, rect.y, rect.width, rect.height); 
      img = img.get(rect.x, rect.y, rect.width, rect.height);
      img.save( "dst/dst"+getCount+".png" );
      getCount++;
    }
  }
}

