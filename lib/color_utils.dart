class ColorStruct {
  int red;
  int green;
  int blue;
  int alpha;

  ColorStruct(this.red, this.green, this.blue, [this.alpha = 255]);

  int get rgb => (red << 16) + (green << 8) + (blue);
  int get rgba => (red << 24) + (green << 16) + (blue << 8) + alpha;
  String get rgbaString => "rgba($red,$green,$blue,$alpha)";
}