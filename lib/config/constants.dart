part of "config.dart";

class Constants{
  static List<String> filterList = [
    "Photos", "Videos",
    "Docs", "Meetings", "Services"
  ];

  static Map<String, Widget> filterAvatar = {
    "Photos": AdaptiveIcon(
      android: Icons.image,
      iOS: CupertinoIcons.photo_fill,
      color: Colors.white, size: 20
    ),
    "Videos": AdaptiveIcon(
      android: Icons.videocam,
      iOS: CupertinoIcons.video_camera_solid,
      color: Colors.white, size: 20
    ),
    "Docs": SvgPicture.asset("assets/mdi_file-document.svg", height: 18, width: 18),
    "Meetings": SvgPicture.asset("assets/mdi_presentation-play.svg", height: 18, width: 18),
    "Services": AdaptiveIcon(
      android: Icons.shopping_cart,
      iOS: CupertinoIcons.cart_fill,
      color: Colors.white, size: 18
    )
  };

  static Map<String, Widget> mediaAvatar = {
    "Photos": AdaptiveIcon(
      android: Icons.image,
      iOS: CupertinoIcons.photo_fill,
      color: Colors.white, size: 30
    ),
    "Videos": AdaptiveIcon(
      android: Icons.videocam,
      iOS: CupertinoIcons.video_camera_solid,
      color: Colors.white, size: 30
    ),
    "Docs": SvgPicture.asset("assets/mdi_file-document.svg", height: 28, width: 28),
    "Meetings": SvgPicture.asset("assets/mdi_presentation-play.svg", height: 28, width: 28),
    "Services": AdaptiveIcon(
      android: Icons.shopping_cart,
      iOS: CupertinoIcons.cart_fill,
      color: Colors.white, size: 28
    ),
    "Audio": AdaptiveIcon(
      android: Icons.mic,
      iOS: CupertinoIcons.mic_fill,
      color: Colors.white, size: 28,
    ),
  };
  
}