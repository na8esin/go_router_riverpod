import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

void main() {
  runApp(const App());
}

final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/a',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNavBar(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
                navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    path: '/a',
                    builder: (context, state) {
                      return const ScreenA();
                    },
                  ),
                ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                path: '/b',
                builder: (context, state) {
                  return const ScreenB();
                },
              )
            ])
          ])
    ]);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.school),
            icon: Icon(Icons.school_outlined),
            label: 'School',
          ),
        ],
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) {
          switch (index) {
            case 0:
              GoRouter.of(context).go('/a');
              break;
            case 1:
              GoRouter.of(context).go('/b');
              break;
          }
        },
      ),
    );
  }
}

class ScreenA extends StatefulWidget {
  const ScreenA({super.key});

  @override
  State<StatefulWidget> createState() => ScreenAState();
}

class ScreenAState extends State<ScreenA> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Text('Counter: $_counter'),
      TextButton(
          onPressed: () {
            setState(() {
              _counter++;
            });
          },
          child: const Text('Increment counter')),
    ]));
  }
}

class ScreenB extends StatefulWidget {
  const ScreenB({super.key});

  @override
  State<StatefulWidget> createState() => ScreenBState();
}

class ScreenBState extends State<ScreenB> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Text('Counter: $_counter'),
      TextButton(
          onPressed: () {
            setState(() {
              _counter++;
            });
          },
          child: const Text('Increment counter'))
    ]));
  }
}
