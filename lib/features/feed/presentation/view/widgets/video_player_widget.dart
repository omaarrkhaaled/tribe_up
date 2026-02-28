import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tribe_up/core/resources/color_managar.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    try {
      // check cache first
      final fileInfo = await DefaultCacheManager().getFileFromCache(widget.url);
      File? videoFile = fileInfo?.file;
      // not cached → download and cache it
      videoFile ??= await DefaultCacheManager().getSingleFile(widget.url);

      _controller = VideoPlayerController.file(videoFile);
      await _controller.initialize();
      if (mounted) setState(() => _initialized = true);
    } catch (e) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 200,
        color: ColorManager.black,
        child: Center(
          child: Icon(Icons.videocam_off, size: 40, color: ColorManager.grey),
        ),
      );
    }

    if (!_initialized) {
      return Container(
        height: 200,
        color: ColorManager.white,
        child: Center(
          child: CircularProgressIndicator(color: ColorManager.white),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: _toggleControls,
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_controller),
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [ColorManager.black, Colors.transparent],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: _controller,
                    builder: (context, value, child) {
                      final position = value.position;
                      final duration = value.duration;
                      final progress = duration.inMilliseconds > 0
                          ? position.inMilliseconds / duration.inMilliseconds
                          : 0.0;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 12,
                              ),
                              trackHeight: 2,
                              activeTrackColor: ColorManager.blue,
                              inactiveTrackColor: ColorManager.white,
                              thumbColor: ColorManager.white,
                            ),
                            child: Slider(
                              value: progress.clamp(0.0, 1.0),
                              onChanged: (val) {
                                final newPos = Duration(
                                  milliseconds: (val * duration.inMilliseconds)
                                      .toInt(),
                                );
                                _controller.seekTo(newPos);
                              },
                            ),
                          ),

                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                }),
                                child: Icon(
                                  value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: ColorManager.white,
                                  size: 28,
                                ),
                              ),

                              const SizedBox(width: 8),

                              Text(
                                '${_formatDuration(position)} / ${_formatDuration(duration)}',
                                style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: 11,
                                ),
                              ),

                              const Spacer(),

                              GestureDetector(
                                onTap: () => setState(() {
                                  _controller.setVolume(
                                    value.volume > 0 ? 0 : 1,
                                  );
                                }),
                                child: Icon(
                                  value.volume > 0
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: ColorManager.white,
                                  size: 22,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Icon(
                                Icons.fullscreen,
                                color: ColorManager.white,
                                size: 22,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
