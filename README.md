# calendar_rrule_generator

A Flutter widget for visually creating iCalendar RRULE recurrence rules for calendar events.

![Demo](https://github.com/yourusername/calendar_rrule_generator/raw/main/demo.gif)

This package provides a beautiful and easy-to-use UI for generating RFC 5545 RRULE strings, perfect for calendar applications that need recurrence functionality.

## Features

- Visual interface for creating complex recurrence rules
- Support for all RRULE frequencies: MINUTELY, HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY
- Interval customization (every N units)
- End conditions: never, after N occurrences, until specific date
- Weekly recurrence with day selection (e.g., every Monday and Friday)
- Hourly recurrence for daily/weekly/monthly rules
- Exclude specific dates from recurrence
- Real-time preview of generated RRULE string
- Built-in helper function to generate human-readable descriptions from RRULE strings
- Full iCalendar (RFC 5545) compliance

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  calendar_rrule_generator: ^0.0.1
```

Install it:

```bash
flutter pub get
```

Import it:

```dart
import 'package:calendar_rrule_generator/calendar_rrule_generator.dart';
```

## Usage

### Basic Usage

Show the recurrence generator as a modal bottom sheet:

```dart
final rrule = await showRRuleGeneratorSheet(
  context,
  initialRRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,WE,FR',
  startDate: DateTime.now(),
);

if (rrule != null) {
  print('Generated RRULE: $rrule');
}
```

### Direct Widget Usage

```dart
RRuleGenerator(
  initialRRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,WE,FR',
  startDate: DateTime.now(),
  onRRuleChanged: (rrule) {
    // Handle the generated RRULE string
    print(rrule);
  },
)
```

### Generate Human-readable Description

```dart
String description = describeRRule('FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,WE,FR');
print(description); // Output: "Еженедельно (Пн, Ср, Пт)"
```

## Additional information

This package was created as part of the Secretary Flutter application and extracted for wider community use. It follows the iCalendar RFC 5545 specification for recurrence rules.

Contributions are welcome! Please feel free to submit issues or pull requests on GitHub.

For more information about RRULE format, see the [iCalendar RFC 5545 specification](https://tools.ietf.org/html/rfc5545).