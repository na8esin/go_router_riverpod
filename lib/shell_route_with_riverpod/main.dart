import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

@Riverpod(keepAlive: true)
class CounterA extends _$CounterA {
  @override
  int build() => 0;

  void increment() => state++;
}

@Riverpod(keepAlive: true)
class CounterB extends _$CounterB {
  @override
  int build() => 0;

  void increment() => state++;
}

void main() {
  runApp(
    const ProviderScope(child: App()),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/a',
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/a',
          builder: (BuildContext context, GoRouterState state) {
            return const ScreenA();
          },
        ),
        GoRoute(
          path: '/b',
          builder: (BuildContext context, GoRouterState state) {
            return const ScreenB();
          },
        ),
      ],
    ),
  ],
);

/// Riverpodで書き直すサンプル
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
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'A Screen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'B Screen',
          ),
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/a')) {
      return 0;
    }
    if (location.startsWith('/b')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/a');
        break;
      case 1:
        GoRouter.of(context).go('/b');
        break;
    }
  }
}

class ScreenA extends ConsumerWidget {
  const ScreenA({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Screen A'),
          TextButton(
            onPressed: () => ref.read(counterAProvider.notifier).increment(),
            child: const Text('increment'),
          ),
          Text('${ref.watch(counterAProvider)}'),
        ],
      ),
    );
  }
}

class ScreenB extends ConsumerWidget {
  const ScreenB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Screen B'),
          TextButton(
            onPressed: () => ref.read(counterBProvider.notifier).increment(),
            child: const Text('increment'),
          ),
          Text('${ref.watch(counterBProvider)}'),
        ],
      ),
    );
  }
}
