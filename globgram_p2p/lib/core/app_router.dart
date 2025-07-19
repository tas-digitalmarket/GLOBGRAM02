import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:globgram_p2p/features/room_selection/presentation/room_selection_page.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_bloc.dart';
import 'package:globgram_p2p/features/chat/presentation/chat_page.dart';
import 'package:globgram_p2p/core/service_locator.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/room-selection',
      name: 'roomSelection',
      builder: (context, state) => const RoomSelectionPage(),
    ),
    GoRoute(
      path: '/chat/:roomId',
      name: 'chat',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        // Read asCaller query parameter, default to false (callee)
        final asCallerParam = state.uri.queryParameters['asCaller'];
        final asCaller = asCallerParam?.toLowerCase() == 'true';
        
        return BlocProvider<ChatBloc>(
          create: (context) {
            final chatBloc = getIt<ChatBloc>();
            chatBloc.initializeConnection(roomId, asCaller: asCaller);
            return chatBloc;
          },
          child: ChatPage(roomId: roomId),
        );
      },
    ),
  ],
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GlobGram P2P'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.video_call, size: 100, color: Colors.teal),
            const SizedBox(height: 32),
            const Text(
              'Welcome to GlobGram P2P',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Peer-to-peer video calling made simple',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () => context.go('/room-selection'),
              icon: const Icon(Icons.meeting_room),
              label: const Text('Get Started'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
