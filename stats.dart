// Author: Birju Vachhani
// Created Date: April 05, 2021

import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/analysis/analysis_context_collection.dart';
import 'package:intl/intl.dart';

// ignore_for_file: avoid_print

class Stats {
  List<String> functions = [];
  List<String> classes = [];
  List<String> variables = [];
  int extensions = 0;
  int typedefs = 0;
  int mixins = 0;

  Stats({
    required this.functions,
    required this.classes,
    required this.variables,
    required this.extensions,
    required this.typedefs,
    required this.mixins,
  });

  Stats operator +(Stats other) => Stats(
        functions: functions + other.functions,
        classes: classes + other.classes,
        variables: variables + other.variables,
        extensions: extensions + other.extensions,
        typedefs: typedefs + other.typedefs,
        mixins: mixins + other.mixins,
      );
}

/// Script to generate stats for this package.
/// Usage: dart stats.dart [--dry]
/// --dry: if provided, it will not update README.md file. It will only print
/// the stats to console.
void main(List<String> args) async {
  final screwdriverStats = await getStats('package:flutter_screwdriver/flutter_screwdriver.dart');

  final isDry = args.contains('--dry');

  final stats = screwdriverStats;

  final output = '''

```yaml  
Extensions:                    ${stats.extensions}
Helper Classes:                ${stats.classes.length}
Helper Functions & Getters:    ${stats.functions.length + stats.variables.length}
Typedefs:                      ${stats.typedefs}
Mixins:                        ${stats.mixins}
```

> *Last Updated: ${DateFormat('EEE, MMM dd, yyyy - hh:mm a').format(DateTime.now())}*

''';

  if (!isDry) {
    final readMeFile = File('README.md');
    var content = readMeFile.readAsStringSync();
    const prefix = '<!---stats_start-->';
    const suffix = '<!---stats_end-->';

    final start = content.indexOf(prefix) + prefix.length;
    final end = content.indexOf(suffix);
    content = content.replaceRange(start, end, output);
    readMeFile.writeAsStringSync(content);
  } else {
    print('Dry run, not updating README.md...');
  }

  print('');
  print('==================================================================');
  print('STATS');
  print('==================================================================');
  print('Helper Functions & Getters:    '
      '${stats.functions.length + stats.variables.length}');
  print('Helper Classes:                ${stats.classes.length}');
  print('Extensions:                    ${stats.extensions}');
  print('Typedefs:                      ${stats.typedefs}');
  print('Mixins:                        ${stats.mixins}');
  print('==================================================================');
}

Future<Stats> getStats(String library) async {
  final collection = AnalysisContextCollectionImpl(
      includedPaths: <String>[Directory('lib').absolute.path], resourceProvider: PhysicalResourceProvider.INSTANCE);
  final session = collection.contexts[0].currentSession;
  final libPath = session.uriConverter.uriToPath(Uri.parse(library)) ?? '';
  final result = await session.getResolvedUnit(libPath) as ResolvedUnitResult;
  var helpersFunctions = <String>[];
  var helpersClasses = <String>[];
  var helperVariables = <String>[];
  var extensions = 0;
  var typedefs = 0;
  var mixins = 0;

  void collectStats(LibraryElement element) {
    for (final part in element.fragments) {
      helpersFunctions += part.functions.wherePublic().map((e) => e.name).whereType<String>().toList();
      extensions += part.extensions.wherePublic().expand((element) => element.fields).length.toInt();
      extensions += part.extensions.wherePublic().expand((element) => element.methods).length.toInt();
      helpersClasses += part.classes.wherePublic().map((e) => e.name).whereType<String>().toList();
      helperVariables += part.topLevelVariables.wherePublic().map((e) => e.name).whereType<String>().toList();
      typedefs += part.typeAliases.wherePublic().length.toInt();
      mixins += part.mixins.wherePublic().length.toInt();
    }
    for (final exp in element.exportedLibraries) {
      collectStats(exp);
    }
  }

  collectStats(result.libraryElement);

  final stats = Stats(
    variables: helperVariables,
    classes: helpersClasses,
    functions: helpersFunctions,
    extensions: extensions,
    typedefs: typedefs,
    mixins: mixins,
  );

  return stats;
}

extension ElementListExt<T extends Element> on List<T> {
  Iterable<T> wherePublic() => where((element) => element.isPublic);
}

extension ExecutableFragmentListExt<T extends Fragment> on List<T> {
  Iterable<T> wherePublic() => where((f) => f.element.isPublic);
}
