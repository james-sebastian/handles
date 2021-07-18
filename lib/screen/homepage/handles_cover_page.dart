part of "../pages.dart";

class HandlesCoverPage extends StatefulWidget {

  final String handlesName;
  final String handlesID;
  final String handlesCoverURL;
  const HandlesCoverPage({ Key? key, required this.handlesName, required this.handlesCoverURL, required this.handlesID}) : super(key: key);

  @override
  _HandlesCoverPageState createState() => _HandlesCoverPageState();
}

class _HandlesCoverPageState extends State<HandlesCoverPage> {

  PickedFile? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch,child) {

        final _handlesProvider = watch(handlesProvider);

        _imgFromCamera() async {
          PickedFile? image = await ImagePicker().getImage(
            source: ImageSource.camera, imageQuality: 50
          );
          setState(() {
            _profileImage = image;
            _handlesProvider.updateHandleCover(image!.path, widget.handlesName, widget.handlesID);
          });
        }

        _imgFromGallery() async {
          PickedFile? image = await ImagePicker().getImage(
              source: ImageSource.gallery, imageQuality: 50
          );
          setState(() {
            _profileImage = image;
            _handlesProvider.updateHandleCover(image!.path, widget.handlesName, widget.handlesID);
          });
        }

        void _showPicker(context) {
          Platform.isAndroid
          ? showModalBottomSheet(
              context: context,
              builder: (BuildContext bc) {
                return SafeArea(
                  child: Container(
                    child: new Wrap(
                      children: <Widget>[
                        new ListTile(
                          leading: new Icon(Icons.photo_library),
                          title: new Text('Photo Library'),
                          onTap: () {
                            _imgFromGallery();
                            Navigator.of(context).pop();
                          }),
                        new ListTile(
                          leading: new Icon(Icons.photo_camera),
                          title: new Text('Camera'),
                          onTap: () {
                            _imgFromCamera();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            )
          : showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    child: const Text('Pick from Camera'),
                    onPressed: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Pick from Gallery'),
                    onPressed: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          }

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
            title: Font.out(
              widget.handlesName,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
              color: Colors.white
            ),
            actions: [
              IconButton(
                icon: AdaptiveIcon(
                  android: Icons.edit,
                  iOS: CupertinoIcons.pencil,
                ),
                onPressed: (){
                  _showPicker(context);
                }
              ),
            ]
          ),
          body: Hero(
            tag: "handles_picture",
            child: PinchZoom(
              image: Image(
                image: _profileImage != null
                ? FileImage(File(_profileImage!.path)) as ImageProvider 
                : NetworkImage(widget.handlesCoverURL),
              ),
              zoomedBackgroundColor: Colors.black,
              resetDuration: const Duration(milliseconds: 100),
              maxScale: 1,
              onZoomStart: (){print('Start zooming');},
              onZoomEnd: (){print('Stop zooming');},
            ),
          )
        );
      },
    );
  }
}