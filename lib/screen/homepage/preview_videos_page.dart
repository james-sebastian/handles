part of "../pages.dart";

class PreviewVideosPage extends StatefulWidget {

  final Set<AssetEntity> selectedEntities;
  final String handlesID;
  final String replyTo;

  const PreviewVideosPage({ Key? key, required this.selectedEntities, required this.handlesID, required this.replyTo}) : super(key: key);

  @override
  _PreviewVideosPageState createState() => _PreviewVideosPageState();
}

class _PreviewVideosPageState extends State<PreviewVideosPage> {

  late AssetEntity assetMedia;
  TextEditingController chatController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    assetMedia = widget.selectedEntities.first;
  }

  @override
  Widget build(BuildContext context) {

    Future<ChewieController> _initializeController(int index) async {
      File? originFile = await widget.selectedEntities.toList()[index].loadFile();
      final videoPlayerController = VideoPlayerController.file(originFile!);
      await videoPlayerController.initialize();
      final chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
      );
      return chewieController;
    }

    return Consumer(
      builder: (ctx, watch,child) {

        final _handlesProvider = watch(handlesProvider);
        final _chatProvider = watch(chatProvider);

        return StreamBuilder<HandlesModel>(
          stream: _handlesProvider.handlesModelGetter(widget.handlesID),
          builder: (context, snapshot) {
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
                      android: Icons.send,
                      iOS: CupertinoIcons.paperplane_fill,
                      color: Colors.white
                    ),
                    onPressed: (){
                      widget.selectedEntities.forEach((element) {
                        element.file.then((file){
                          _chatProvider.uploadVideoURL(file!.path, snapshot.data!.name).then((mediaURL){
        
                            print(mediaURL);
        
                            _chatProvider.sendVideoChat(
                              widget.handlesID,
                              ChatModel(
                                replyTo: widget.replyTo,
                                id: Uuid().v4(),
                                type: ChatType.image,
                                content: chatController.text,
                                mediaURL: mediaURL,
                                readBy: [],
                                deletedBy: [],
                                timestamp: DateTime.now(),
                                sender: "",
                                isPinned: false
                              )
                            );
                          });
                        });
                      });
        
                      Get.offAll(() => Homepage(), transition: Transition.cupertino);
                    },
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
                      controller: chatController,
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
        );
      },
    );
  }
}