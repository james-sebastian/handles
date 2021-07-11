part of "../pages.dart";

class PickImagesPage extends StatefulWidget {

  final String handlesID;
  const PickImagesPage({ Key? key, required this.handlesID }) : super(key: key);

  @override
  _PickImagesPageState createState() => _PickImagesPageState();
}

class _PickImagesPageState extends State<PickImagesPage> {
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
      List<AssetEntity> media = await albums[0].getAssetListPaged(currentPage, 60);
      List<Widget> temp = [];
      List<AssetEntity> rawTemp = [];

      for (var asset in media) {
        if(asset.type == AssetType.image){
          rawTemp.add(asset);
          temp.add(
            FutureBuilder<Uint8List?>(
              future: asset.thumbDataWithSize(300, 300),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
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
    print(selectedEntities);

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
          title: Text("Send images"),
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
                            "Please select at least one image",
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
                  Get.to(() => PreviewImagesPage(
                    handlesID: widget.handlesID,
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
                              if(selectedEntities.toList().length == 10){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Container(
                                      height: MQuery.height(0.025, context),
                                      child: Center(
                                        child: Text(
                                          "You only can send 10 images at one time",
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