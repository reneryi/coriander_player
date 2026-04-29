import 'package:qisheng_player/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('涓枃鎷奸煶涓庤嫳鏂囨爣棰樼粺涓€鎺掑簭', () {
    expect('稻dao首'.localeCompareTo('Love Story') < 0, isTrue);
    expect('光辉岁月'.localeCompareTo('Holiday') < 0, isTrue);
  });

  test('中文和英文都可映射到字母索引', () {
    expect('光辉岁月'.toLocaleSortKey().startsWith('g'), isTrue);
    expect('Good Time'.toLocaleSortKey().startsWith('g'), isTrue);
  });
}
