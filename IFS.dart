import 'dart:io';
import 'dart:math';
import 'package:image/image.dart';

class IFS {
  final List<List<double>> _cofs;
  final List<double> _ps;

  IFS(this._cofs, this._ps) {
    if (_cofs.length != _ps.length) {
      throw "lengths are different";
    }

    for (var c in _cofs) {
      if (c.length != 6) {
        throw "cofs length is not 6";
      }
    }
  }

  void generate(String outputImageFileName) {
    double xn = 0;
    double yn = 0;

    final image = Image(1024, 1024);
    fill(image, getColor(0, 0, 0));

    final random = Random();

    for (int i = 0; i < 2000000; ++i) {
      final double p = random.nextDouble();
      int n = -1;
      for (int j = 0; j < _ps.length; ++j) {
        if (p < _ps[j]) {
          n = j;
          break;
        }
      }

      double x = xn;
      double y = yn;
      xn = _cofs[n][0] * x + _cofs[n][1] * y + _cofs[n][2];
      yn = _cofs[n][3] * x + _cofs[n][4] * y + _cofs[n][5];

      double scale = 100;
      int xp = (xn * scale + image.width / 2).round();
      int yp = image.height - 1 - (yn * scale + 32).round();

      if (image.boundsSafe(xp, yp)) {
        image.setPixel(xp, yp, getColor(255, 255, 255));
      }
    }

    File(outputImageFileName).writeAsBytesSync(encodePng(image));
  }
}
