import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ikut3/data/web_socket_provider.dart';

class HomeStateNotifier extends StateNotifier<int> {
  HomeStateNotifier() : super(0);

  void increase() {
    state += 1;
  }
}

final homeStateNotifierProvider =
    StateNotifierProvider((ref) => HomeStateNotifier());

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeStateNotifierProvider);
    final stateNotifier = ref.read(homeStateNotifierProvider.notifier);
    // ignore: unused_local_variable
    final webSocket = ref.watch(webSocketProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("iKut 3"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              state.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          stateNotifier.increase();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
