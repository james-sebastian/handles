part of "widgets.dart";

class ProjectChat extends StatefulWidget {

  final int index;
  final DateTime timestamp;
  final String userID;
  final String handlesID;
  final String sender;
  final String senderRole;
  final ProjectModel projectModel;
  final bool isRecurring;
  final bool isPinned;

  const ProjectChat({
    Key? key,
    required this.index,
    required this.timestamp,
    required this.sender,
    required this.senderRole,
    required this.projectModel,
    required this.isRecurring,
    required this.isPinned,
    required this.userID,
    required this.handlesID
  }) : super(key: key);

  @override
  _ProjectChatState createState() => _ProjectChatState();
}

class _ProjectChatState extends State<ProjectChat> {
  @override
  Widget build(BuildContext context) {

    int calculateTotalFee(List<MilestoneModel> milestones){
      int output = 0;
      milestones.forEach((element) {
        output += (element.fee ?? 0);
      });
      return output;
    }

    return Consumer(
      builder: (ctx, watch,child) {

        final _projectChatMilestonesProvider = watch(projectChatMilestonesProvider(widget.projectModel.id));

        _projectChatMilestonesProvider.whenData((value){
          print(value);
        }); 

        return widget.sender == widget.userID
      ? Container(
          width: MQuery.width(1, context),
          margin: EdgeInsets.only(
            bottom: MQuery.width(0.01, context)
          ),
          padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MQuery.width(
                    0.35, context
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.to(() => ProjectDetailedPage(
                            handlesID: widget.handlesID,
                            projectModel: this.widget.projectModel,
                            currentUserID: this.widget.userID
                          ), transition: Transition.cupertino);
                        },
                        child: Row(
                          children: [
                            Container(
                              height: MQuery.height(0.09, context),
                              width: MQuery.height(0.09, context),
                              decoration: BoxDecoration(
                                color: Palette.handlesBackground,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: AdaptiveIcon(
                                android: Icons.shopping_cart,
                                iOS: CupertinoIcons.cart_fill,
                                color: Palette.primary,
                                size: 32
                              )
                            ),
                            Spacer(),
                            Expanded(
                              flex: 15,
                              child: Container(
                                height: MQuery.height(0.09, context),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      widget.projectModel.serviceName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white
                                      )
                                    ),
                                    _projectChatMilestonesProvider.when(
                                      data: (milestones){
                                        return Text(
                                          NumberFormat.simpleCurrency(locale: 'en_AU').format(calculateTotalFee(milestones)),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white
                                          )
                                        );
                                      },
                                      loading: (){
                                        return Text(
                                          NumberFormat.simpleCurrency(locale: 'en_AU').format(0),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white
                                          )
                                        );
                                      },
                                      error: (_, __) => SizedBox()
                                    ),
                                    Text(
                                      widget.projectModel.description.length >= 30
                                      ? widget.projectModel.description.substring(0, 26) + "..."
                                      : widget.projectModel.description,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white
                                      )
                                    )
                                  ],
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: MQuery.height(0.01, context)),
                      widget.projectModel.paymentStatus == ProjectPaymentStatus.paid
                      ? Button(
                          height: MQuery.height(0.045, context),
                          width: double.infinity,
                          color: Palette.secondary,
                          method: (){},
                          textColor: Colors.white,
                          title: "Service Has Been Paid",
                        )
                      : widget.projectModel.paymentStatus == ProjectPaymentStatus.unpaid
                      ? Button(
                          height: MQuery.height(0.045, context),
                          width: double.infinity,
                          color: Palette.secondary,
                          method: (){},
                          textColor: Colors.white,
                          title: "Pay Service",
                        )
                      : Button(
                          height: MQuery.height(0.045, context),
                          width: double.infinity,
                          color: Palette.warning,
                          method: (){},
                          textColor: Colors.white,
                          title: "Service Has Been Cancelled",
                        ),
                      SizedBox(height: MQuery.height(0.01, context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          widget.isPinned
                          ? AdaptiveIcon(
                              android: Icons.push_pin,
                              iOS: CupertinoIcons.pin_fill,
                              size: 12,
                              color: Colors.white.withOpacity(0.5)
                            )
                          : SizedBox(),
                          SizedBox(width: MQuery.width(0.005, context)),
                          Text(
                            DateFormat.jm().format(widget.timestamp),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                              fontSize: 12
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
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
          ))
      : Container(
          width: MQuery.width(1, context),
          margin: EdgeInsets.only(
            bottom: MQuery.width(0.01, context)),
          padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
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
                    0.35, context
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.isRecurring && widget.isPinned != true
                          ? SizedBox()
                          : RichText(
                              text: TextSpan(
                                text: "${this.widget.sender} ",
                                style: TextStyle(
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
                          : SizedBox()
                        ],
                      ),
                      SizedBox(height: MQuery.height(0.005, context)),
                      GestureDetector(
                        onTap: (){
                          Get.to(() => ProjectDetailedPage(
                            handlesID: widget.handlesID,
                            projectModel: this.widget.projectModel,
                            currentUserID: this.widget.userID
                          ), transition: Transition.cupertino);
                        },
                        child: Row(
                          children: [
                            Container(
                              height: MQuery.height(0.09, context),
                              width: MQuery.height(0.09, context),
                              decoration: BoxDecoration(
                                color: Palette.handlesBackground,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: AdaptiveIcon(
                                android: Icons.shopping_cart,
                                iOS: CupertinoIcons.cart_fill,
                                color: Palette.primary,
                                size: 32
                              )
                            ),
                            Spacer(),
                            Expanded(
                              flex: 15,
                              child: Container(
                                height: MQuery.height(0.09, context),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      widget.projectModel.serviceName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                      )
                                    ),
                                    _projectChatMilestonesProvider.when(
                                      data: (milestones){
                                        return Text(
                                          NumberFormat.simpleCurrency(locale: 'en_AU').format(calculateTotalFee(milestones)),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          )
                                        );
                                      },
                                      loading: (){
                                        return Text(
                                          NumberFormat.simpleCurrency(locale: 'en_AU').format(0),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          )
                                        );
                                      },
                                      error: (_, __) => SizedBox()
                                    ),
                                    Text(
                                      widget.projectModel.description.length >= 30
                                      ? widget.projectModel.description.substring(0, 26) + "..."
                                      : widget.projectModel.description,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400
                                      )
                                    )
                                  ],
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: MQuery.height(0.01, context)),
                      widget.projectModel.paymentStatus == ProjectPaymentStatus.paid
                      ? Button(
                          height: MQuery.height(0.045, context),
                          width: double.infinity,
                          color: Palette.secondary,
                          method: (){},
                          textColor: Colors.white,
                          title: "SERVICE HAS BEEN PAID",
                        )
                      : widget.projectModel.paymentStatus == ProjectPaymentStatus.unpaid
                      ? Button(
                          height: MQuery.height(0.045, context),
                          width: double.infinity,
                          color: Palette.secondary,
                          method: (){},
                          textColor: Colors.white,
                          title: "PAY SERVICE",
                        )
                      : Button(
                          height: MQuery.height(0.045, context),
                          width: double.infinity,
                          color: Palette.warning,
                          method: (){},
                          textColor: Colors.white,
                          title: "SERVICE HAS BEEN CANCELLED",
                        ),
                      SizedBox(height: MQuery.height(0.01, context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                    ],
                  ),
                ),
              )
            ],
          )
        );
      },
    );
  }
}