part of '../pages.dart';

class EmptyHandles extends StatelessWidget {

  final bool isHandlesPage;

  const EmptyHandles({ Key? key, required this.isHandlesPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isHandlesPage
    ? Container(
        margin: EdgeInsets.only(
          top: MQuery.height(0.325, context)
        ),
        child: Column(
          children: [
            Font.out(
              "No Handles",
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Palette.primaryText
            ),
            Font.out(
              "Go be a Premium user to create new one",
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Palette.primaryText
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Font.out(
                  "by tapping",
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Palette.primaryText
                ),
                SizedBox(width: MQuery.width(0.01, context)),
                CircleAvatar(
                  radius: 12.5,
                  backgroundColor: Palette.secondary,
                  child: AdaptiveIcon(
                    android: Icons.add,
                    iOS: CupertinoIcons.add,
                    color: Colors.white, size: 17.5,
                  ),
                ),
                SizedBox(width: MQuery.width(0.01, context)),
                Font.out(
                  "or ask your colleague to",
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Palette.primaryText
                ),
              ]
            ),
            Font.out(
              "invite you to your team’s Handles.",
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Palette.primaryText
            ),
          ]
        )
      )
    : Container(
        margin: EdgeInsets.only(
          top: MQuery.height(0.325, context)
        ),
        child: Column(
          children: [
            Font.out(
              "No group call",
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Palette.primaryText
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Font.out(
                  "Go to your team’s Handles and tap ",
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Palette.primaryText
                ),
                SizedBox(width: MQuery.width(0.005, context)),
                AdaptiveIcon(
                  android: Icons.call,
                  iOS: CupertinoIcons.phone_fill,
                  size: 18,
                  color: Palette.primary,
                ),
              ]
            ),
            Font.out(
              "to make a group call",
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Palette.primaryText
            ),
          ]
        )
      );
  }
}