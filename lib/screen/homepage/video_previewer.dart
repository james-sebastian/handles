part of "../pages.dart";

class VideoPreviewer extends StatefulWidget {

  final String videoURL;
  final String heroTag;
  final String sender;
  final String content;
  final DateTime timeStamp;

  const VideoPreviewer({
    Key? key,
    required this.videoURL,
    required this.heroTag,
    required this.sender,
    required this.timeStamp,
    required this.content
  })
  : super(key: key);

  @override
  _VideoPreviewerState createState() => _VideoPreviewerState();
}

class _VideoPreviewerState extends State<VideoPreviewer> {

  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(
        this.widget.videoURL
      ),
      autoInitialize: true,
      autoPlay: false,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }

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
              this.widget.sender,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              color: Colors.white
            ),
            Font.out(
              DateFormat.yMd().add_jm().format(widget.timeStamp),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
              color: Colors.white
            ),
          ],
        ),
      ),
      body: Container(
        height: MQuery.height(0.9, context),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: this.widget.heroTag,
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 30
                        ),
                      ),
                      Chewie(
                        controller: _chewieController,
                      )
                    ]
                  )
                )
              ),
            ),
            Container(
              width: MQuery.width(1, context),
              height: MQuery.height(0.1, context),
              padding: EdgeInsets.all(MQuery.height(0.01, context)),
              color: Colors.black.withOpacity(0.5),
              child: SelectableLinkify(
                onOpen: (link) async {
                  print(link.url);
                  await launch(link.url);
                },
                text: this.widget.content,
                textAlign: TextAlign.start,
                style: TextStyle(
                    height: 1.25,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15),
              ),
            )
          ],
        ),
      )
    );
  }
}