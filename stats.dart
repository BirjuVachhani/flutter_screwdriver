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
  final screwdriverStats =
      await getStats('package:flutter_screwdriver/flutter_screwdriver.dart');

  final isDry = args.contains('--dry');

  final stats = screwdriverStats;

  var output = '''

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
      includedPaths: <String>[Directory('lib').absolute.path],
      resourceProvider: PhysicalResourceProvider.INSTANCE);
  final session = collection.contexts[0].currentSession;
  final libPath = session.uriConverter.uriToPath(Uri.parse(library)) ?? '';
  // ignore: deprecated_member_use
  final result =
      await session.getResolvedLibrary(libPath) as ResolvedLibraryResult;
  var helpersFunctions = <String>[];
  var helpersClasses = <String>[];
  var helperVariables = <String>[];
  var extensions = 0;
  var typedefs = 0;
  var mixins = 0;
  for (final part in result.element.units) {
    helpersFunctions +=
        part.functions.wherePublic().map((e) => e.displayName).toList();
    extensions += part.extensions
        .wherePublic()
        .expand((element) => element.fields)
        .length;
    extensions += part.extensions
        .wherePublic()
        .expand((element) => element.methods)
        .length;
    helpersClasses +=
        part.classes.wherePublic().map((e) => e.displayName).toList();
    helperVariables +=
        part.accessors.wherePublic().map((e) => e.displayName).toList();
    typedefs += part.typeAliases.wherePublic().length;
    mixins += part.mixins.wherePublic().length;
  }

  final stats = Stats(
    variables: helperVariables,
    classes: helpersClasses,
    functions: helpersFunctions,
    extensions: extensions,
    typedefs: typedefs,
    mixins: mixins,
  );

  collectExports(result.element, stats, checkForSrcDir: true);
  return stats;
}

void collectExports(LibraryOrAugmentationElement element, Stats stats,
    {bool checkForSrcDir = false}) {
  for (final exp in element.libraryExports) {
    final uri = exp.uri;
    if (uri is! DirectiveUriWithLibrary) continue;
    if (!checkForSrcDir || uri.relativeUriString.startsWith('src') == true) {
      for (final unit in exp.exportedLibrary!.units) {
        stats.classes
            .addAll(unit.classes.wherePublic().map((e) => e.displayName));
        stats.functions
            .addAll(unit.functions.wherePublic().map((e) => e.displayName));
        stats.variables
            .addAll(unit.accessors.wherePublic().map((e) => e.displayName));
        stats.extensions += unit.extensions
            .wherePublic()
            .expand((element) => element.methods)
            .length;
        stats.extensions += unit.extensions
            .wherePublic()
            .expand((element) => element.fields)
            .length;
        stats.typedefs += unit.typeAliases.wherePublic().length;
        stats.mixins += unit.mixins.wherePublic().length;

        if (unit.enclosingElement.libraryExports.isNotEmpty) {
          collectExports(unit.enclosingElement, stats);
        }
      }
    }
  }
}

extension ElementListExt<T extends Element> on List<T> {
  Iterable<T> wherePublic() => where((element) => element.isPublic);
}
