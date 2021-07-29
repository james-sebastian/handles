part of "../pages.dart";

class CallPage extends ConsumerWidget {

  final AgoraClient client;
  final String handlesID;
  final String userID;
  CallPage({ Key? key, required this.client, required this.handlesID, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch){

    final _userProvider = watch(userProvider);
    final _callProvider = watch(callProvider);

    client.sessionController.toggleCamera();

    final _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
    );

    WidgetsBinding.instance!.addPostFrameCallback((_){
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    });

    Future<List<UserModel>> participantNamesGetter() async {
      List<UserModel> out = [];

      watch(callChannelProvider(handlesID)).whenData((value){
        value.intendedParticipants.forEach((element) {
          _userProvider.getUserByID(element).then((value){
            out.add(value);
          });
        });
      });
      return out;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.primary,
        leadingWidth: MQuery.width(0.05, context),
        title: FutureBuilder<List<UserModel>>(
          future: participantNamesGetter(),
          builder: (context, snapshot) {

            List<String> names = [];
            if(snapshot.hasData){
              snapshot.data!.forEach((element) {
                names.add(element.name);
              });
            }

            return snapshot.hasData
            ? Text(
                "In call (${names.toString().substring(1, names.toString().length - 1)})",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ),
              )
            : SizedBox();
          }
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
              disabledVideoWidget: Container(
                color: Palette.handlesBackground,
                child: Center(
                  child: Icon(Icons.videocam_off, size: 64)
                )
              ),
              showNumberOfUsers: true,
            ), 
            AgoraVideoButtons(
              client: this.client,
              disconnectButtonChild: watch(callChannelProvider(handlesID)).when(
                data: (channel){

                  print(channel.participants.toString() + " anc");

                  return Container(
                    height: 60,
                    child: FittedBox(
                      child: FloatingActionButton(
                        elevation: 2,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.call_end
                        ),
                        onPressed: (){
                          if(channel.participants.first == this.userID){
                            _callProvider.terminateCallChannel(this.handlesID, DateTime.now());
                          }
                          client.sessionController.endCall();
                          Get.back();
                        },
                      ),
                    ),
                  );
                },
                loading: () => SizedBox(),
                error: (err, obj){
                  print(obj.toString() + " abc");
                }
              )
            ),
          ],
        ),
      ),
    );
  }
}
