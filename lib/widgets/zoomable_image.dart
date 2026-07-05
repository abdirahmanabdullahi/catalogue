import 'package:flutter/material.dart';

import '../theme.dart';

/// An image that opens a full-screen pinch/zoom/pan viewer when tapped.
class ZoomableImage extends StatelessWidget {
  final String asset;
  final double? height;
  final BoxFit fit;
  final String? heroTag;

  const ZoomableImage({
    super.key,
    required this.asset,
    this.height,
    this.fit = BoxFit.contain,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final tag = heroTag ?? asset;
    final image = Image.asset(
      asset,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => SizedBox(
        height: height,
        child: const Center(
            child: Icon(Icons.image_not_supported_outlined,
                color: GfColors.grey400)),
      ),
    );
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            barrierColor: Colors.black87,
            pageBuilder: (_, _, _) =>
                _ImageViewer(asset: asset, heroTag: tag),
          )),
          child: Hero(tag: tag, child: image),
        ),
        const Positioned(
          right: 8,
          bottom: 8,
          child: IgnorePointer(
            child: Chip(
              avatar: Icon(Icons.zoom_in, size: 16, color: GfColors.grey700),
              label: Text('Tap to zoom', style: TextStyle(fontSize: 11)),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final String asset;
  final String heroTag;

  const _ImageViewer({required this.asset, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Center(
                child: Hero(
                  tag: heroTag,
                  child: Image.asset(asset, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            right: 12,
            child: Material(
              color: Colors.black45,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
