part of "widgets.dart";

class AudioChat extends StatefulWidget {
  final int index;
  final DateTime timestamp;
  final String sender;
  final String senderRole;
  final String audioURL;
  final bool isRecurring;
  final bool isPinned;
  final Set<int> selectedChats;
  final void Function(int) chatOnTap;
  final void Function(int) selectChatMethod;

  const AudioChat({
    Key? key,
    required this.index,
    required this.timestamp,
    required this.sender,
    required this.senderRole,
    required this.audioURL,
    required this.isRecurring,
    required this.isPinned,
    required this.selectChatMethod,
    required this.chatOnTap,
    required this.selectedChats
  }) : super(key: key);

  @override
  _AudioChatState createState() => _AudioChatState();
}

class _AudioChatState extends State<AudioChat> {

  late final AudioChatProvider _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = AudioChatProvider();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.sender == "a" //TODO: CHECK IF SENDER == USER ID
      ? Container(
          width: MQuery.width(1, context),
          margin: EdgeInsets.only(
            bottom: MQuery.width(0.01, context)
          ),
          padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
          color: widget.selectedChats.toList().indexOf(widget.index) >= 0
          ? Palette.primary.withOpacity(0.25)
          : Colors.transparent, 
          child: InkWell(
            onTap: (){
              widget.chatOnTap(widget.index);
            },
            onLongPress: (){
              widget.selectChatMethod(widget.index);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MQuery.width(
                      this.widget.audioURL.length >= 30
                      ? 0.35
                      : this.widget.audioURL.length <= 12
                        ? 0.15
                        : this.widget.audioURL.length * 0.009
                      , context
                    ),
                    minWidth: MQuery.width(0.1, context),
                    minHeight: MQuery.height(0.045, context)
                  ),
                  child: Container(
                    padding: EdgeInsets.all(MQuery.height(0.01, context)),
                    decoration: BoxDecoration(
                      color: Palette.primary,
                      borderRadius: BorderRadius.only(
                        topRight: widget.isRecurring ? Radius.circular(7) : Radius.circular(0),
                        topLeft: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                        bottomLeft: Radius.circular(7)
                      )
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ValueListenableBuilder<ProgressBarState>(
                              valueListenable: _pageManager.progressNotifier,
                              builder: (_, value, __) {
                                return Text(
                                  value.total.toString().substring(3, 7),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: MQuery.width(0.105, context)),
                            Row(
                              children: [
                                widget.isPinned
                                ? AdaptiveIcon(
                                    android: Icons.push_pin,
                                    iOS: CupertinoIcons.pin_fill,
                                    size: 12,
                                    color: Palette.handlesBackground
                                  )
                                : SizedBox(),
                                SizedBox(width: MQuery.width(0.01, context)),
                                Text(
                                  DateFormat.jm().format(widget.timestamp),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(height: MQuery.height(0.005, context)),
                            Row(
                              children: [
                                SizedBox(width: MQuery.width(0.003, context)),
                                CircleAvatar(
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                  radius: MQuery.height(0.023, context),
                                ),
                                ValueListenableBuilder<ButtonState>(
                                  valueListenable: _pageManager.buttonNotifier,
                                  builder: (_, value, __) {
                                    switch (value) {
                                      case ButtonState.loading:
                                        return Container(
                                          margin: EdgeInsets.all(8.0),
                                          width: 18.0,
                                          height: 18.0,
                                          child: CircularProgressIndicator(),
                                        );
                                      case ButtonState.paused:
                                        return IconButton(
                                          icon: AdaptiveIcon(
                                            android: Icons.play_arrow_rounded,
                                            iOS: CupertinoIcons.play_arrow_solid,
                                            size: 28,
                                            color: Colors.white
                                          ),
                                          iconSize: 32.0,
                                          onPressed: _pageManager.play,
                                        );
                                      case ButtonState.playing:
                                        return IconButton(
                                          icon: AdaptiveIcon(
                                            android: Icons.pause_rounded,
                                            iOS: CupertinoIcons.pause_solid,
                                            size: 32,
                                            color: Colors.white
                                          ),
                                          iconSize: 32.0,
                                          onPressed: _pageManager.pause,
                                        );
                                    }
                                  },
                                ),
                                Container(
                                  width: MQuery.width(0.225, context),
                                  child: ValueListenableBuilder<ProgressBarState>(
                                    valueListenable: _pageManager.progressNotifier,
                                    builder: (_, value, __) {
                                      return ProgressBar(
                                        progress: value.current,
                                        buffered: value.buffered,
                                        total: value.total,
                                        thumbColor: Palette.secondary,
                                        baseBarColor: Palette.handlesBackground,
                                        timeLabelLocation: TimeLabelLocation.none,
                                        onSeek: _pageManager.seek,
                                        thumbRadius: 8.0,
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: MQuery.height(0.0075, context))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: SvgPicture.asset(
                    "assets/tool_tip.svg",
                    height: MQuery.height(0.02, context),
                    width: MQuery.height(0.02, context),
                    color: this.widget.isRecurring ? Palette.handlesBackground : Palette.primary
                  ),
                ),
              ],
            ),
          )
        )
      : Container(
          width: MQuery.width(1, context),
          color: widget.selectedChats.toList().indexOf(widget.index) >= 0
          ? Palette.primary.withOpacity(0.25)
          : Colors.transparent, 
          margin: EdgeInsets.only(bottom: MQuery.width(0.01, context)),
          padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
          child: InkWell(
            onTap: (){
              widget.chatOnTap(widget.index);
            },
            onLongPress: (){
              widget.selectChatMethod(widget.index);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/tool_tip.svg",
                  height: MQuery.height(0.02, context),
                  width: MQuery.height(0.02, context),
                  color: this.widget.isRecurring ? Palette.handlesBackground : Colors.white
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MQuery.width(
                      this.widget.audioURL.length >= 30
                      ? 0.35
                      : this.widget.audioURL.length <= 12
                        ? 0.15
                        : this.widget.audioURL.length * 0.009
                      , context
                    ),
                    minWidth: MQuery.width(0.14, context),
                    minHeight: MQuery.height(0.045, context)
                  ),
                  child: Container(
                    padding: EdgeInsets.all(MQuery.height(0.01, context)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: widget.isRecurring ? Radius.circular(7) : Radius.circular(0),
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                        bottomLeft: Radius.circular(7)
                      )
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ValueListenableBuilder<ProgressBarState>(
                              valueListenable: _pageManager.progressNotifier,
                              builder: (_, value, __) {
                                return Text(
                                  value.total.toString().substring(3, 7),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: MQuery.width(0.135, context)),
                            Text(
                              DateFormat.jm().format(widget.timestamp),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 12
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.isRecurring && widget.isPinned == false
                                ? SizedBox()
                                : RichText(
                                    text: TextSpan(
                                      text: "${this.widget.sender} ",
                                      style: TextStyle(
                                        //TODO: DYNAMIC COLOR CREATION
                                        color: Palette.primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "(${this.widget.senderRole})",
                                          style: TextStyle(
                                            color: Palette.primary,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                widget.isPinned
                                ? AdaptiveIcon(
                                    android: Icons.push_pin,
                                    iOS: CupertinoIcons.pin_fill,
                                    size: 12
                                  )
                                : SizedBox(),
                              ],
                            ),
                            SizedBox(height: MQuery.height(0.005, context)),
                            Row(
                              children: [
                                SizedBox(width: MQuery.width(0.003, context)),
                                CircleAvatar(
                                  backgroundColor: Palette.primary,
                                  radius: MQuery.height(0.023, context),
                                ),
                                ValueListenableBuilder<ButtonState>(
                                  valueListenable: _pageManager.buttonNotifier,
                                  builder: (_, value, __) {
                                    switch (value) {
                                      case ButtonState.loading:
                                        return Container(
                                          margin: EdgeInsets.all(8.0),
                                          width: 18.0,
                                          height: 18.0,
                                          child: CircularProgressIndicator(),
                                        );
                                      case ButtonState.paused:
                                        return IconButton(
                                          icon: AdaptiveIcon(
                                            android: Icons.play_arrow_rounded,
                                            iOS: CupertinoIcons.play_arrow_solid,
                                            size: 28,
                                          ),
                                          iconSize: 32.0,
                                          onPressed: _pageManager.play,
                                        );
                                      case ButtonState.playing:
                                        return IconButton(
                                          icon: AdaptiveIcon(
                                            android: Icons.pause_rounded,
                                            iOS: CupertinoIcons.pause_solid,
                                            size: 32,
                                          ),
                                          iconSize: 32.0,
                                          onPressed: _pageManager.pause,
                                        );
                                    }
                                  },
                                ),
                                Container(
                                  width: MQuery.width(0.225, context),
                                  child: ValueListenableBuilder<ProgressBarState>(
                                    valueListenable: _pageManager.progressNotifier,
                                    builder: (_, value, __) {
                                      return ProgressBar(
                                        progress: value.current,
                                        buffered: value.buffered,
                                        total: value.total,
                                        timeLabelLocation: TimeLabelLocation.none,
                                        onSeek: _pageManager.seek,
                                        thumbRadius: 8.0,
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: MQuery.height(0.0075, context))
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        );
  }
}