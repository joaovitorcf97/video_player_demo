part of 'video_player_bloc.dart';

abstract class VideoPlayerEvent extends Equatable {}

class LoadVideos extends VideoPlayerEvent {
  @override
  List<Object?> get props => [];
}

class SelectVideo extends VideoPlayerEvent {
  final String videoURL;

  SelectVideo({required this.videoURL});

  @override
  List<Object?> get props => [videoURL];
}
