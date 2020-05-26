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

class Ani24VideoPlayerState extends State<Ani24VideoPlayer> {

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
      _controller = VideoPlayerController.network(widget.videoUrl);
      _controller.addListener(() {
        setState(() {});
      });
      _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void play() {
    _controller.play();
  }

  void pause() {
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          Center(
            child: InkWell(
              onTap: () {
                if(_controller.value.isPlaying)
                  pause();
                else
                  play();
              },
              child: Container(
                width: 50,
                height: 50,
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}