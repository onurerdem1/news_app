class ImageConstants {
  static ImageConstants? _instace;

  static ImageConstants get instance => _instace ??= ImageConstants._init();

  ImageConstants._init();
  String get splashIcon => toPng('splash_icon');
  String get wavePng => toPng("wave");

  String toPng(String name) => 'assets/splash/$name.png';
}
