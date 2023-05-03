// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:shimmer/shimmer.dart';
import 'package:status_alert/status_alert.dart';

///

class ImageCard extends StatefulWidget {
  ImageCard({Key? key, this.images}) : super(key: key);

  var images;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              /// Donload picture via Url
              try {
                var imageId = await ImageDownloader.downloadImage(
                    widget.images[index].url,
                    destination:
                        AndroidDestinationType.custom(directory: 'GENIE_IMG'));
                if (imageId == null) {
                  return;
                } else {
                  
                  StatusAlert.show(
                    context,
                    duration: Duration(seconds: 2),
                    title: 'GENIE',
                    subtitle: 'Image has been saved to your gallery. 🍱',
                    configuration: IconConfiguration(
                        icon: Icons.favorite_border_rounded,
                        color: Colors.white),
                    maxWidth: 260,
                  );
                }
                var path = await ImageDownloader.findPath(imageId);
              } on PlatformException catch (error) {
                print(error);
              }
            },
            child: Card(
              child: CachedNetworkImage(
                imageUrl: widget.images[index].url,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    SizedBox(
                        height: 150,
                        width: 150,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.withOpacity(.3),
                          highlightColor: Colors.grey,
                          child: Container(
                            height: 220,
                            width: 130,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          );
        });
  }
}
