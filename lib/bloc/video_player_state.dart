part of 'video_player_bloc.dart';

enum VideoStatus { initial, loading, success, failure }

class VideoPlayerState extends Equatable {
  final VideoStatus status;
  final List<String> videos;
  final String? selectedVideoUrl;

  const VideoPlayerState({
    required this.status,
    required this.videos,
    this.selectedVideoUrl,
  });

  factory VideoPlayerState.initial() {
    return const VideoPlayerState(
      status: VideoStatus.initial,
      videos: [],
      selectedVideoUrl: null,
    );
  }

  @override
  List<Object?> get props => [status, videos, selectedVideoUrl];

  VideoPlayerState copyWith({
    VideoStatus? status,
    List<String>? videos,
    String? selectedVideoUrl,
  }) {
    return VideoPlayerState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      selectedVideoUrl: selectedVideoUrl ?? this.selectedVideoUrl,
    );
  }
}
