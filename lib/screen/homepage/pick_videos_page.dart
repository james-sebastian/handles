part of "../pages.dart";

class PickVideosPage extends StatefulWidget {
  const PickVideosPage({ Key? key }) : super(key: key);

  @override
  _PickVideosPageState createState() => _PickVideosPageState();
}

class _PickVideosPageState extends State<PickVideosPage> {
  List<Widget> _mediaList = [];
  List<AssetEntity> _rawMediaList = [];
  Set<AssetEntity> selectedEntities = Set();
  int currentPage = 0;
  late int lastPage;

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {

      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: false);
      List<AssetEntity> media = await albums[0].getAssetListPaged(currentPage, 1000);
      List<Widget> temp = [];
      List<AssetEntity> rawTemp = [];

      for (var asset in media) {
        if(asset.type == AssetType.video){

          print(asset);

          rawTemp.add(asset);
          temp.add(
            FutureBuilder<Uint8List?>(
              future: asset.thumbDataWithSize(300, 300),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                return Container();
              },
            ),
          );
        }
      }

      setState(() {
        _mediaList.addAll(temp);
        _rawMediaList.addAll(rawTemp);
        currentPage++;
      });

    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double midBar = 55;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Palette.primary
    ));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:  AdaptiveIcon(
              android: Icons.close,
              iOS: CupertinoIcons.xmark,
              color: Colors.white
            ),
            onPressed: (){
              Get.back();
            }
          ),
          title: Text("Send videos"),
          actions: [
            IconButton(
              icon: AdaptiveIcon(
                android: Icons.arrow_right_alt,
                iOS: CupertinoIcons.chevron_right,
                color: Colors.white
              ),
              onPressed: (){
                if(selectedEntities.length == 0){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        height: MQuery.height(0.025, context),
                        child: Center(
                          child: Text(
                            "Please select at least one video",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                            )
                          )
                        ),
                      ),
                      backgroundColor: Palette.warning,
                      behavior: SnackBarBehavior.floating,
                    )
                  );
                } else {
                  print(selectedEntities);
                  Get.to(() => PreviewVideosPage(
                    selectedEntities: selectedEntities,
                  ), transition: Transition.cupertino);
                }
              },
            )
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scroll) {
            _handleScrollEvent(scroll);
            return false;
          },
          child: Container(
            height: size.height,
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: midBar,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.025,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Recent",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16,
                        )
                      ),
                    ]
                  )
                ),
                Expanded(
                  child: Container(
                    width: size.width,
                    child: _mediaList == []
                      ? SizedBox()
                      : GridView.builder(
                      itemCount: _mediaList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){
                            if(selectedEntities.toList().indexOf(_rawMediaList[index]) >= 0){
                              setState(() {
                                selectedEntities.remove(_rawMediaList[index]);
                              });
                            } else {
                              if(selectedEntities.toList().length == 5){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Container(
                                      height: MQuery.height(0.025, context),
                                      child: Center(
                                        child: Text(
                                          "You only can send 5 videos at one time",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400
                                          )
                                        )
                                      ),
                                    ),
                                    backgroundColor: Palette.warning,
                                    behavior: SnackBarBehavior.floating,
                                  )
                                );
                              } else {
                                setState(() {
                                  selectedEntities.add(_rawMediaList[index]);
                                });
                              }
                            }
                          },
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Positioned.fill(
                                child: _mediaList[index]
                              ),
                              selectedEntities.toList().indexOf(_rawMediaList[index]) >= 0
                              ? ZoomIn(
                                  duration: Duration(milliseconds: 100),
                                  child: Positioned(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundColor: Palette.primary,
                                        radius: 10,
                                        child: Text(
                                          (selectedEntities.toList().indexOf(_rawMediaList[index]) + 1).toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                            ],
                          )
                        );
                      }
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}