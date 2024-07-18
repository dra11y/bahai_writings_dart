import 'package:color_logger/color_logger.dart';

extension ColorLoggerExtension on ColorLogger {
  void info(String text) => log(text, status: LogStatus.info);
  void warn(String text) => log(text, status: LogStatus.warning);
  void success(String text) => log(text, status: LogStatus.success);
  void debug(String text) => log(text, status: LogStatus.debug);
  void error(String text) => log(text, status: LogStatus.error);
}

final logger = ColorLogger();
