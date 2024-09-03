import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerBloc() : super(VideoPlayerState.initial()) {
    on<LoadVideos>(_onLoadVideo);
    on<SelectVideo>(_onSelectVideo);
  }

  Future<void> _onLoadVideo(
    LoadVideos event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(state.copyWith(status: VideoStatus.loading, videos: []));

    final List<String> videos = [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ];

    emit(state.copyWith(
      status: VideoStatus.success,
      videos: videos,
      selectedVideoUrl: videos.first,
    ));
  }

  Future<void> _onSelectVideo(
    SelectVideo event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(state.copyWith(status: VideoStatus.loading));

    emit(state.copyWith(
      status: VideoStatus.success,
      selectedVideoUrl: event.videoURL,
    ));
  }
}
