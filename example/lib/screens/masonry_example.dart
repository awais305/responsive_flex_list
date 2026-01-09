import 'package:flutter/material.dart';
import 'package:responsive_flex_list/responsive_flex_list.dart';

class MasonryExample extends StatefulWidget {
  const MasonryExample({super.key});

  @override
  State<MasonryExample> createState() => _MasonryExampleState();
}

class _MasonryExampleState extends State<MasonryExample> {
  bool isImagesLoaded = false;
  int _loaded = 0;
  int _total = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Masonry Layout', style: TextStyle(fontSize: 20)),
          ),
          body: Stack(
            children: [
              ResponsiveFlexMasonry.pinterest(
                padding: EdgeInsets.all(10),
                items: imagesWithCaptions,
                crossAxisSpacing: 5,
                onLoadingProgress: (loaded, total) {
                  if (loaded == total) {
                    isImagesLoaded = true;
                  }
                  setState(() {
                    _loaded = loaded;
                    _total = total;
                  });
                },
                itemBuilder: (item, index) => _returnImageWidget(item, index),
              ),
              if (isImagesLoaded == false)
                Material(
                  color: Colors.black54,
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 30,
                        ),
                        child: Text('preparing images $_loaded of $_total'),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

_returnImageWidget(Map<String, String> item, int index) => Column(
  spacing: 5,
  children: [
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        item['url']!,
        fit: BoxFit.fitWidth,
        width: double.infinity,
      ),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              item['caption']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5, top: 0, bottom: 0),
            child: Icon(Icons.more_horiz, size: 15),
          ),
        ],
      ),
    ),
  ],
);

///
///
///
///
///
///
///

final List<Map<String, String>> imagesWithCaptions = [
  {
    "url": "https://picsum.photos/200/300",
    "caption": "Capturing moments that matter",
  },
  {
    "url": "https://picsum.photos/300/200",
    "caption": "A beautiful perspective",
  },
  {
    "url": "https://picsum.photos/400/400",
    "caption": "Where light meets shadow",
  },
  {
    "url": "https://picsum.photos/500/300",
    "caption": "Simple beauty in everyday life",
  },
  {
    "url": "https://picsum.photos/250/600",
    "caption": "Finding magic in the ordinary",
  },
  {
    "url": "https://picsum.photos/600/250",
    "caption": "A moment frozen in time",
  },
  {
    "url": "https://picsum.photos/350/500",
    "caption": "Stories told through imagery",
  },
  {"url": "https://picsum.photos/500/350", "caption": "The art of seeing"},
  {"url": "https://picsum.photos/450/450", "caption": "Natural elegance"},
  {
    "url": "https://picsum.photos/800/400",
    "caption": "Exploring visual harmony",
  },
  {"url": "https://picsum.photos/400/800", "caption": "Pure and unfiltered"},
  {
    "url": "https://picsum.photos/700/500",
    "caption": "Discovering hidden details",
  },
  {"url": "https://picsum.photos/1200/800", "caption": "A glimpse of wonder"},
  {"url": "https://picsum.photos/800/1200", "caption": "Timeless and serene"},
  {"url": "https://picsum.photos/600/900", "caption": "Creating visual poetry"},
  {
    "url": "https://picsum.photos/1024/768",
    "caption": "Moments worth remembering",
  },
  {
    "url": "https://picsum.photos/250/600",
    "caption": "The beauty of simplicity",
  },
  {
    "url": "https://picsum.photos/350/500",
    "caption": "Embracing the unexpected",
  },
  {"url": "https://picsum.photos/500/350", "caption": "Colors and composition"},
  {"url": "https://picsum.photos/450/450", "caption": "A fresh perspective"},
  {"url": "https://picsum.photos/500/1000", "caption": "Lost in the details"},
  {
    "url": "https://picsum.photos/500/700",
    "caption": "Where creativity meets reality",
  },
  {"url": "https://picsum.photos/1000/500", "caption": "Perfectly imperfect"},
  {
    "url": "https://picsum.photos/900/600",
    "caption": "Visual storytelling at its finest",
  },
  {"url": "https://picsum.photos/800/400", "caption": "Capturing the essence"},
];
