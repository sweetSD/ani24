import 'package:ani24/Widgets/texts.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Ani24VideoPlayer extends StatefulWidget {

  final String videoUrl;
  double width;
  double height;

  Ani24VideoPlayer(this.videoUrl, {this.width = double.infinity, this.height = double.infinity});

  @override
  Ani24VideoPlayerState createState() => Ani24VideoPlayerState();
}

class Ani24VideoPlayerState extends State<Ani24VideoPlayer> with SingleTickerProviderStateMixin{

  VideoPlayerController _controller;
  ChewieController _chewieController;

  AnimationController _animController;
  Animation<double> _fadeAnimation;

  int length = 0;
  int position = 0;

  @override
  void initState() {
    super.initState();
      _controller = VideoPlayerController.network(widget.videoUrl);
      _controller.addListener(() {
        setState(() {});
      });
      _controller.initialize().then((value) {
        _chewieController = ChewieController(
          videoPlayerController: _controller,
          aspectRatio: _controller.value.aspectRatio,
        );
      });

      _animController = AnimationController(vsync: this, duration: Duration(seconds: 1));
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animController);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }

  void play() {
    _controller.play();
  }

  void pause() {
    _controller.pause();
  }

  void forward(int sec) async {
    _controller.seekTo(await _controller.position + Duration(seconds: 10));
  }

  void rewind(int sec) async {
    _controller.seekTo(await _controller.position - Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {

    if (_controller.value.initialized) {
      length = _controller.value.duration.inSeconds;
      _controller.position.then((value) => position = value.inSeconds);
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if(_chewieController != null)
            Chewie(controller: _chewieController,),
          // AspectRatio(
          //   aspectRatio: _controller.value.aspectRatio,
          //   child: VideoPlayer(_controller),
          // ),
          // Container(
          //   width: double.infinity,
          //   height: double.infinity,
          //   alignment: Alignment.bottomCenter,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: <Widget>[
          //       Slider(
          //         value: position.toDouble(),
          //         min: 0,
          //         max: length.toDouble(),
          //         onChangeStart: (value) {

          //         },
          //         onChanged: (value) {

          //         },
          //         onChangeEnd: (value) {
          //           _controller.seekTo(Duration(seconds: value.toInt()));
          //         },
          //       ),
          //       Row(
          //         children: <Widget>[
          //           // Play . Pause Button
          //           InkWell(
          //             onTap: () {
          //               if(_controller.value.isPlaying)
          //                 pause();
          //               else
          //                 play();
          //             },
          //             child: Container(
          //               width: 50,
          //               height: 50,
          //               child: Icon(
          //                 _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          //               ),
          //             ),
          //           ),

          //           // Rewind 10 sec..
          //           InkWell(
          //             onTap: () {
          //               rewind(10);
          //             },
          //             child: Container(
          //               width: 50,
          //               height: 50,
          //               child: Icon(Icons.fast_rewind),
          //             ),
          //           ),

          //           // Forward 10 sec..
          //           InkWell(
          //             onTap: () {
          //               forward(10);
          //             },
          //             child: Container(
          //               width: 50,
          //               height: 50,
          //               child: Icon(Icons.fast_forward),
          //             ),
          //           ),
          //         ],
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}