part of "../pages.dart";

class ImagePreviewer extends StatelessWidget {
  final String imageURL;
  final String heroTag;
  final String sender;
  final String content;
  final DateTime timeStamp;

  const ImagePreviewer({
    Key? key,
    required this.imageURL,
    required this.heroTag,
    required this.sender,
    required this.timeStamp,
    required this.content
  })
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        toolbarHeight: MQuery.height(0.07, context),
        leading: IconButton(
          icon: AdaptiveIcon(
            android: Icons.arrow_back,
            iOS: CupertinoIcons.back,
          ),
          onPressed: (){
            Get.back();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Font.out(
              this.sender,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              color: Colors.white
            ),
            Font.out(
              DateFormat.yMd().add_jm().format(timeStamp),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
              color: Colors.white
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Settings",
            icon: AdaptiveIcon(
              android: Icons.more_vert_rounded,
              iOS: CupertinoIcons.ellipsis,
            ),
            onPressed: (){}
          ),
        ]
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Hero(
            tag: this.heroTag,
            child: PinchZoom(
              image: Image.network(this.imageURL),
              zoomedBackgroundColor: Colors.black,
              resetDuration: const Duration(milliseconds: 100),
              maxScale: 1,
              onZoomStart: (){print('Start zooming');},
              onZoomEnd: (){print('Stop zooming');},
            ),
          ),
          Container(
            height: MQuery.height(0.1, context),
            color: Colors.black.withOpacity(0.5),
            child: SelectableLinkify(
              onOpen: (link) async {
                print(link.url);
                await launch(link.url);
              },
              text: this.content,
              textAlign: TextAlign.start,
              style: TextStyle(
                  height: 1.25,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
            ),
          )
        ],
      )
    );
  }
}
