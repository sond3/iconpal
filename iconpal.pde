import processing.pdf.*;

PImage img;
Square[] squares =  new Square[999999];
int pixelDistance = 10;
String origen = "input/image.jpg";
String output = "output/poster.pdf";
String svgPath = "svg/03/";
color backgroundColor = #FFFF00;

/**
 setup
 */
void setup() {

  img = loadImage(origen);
  size(1280, 1475);

  image(img, 0, 0);
  filter(GRAY);
  filter(POSTERIZE, 9);

  beginRecord(PDF, output);

  PixelExtractor extractor = new PixelExtractor(img);
  squares = extractor.getData();

  noStroke();
  fill(backgroundColor);
  rect(0, 0, img.width, img.height);

  SquaresDrawer drawer = new SquaresDrawer(squares);
  drawer.draw();

  endRecord();
}

/**
 PixelExtractor class
 */
class PixelExtractor {

  int _cont;
  PImage _img;

  PixelExtractor(PImage img) {
    _cont = 0;
    _img = img;
  }

  Square[] getData() {

    for (int i=0; i< img.width; i+=pixelDistance) {
      for (int j=0; j< img.height; j+=pixelDistance) {
        color cp = get(i, j);
        squares[_cont] = new Square(i, j, cp, pixelDistance, svgPath);
        _cont++;
      }
    }
    return squares;
  }
}

/**
 Square class
 */
class Square {

  int _x, _y;
  color _color;
  PShape icono;
  int _pixelDistance;
  String _svgPath;

  Square(int x, int y, color rgb, int pixelDistance, String svgPath) {
    _x = x;
    _y = y;
    _color = rgb;
    _pixelDistance = pixelDistance;
    _svgPath = svgPath;
  }

  void draw() {

    boolean noDraw = false;

    if (_color==0xFF000000) {
      icono = loadShape(_svgPath + "9.svg");
    } else if (_color==0xFF303030 || _color==0xFF333333) {
      icono = loadShape(_svgPath + "8.svg");
    } else if (_color==0xFF1F1F1F) {
      icono = loadShape(_svgPath + "7.svg");
    } else if (_color==0xFF3F3F3F) {
      icono = loadShape(_svgPath + "6.svg");
    } else if (_color==0xFF5F5F5F  || _color==0xFF7F7F7F) {
      icono = loadShape(_svgPath + "5.svg");
    } else if (_color==0xFF9F9F9F || _color==0xFF999999) {
      icono = loadShape(_svgPath + "4.svg");
    } else if (_color==0xFFBFBFBF || _color==0xFF666666) {
      icono = loadShape(_svgPath + "3.svg");
    } else if (_color==0xFFDFDFDF || _color==0xFFCCCCCC) {
      icono = loadShape(_svgPath + "2.svg");
    } else if (_color==0xFFFFFFFF) {
      icono = loadShape(_svgPath + "1.svg");
    } else {
      noDraw = true;
      noStroke();
      fill(255, 78, 56, 255);
      ellipse(_x, _y, 10, 10);
      println("Something went wrong: " + _color);
    }

    if (!noDraw) {
      smooth();
      shapeMode(CENTER);
      shape(icono, _x, _y, _pixelDistance, _pixelDistance);
    }
  }
}

/**
 SquaresDrawer class
 */
class SquaresDrawer {

  Square[] _squares;

  SquaresDrawer(Square[] squares) {

    _squares = squares;
  }

  void draw() {

    for (int i=0; i< _squares.length; i++) {
      if (_squares[i] == null) {
        break;
      }
      _squares[i].draw();
    }
  }
}