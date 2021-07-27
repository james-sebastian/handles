part of "../pages.dart";

class CallPage extends StatelessWidget {
  CallPage({ Key? key }) : super(key: key);

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "33a7608a9e714097bb913a6e7e6ba3a2",
      channelName: Uuid().v4(),
    ),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
  );

  @override
  Widget build(BuildContext context) {

    print(client.users);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              disabledVideoWidget: SizedBox(),
            ), 
            AgoraVideoButtons(client: client),
          ],
        ),
      ),
    );
  }
}
