import 'package:flutter_test/flutter_test.dart';
import 'package:big_rrule_generator/src/logic/rrule_parser.dart';

void main() {
  group('RRuleParser', () {
    test('parses simple daily rule', () {
      final parser = RRuleParser(DateTime(2024, 1, 15));
      final data = parser.parse('FREQ=DAILY;INTERVAL=1');
      
      expect(data.frequency, 'DAILY');
      expect(data.interval, 1);
    });

    test('parses weekly rule with days', () {
      final parser = RRuleParser(DateTime(2024, 1, 15));
      final data = parser.parse('FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR');
      
      expect(data.frequency, 'WEEKLY');
      expect(data.interval, 2);
      expect(data.byday, ['MO', 'WE', 'FR']);
    });

    test('generates simple daily rule', () {
      final parser = RRuleParser(DateTime(2024, 1, 15));
      final data = RRuleData(frequency: 'DAILY', interval: 1);
      
      final rrule = parser.generate(data);
      expect(rrule, contains('FREQ=DAILY'));
    });

    test('generates weekly rule with days', () {
      final parser = RRuleParser(DateTime(2024, 1, 15));
      final data = RRuleData(
        frequency: 'WEEKLY',
        interval: 2,
        byday: ['MO', 'WE', 'FR'],
      );
      
      final rrule = parser.generate(data);
      expect(rrule, contains('FREQ=WEEKLY'));
      expect(rrule, contains('INTERVAL=2'));
      expect(rrule, contains('BYDAY=MO,WE,FR'));
    });
  });
}
