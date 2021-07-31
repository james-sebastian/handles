part of "../pages.dart";

class CallPage extends StatefulWidget {
  final AgoraClient client;
  final String handlesID;
  final String userID;
  final bool isJoining;
  final bool isLoading;
  CallPage({ Key? key, required this.client, required this.handlesID, required this.userID, required this.isLoading, required this.isJoining}) : super(key: key);
  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {  
  @override
  Widget build(BuildContext context){
    return Consumer(
      builder: (context, watch, child) {

        final _userProvider = watch(userProvider);
        final _callProvider = watch(callProvider);
        final _stopWatchTimer = StopWatchTimer(
          mode: StopWatchMode.countUp,
        );

        WidgetsBinding.instance!.addPostFrameCallback((_){
          if(widget.isLoading == false){
            _stopWatchTimer.onExecute.add(StopWatchExecute.start);
          }
        });

        Future<List<UserModel>> participantNamesGetter() async {
          List<UserModel> out = [];
          watch(callChannelProvider(widget.handlesID)).whenData((value){
            value.intendedParticipants.forEach((element) {
              _userProvider.getUserByID(element).then((value){
                out.add(value);
              });
            });
          });
          return out;
        }

        Future.delayed(1.seconds, (){
          if(widget.isLoading){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return CallPage(
                client: AgoraClient(
                  agoraConnectionData: AgoraConnectionData(
                    appId: "33a7608a9e714097bb913a6e7e6ba3a2",
                    channelName: widget.handlesID
                  ),
                  enabledPermission: [
                    Permission.camera,
                    Permission.microphone,
                  ],
                ),
                handlesID: widget.handlesID,
                userID: widget.userID,
                isJoining: true,
                isLoading: false
              );
            }));
          }
        });

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Palette.primary,
            leadingWidth: MQuery.width(0, context),
            leading: SizedBox(),
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
                  showAVState: true,
                  client: this.widget.client,
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
                  client: this.widget.client,
                  disconnectButtonChild: watch(callChannelProvider(widget.handlesID)).when(
                    data: (channel){
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
                              if(channel.participants.first == this.widget.userID){
                                _callProvider.terminateCallChannel(this.widget.handlesID, DateTime.now());
                              }
                              widget.client.sessionController.endCall();
                              Get.off(() => HandlesPage(handlesID: widget.handlesID));
                            },
                          ),
                        ),
                      );
                    },
                    loading: () => SizedBox(),
                    error: (err, obj){}
                  )
                ),
                widget.isLoading
                ? Positioned.fill(
                    child: Container(
                      color: Palette.handlesBackground
                    )
                  )
                : SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }
}
