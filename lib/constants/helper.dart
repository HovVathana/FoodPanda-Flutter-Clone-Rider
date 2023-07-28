import 'dart:math' show cos, sqrt, asin;

class Helper {
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // double convertDouble(double number) {
  //   var f = NumberFormat("###.00");
  //   String ans = f.format(number);
  //   if (
  //   ans.split('.')[1][1] == '0'

  //   ) {
  //     return
  //   }
  //   return double.parse('13.0');
  // }
}
