part of "../pages.dart";

class PreviewVideosPage extends StatefulWidget {

  final Set<AssetEntity> selectedEntities;

  const PreviewVideosPage({ Key? key, required this.selectedEntities}) : super(key: key);

  @override
  _PreviewVideosPageState createState() => _PreviewVideosPageState();
}

class _PreviewVideosPageState extends State<PreviewVideosPage> {

  late AssetEntity assetMedia;

  @override
  void initState() { 
    super.initState();
    assetMedia = widget.selectedEntities.first;
  }

  @override
  Widget build(BuildContext context) {

    Future<ChewieController> _initializeController(int index) async {

      File? originFile = await widget.selectedEntities.toList()[index].loadFile();

      print(originFile);

      final videoPlayerController = VideoPlayerController.file(originFile!);

      await videoPlayerController.initialize();

      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
      );
      
      return chewieController;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
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
        title: Font.out(
          "Send ${widget.selectedEntities.length} videos",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
          color: Colors.white
        ),
        actions: [
          IconButton(
            icon: AdaptiveIcon(
              android: Icons.arrow_right_alt,
              iOS: CupertinoIcons.chevron_right,
              color: Colors.white
            ),
            onPressed: (){},
          )
        ]
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: MQuery.height(1, context),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Expanded(
                  flex: 9,
                  child: PageView.builder(
                    itemCount: widget.selectedEntities.length,
                    itemBuilder: (context, index){
                      return FutureBuilder<ChewieController>(
                        future: _initializeController(index),
                        builder: (context, snapshot){
                          return Chewie(controller: snapshot.data!);
                        }
                      );
                    }
                  )
                ),
              ],
            ),
          ),
          Container(
            height: MQuery.height(0.1, context),
            width: MQuery.width(1, context),
            padding: EdgeInsets.all(MQuery.height(0.02, context)),
            color: Colors.black.withOpacity(0.5),
            child: TextFormField(
              maxLines: 6,
              style: TextStyle(
                color: Colors.white
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5)
                ),
                hintText: "Type a message",
                contentPadding: EdgeInsets.fromLTRB(
                  MQuery.width(0.02, context),
                  MQuery.height(0.0175, context),
                  MQuery.width(0.02, context),
                  MQuery.height(0, context)
                ),
                border: InputBorder.none
              ),
            )
          )
        ],
      )
    );
  }
}