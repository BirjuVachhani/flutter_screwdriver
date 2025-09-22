import 'package:flutter/material.dart';
import 'package:flutter_screwdriver/flutter_screwdriver.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(PlaygroundApp());
}

class PlaygroundApp extends StatelessWidget {
  const PlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playground',
      debugShowCheckedModeBanner: false,
      home: PlaygroundHome(),
    );
  }
}

class PlaygroundHome extends StatefulWidget {
  const PlaygroundHome({super.key});

  @override
  State<PlaygroundHome> createState() => _PlaygroundHomeState();
}

class _PlaygroundHomeState extends State<PlaygroundHome> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            backgroundColor: context.colorScheme.surfaceContainer,
            extended: MediaQuery.sizeOf(context).width > 800,
            indicatorColor: context.colorScheme.secondaryContainer,
            onDestinationSelected: (index) {
              setState(() => selectedIndex = index);
            },
            trailingAtBottom: true,
            trailing: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  InkWell(
                    onTap: () => launchUrlString('https://github.com/BirjuVachhani/flutter_screwdriver'),
                    customBorder: StadiumBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        spacing: 8,
                        children: [
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Octicons-mark-github.svg/2048px-Octicons-mark-github.svg.png',
                            width: 24,
                          ),
                          if (MediaQuery.sizeOf(context).width > 800)
                            Text(
                              'Flutter Screwdriver',
                              style: context.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => launchUrlString('https://pub.dev/packages/flutter_screwdriver'),
                    customBorder: StadiumBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        spacing: 8,
                        children: [
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/7/7e/Dart-logo.png',
                            width: 24,
                          ),
                          if (MediaQuery.sizeOf(context).width > 800)
                            Text(
                              'Pub.dev',
                              style: context.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.link),
                label: Text('LinkSpan'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.hourglass_bottom_rounded),
                label: Text('AsyncLoadingBuilder'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.view_column_outlined),
                label: Text('Affinity Widgets'),
              ),
            ],
          ),
          VerticalDivider(width: 1, color: context.colorScheme.onSurface.withValues(alpha: 0.1)),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              sizing: StackFit.expand,
              children: [
                LinkSpanExamples(),
                AsyncLoadingBuilderExamples(),
                AffinityWidgetExamples(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LinkSpanExamples extends StatelessWidget {
  const LinkSpanExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      children: [
        card(
          context,
          child: Text.rich(
            TextSpan(
              text: 'This is a non-highlighted ',
              children: [
                LinkSpan(
                  onTap: () {
                    launchUrlString('https://github.com/birjuvachhani/flutter_screwdriver');
                  },
                  text: 'Link Span ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' example.'),
              ],
            ),
          ),
        ),
        card(
          context,
          child: Text.rich(
            TextSpan(
              text: 'This is a highlighted ',
              children: [
                LinkSpan(
                  onTap: () {
                    launchUrlString('https://github.com/birjuvachhani/flutter_screwdriver');
                  },
                  text: 'Link Span',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                TextSpan(text: ' example.'),
              ],
            ),
          ),
        ),
        card(
          context,
          child: Text.rich(
            TextSpan(
              text: 'This is a hoverable ',
              children: [
                LinkSpan(
                  onTap: () {
                    launchUrlString('https://github.com/birjuvachhani/flutter_screwdriver');
                  },
                  text: 'Link Span',
                  hoverStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade900,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue.shade900,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                TextSpan(text: ' example.'),
              ],
            ),
          ),
        ),
        card(
          context,
          child: Text.rich(
            TextSpan(
              text: 'This is a hoverable ',
              children: [
                LinkSpan(
                  onTap: () {
                    launchUrlString('https://github.com/birjuvachhani/flutter_screwdriver');
                  },
                  text: 'Link Span',
                  prefix: Icon(Icons.link),
                  hoverColor: Colors.blue.shade900,
                  color: Colors.orange.shade700,
                ),
                TextSpan(text: ' example with prefix icon.'),
              ],
            ),
          ),
        ),
        card(
          context,
          child: Text.rich(
            TextSpan(
              text: 'This is a hoverable ',
              children: [
                LinkSpan(
                  onTap: () {
                    launchUrlString('https://github.com/birjuvachhani/flutter_screwdriver');
                  },
                  text: 'Link Span',
                  suffix: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Icon(Icons.open_in_new),
                  ),
                  hoverColor: Colors.blue.shade900,
                  color: Colors.orange.shade700,
                ),
                TextSpan(text: ' example with suffix icon.'),
              ],
            ),
          ),
        ),
        card(
          context,
          child: Text.rich(
            TextSpan(
              text: 'This is a hoverable ',
              children: [
                LinkSpan(
                  onTap: () {
                    launchUrlString('https://github.com/birjuvachhani/flutter_screwdriver');
                  },
                  text: 'Link Span',
                  hoverStyle: TextStyle(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  background: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.shade800,
                  ),
                  hoverBackground: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange.shade900,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                TextSpan(text: ' example with background.'),
              ],
            ),
          ),
        ),
        card(
          context,
          child: Text.rich(
            TextSpan(
              text: 'This is a hoverable ',
              children: [
                LinkSpan(
                  onTap: () {
                    launchUrlString('https://github.com/birjuvachhani/flutter_screwdriver');
                  },
                  text: 'Link Span',
                  hoverStyle: TextStyle(
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  background: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: context.colorScheme.surfaceContainer.withValues(alpha: 0.5),
                    border: Border.all(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                  ),
                  hoverBackground: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue.shade900,
                    border: Border.all(
                      color: Colors.blue.shade900,
                    ),
                  ),
                  style: TextStyle(fontWeight: FontWeight.w600),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                ),
                TextSpan(text: ' example with animation.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget card(BuildContext context, {required Widget child}) {
    return Card(
      elevation: 0,
      borderOnForeground: true,
      color: context.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.fade,
          softWrap: true,
          child: child,
        ),
      ),
    );
  }
}

class AsyncLoadingBuilderExamples extends StatelessWidget {
  const AsyncLoadingBuilderExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Text(
              'This button calls an async operation and shows a loading indicator while the operation is in progress.',
              textAlign: TextAlign.center,
            ),
          ),
          AsyncLoadingBuilder(
            builder: (context, isLoading, setFuture) {
              return FilledButton.icon(
                onPressed: () async {
                  if (isLoading) return;
                  setFuture(asyncOperation(context));
                },
                icon: isLoading
                    ? SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.colorScheme.onPrimary,
                        ),
                      )
                    : Icon(Icons.download),
                label: Text(isLoading ? 'Loading...' : 'Press Me'),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> asyncOperation(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Future.delayed(Duration(seconds: 3));
    messenger.showSnackBar(SnackBar(content: Text('Async operation completed!')));
    // Simulate some work
  }
}

class AffinityWidgetExamples extends StatelessWidget {
  const AffinityWidgetExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Affinity Widgets', style: context.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
              'A collection of widgets to arrange leading/trailing widgets with a child widget with less boilerplate.'),
        ),
        Expanded(
          child: GridView(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            children: [
              buildItem(
                context,
                title: 'A HorizontalAffinity widget with leading icon and label.',
                child: FilledButton(
                  onPressed: () {},
                  child: HorizontalAffinity(
                    leading: Icon(Icons.send),
                    child: Text('Send'),
                  ),
                ),
              ),
              buildItem(
                context,
                title: 'A HorizontalAffinity widget with trailing icon and label.',
                child: FilledButton(
                  onPressed: () {},
                  child: HorizontalAffinity(
                    trailing: Icon(Icons.send),
                    child: Text('Send'),
                  ),
                ),
              ),
              buildItem(
                context,
                title: 'A HorizontalAffinity widget with leading and trailing icon and label.',
                child: FilledButton(
                  onPressed: () {},
                  child: HorizontalAffinity(
                    leading: Icon(Icons.add),
                    trailing: Icon(Icons.arrow_right_alt_rounded),
                    child: Text('Button'),
                  ),
                ),
              ),
              buildItem(
                context,
                title: 'A HorizontalAffinity widget with mainAxisAlignment',
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.colorScheme.tertiary,
                    ),
                  ),
                  child: HorizontalAffinity(
                    leading: Icon(Icons.info_outline, color: context.colorScheme.tertiary),
                    mainAxisAlignment: MainAxisAlignment.start,
                    child: Text('Title',
                        style: TextStyle(color: context.colorScheme.tertiary, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              buildItem(
                context,
                title: 'A VerticalAffinity widget with leading icon and label.',
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.colorScheme.tertiary,
                    ),
                  ),
                  child: VerticalAffinity(
                    spacing: 0,
                    leading: Icon(Icons.arrow_upward_rounded, color: context.colorScheme.tertiary),
                    child: Text('Upvote',
                        style: TextStyle(color: context.colorScheme.tertiary, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              buildItem(
                context,
                title: 'A VerticalAffinity widget with leading, trailing icon and label.',
                fontSize: 18,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.colorScheme.tertiary,
                    ),
                  ),
                  child: VerticalAffinity(
                    spacing: 0,
                    leading: Icon(Icons.add, color: context.colorScheme.tertiary),
                    trailing: Icon(Icons.remove, color: context.colorScheme.tertiary),
                    child:
                        Text('50', style: TextStyle(color: context.colorScheme.tertiary, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildItem(
    BuildContext context, {
    required String title,
    required Widget child,
    double? fontSize,
  }) {
    return Card(
      elevation: 0,
      borderOnForeground: true,
      color: context.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: fontSize ?? 20),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> asyncOperation(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Future.delayed(Duration(seconds: 3));
    messenger.showSnackBar(SnackBar(content: Text('Async operation completed!')));
    // Simulate some work
  }
}
