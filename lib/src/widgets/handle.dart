import 'dart:ui';

import 'package:flutter/material.dart';

const _padding = 12.0;

class Handle extends StatefulWidget {
  const Handle({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    required this.position,
    required this.onPositionChanged,
    this.showHandle = false,
    this.minPosition,
    this.maxPosition,
    this.playing = false,
  });

  final double height;
  final double width;
  final Color color;
  final double position;
  final Function(double position) onPositionChanged;
  final bool showHandle;

  final double? minPosition;
  final double? maxPosition;

  final bool playing;

  @override
  State<Handle> createState() => _HandleState();
}

class _HandleState extends State<Handle> {
  var _isDragging = false;
  var _position = 0.0;

  late double _handleSize;

  @override
  void initState() {
    _position = widget.position;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Handle oldWidget) {
    if (!_isDragging && widget.position != oldWidget.position) {
      _position = widget.position;
      print('Handle Position:  $_position');
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _buildHandle() {
    return GestureDetector(
      onHorizontalDragStart:
          widget.showHandle ? (details) => _isDragging = true : null,
      onHorizontalDragEnd:
          widget.showHandle ? (details) => _isDragging = false : null,
      onHorizontalDragUpdate: widget.showHandle
          ? (details) {
              final newPosition = _position + details.delta.dx;
              if (widget.minPosition != null &&
                  newPosition < widget.minPosition!) {
                return;
              }

              if (widget.maxPosition != null &&
                  newPosition > widget.maxPosition!) {
                return;
              }

              setState(() {
                _position = newPosition;
                widget.onPositionChanged(_position);
              });
            }
          : null,
      child: Padding(
        padding: widget.showHandle
            ? const EdgeInsets.only(
                left: _padding,
                right: _padding,
                bottom: _padding,
              )
            : EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              height: widget.height * 0.9,
              width: widget.width,
              color: widget.color,
            ),
            if (widget.showHandle)
              Container(
                height: _handleSize,
                width: _handleSize,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _handleSize = widget.width * 6;

    var newPosition = _position;

    if (widget.showHandle) {
      newPosition -= _handleSize / 2;
      newPosition += 1;
      newPosition -= _padding;
    }

    return Positioned(
      key: const ValueKey('static'),
      top: 0,
      left: newPosition,
      child: _buildHandle(),
    );

    return widget.playing
        ? AnimatedPositioned(
            key: const ValueKey('animated'),
            top: 0,
            left: newPosition,
            duration: const Duration(milliseconds: 50),
            child: _buildHandle(),
          )
        : Positioned(
            key: const ValueKey('static'),
            top: 0,
            left: newPosition,
            child: _buildHandle(),
          );
  }
}
