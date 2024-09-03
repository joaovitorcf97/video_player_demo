import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_demo/bloc/video_player_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VideoPlayerDemo(),
    );
  }
}

class VideoPlayerDemo extends StatefulWidget {
  const VideoPlayerDemo({super.key});

  @override
  State<VideoPlayerDemo> createState() => _VideoPlayerDemoState();
}

class _VideoPlayerDemoState extends State<VideoPlayerDemo> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoPlayerBloc>(
      create: (context) => VideoPlayerBloc()..add(LoadVideos()),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.blue),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black87,
              ),
              height: MediaQuery.of(context).size.height * .3,
              child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
                builder: (context, state) {
                  if (state.status == VideoStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == VideoStatus.success) {
                    return state.selectedVideoUrl != null
                        ? ChewiePlayerWidget(videoUrl: state.selectedVideoUrl!)
                        : const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == VideoStatus.failure) {
                    return const Center(child: Text('Erro'));
                  }

                  return const Center(child: Text('Erro desconhecido'));
                },
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
              builder: (context, state) {
                if (state.status == VideoStatus.success) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.videos.length,
                      itemBuilder: (context, index) {
                        final videoUrl = state.videos[index];
                        return ListTile(
                          title: Text(
                            'Video ${index + 1}',
                            style: TextStyle(
                              color:
                                  state.videos[index] == state.selectedVideoUrl
                                      ? Colors.blueAccent
                                      : Colors.black,
                            ),
                          ),
                          onTap: () {
                            context
                                .read<VideoPlayerBloc>()
                                .add(SelectVideo(videoURL: videoUrl));
                          },
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}

class ChewiePlayerWidget extends StatefulWidget {
  final String videoUrl;

  const ChewiePlayerWidget({super.key, required this.videoUrl});

  @override
  State<ChewiePlayerWidget> createState() => _ChewiePlayerWidgetState();
}

class _ChewiePlayerWidgetState extends State<ChewiePlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(ChewiePlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _initializePlayer();
    }
  }

  void _initializePlayer() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then(
            (_) {
              setState(
                () {
                  _chewieController = ChewieController(
                    videoPlayerController: _videoPlayerController!,
                    autoPlay: true,
                    looping: true,
                    fullScreenByDefault: false,
                    allowFullScreen: true,
                    showControls: true,
                    controlsSafeAreaMinimum: EdgeInsets.zero,
                  );
                },
              );
            },
          );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized) {
      return Chewie(controller: _chewieController!);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
