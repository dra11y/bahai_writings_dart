import '/src/generated/messages_content.1988.g.dart';

mixin MessageContentMixin {
  String get id;
  String get content => switch (id) {
        '19880114_001' => messages1988['19880114_001']!,
        '19880204_001' => messages1988['19880204_001']!,
        '19880421_001' => messages1988['19880421_001']!,
        '19880531_001' => messages1988['19880531_001']!,
        '19880616_001' => messages1988['19880616_001']!,
        '19880725_001' => messages1988['19880725_001']!,
        '19880930_001' => messages1988['19880930_001']!,
        '19881213_001' => messages1988['19881213_001']!,
        '19881229_001' => messages1988['19881229_001']!,
        _ => throw UnimplementedError(),
      };
}
