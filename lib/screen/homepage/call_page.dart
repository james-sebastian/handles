part of "../pages.dart";

class CallPage extends StatelessWidget {

  final List<String> participants;
  final AgoraClient client;
  CallPage({ Key? key, required this.client, required this.participants}) : super(key: key);

  @override
  Widget build(BuildContext context){

    client.sessionController.toggleCamera();

    final _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
    );

    WidgetsBinding.instance!.addPostFrameCallback((_){
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.primary,
        leadingWidth: MQuery.width(0.05, context),
        title: Text(
          "In call (Jefferson, Maya, ...)",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                initialData: 0,
                builder: (context, snapshot) {
                  final value = snapshot.data;
                  final displayTime = StopWatchTimer.getDisplayTime(value!, hours: false, milliSecond: false);
                  return Text(
                    displayTime,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: this.client,
              layoutType: Layout.floating,
              disabledVideoWidget: SizedBox(),
              showNumberOfUsers: true,
            ), 
            AgoraVideoButtons(
              client: this.client,
              disconnectButtonChild: Container(
                height: 60,
                child: FittedBox(
                  child: FloatingActionButton(
                    elevation: 2,
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.call_end
                    ),
                    onPressed: (){
                      client.sessionController.endCall();
                      Get.back();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
