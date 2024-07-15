extension IntExtension on int {
  String padLeft([int width = 2]) => toString().padLeft(width, '0');
}
