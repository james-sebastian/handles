part of "../pages.dart";

class ProjectDetailedPage extends StatefulWidget {

  final ServiceModel serviceModel;
  final String senderUID;

  const ProjectDetailedPage({
    Key? key,
    required this.serviceModel,
    required this.senderUID
  }) : super(key: key);

  @override
  _ProjectDetailedPageState createState() => _ProjectDetailedPageState();
}

class _ProjectDetailedPageState extends State<ProjectDetailedPage> {
  @override
  Widget build(BuildContext context) {

    int calculateTotalFee(){
      int output = 0;
      widget.serviceModel.milestones!.forEach((element) {
        output += (element.fee ?? 0);
      });
      return output;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.primary,
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
        title: Text(
          "Project Details",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white
          )
        ),
        actions: [
          //TODO: IF CURRENT UID == SENDER UID DISPLAY EDIT ICON
          // IconButton(
          //   tooltip: "Settings",
          //   icon: AdaptiveIcon(
          //     android: Icons.more_vert_rounded,
          //     iOS: CupertinoIcons.ellipsis,
          //   ),
          //   onPressed: (){}
          // ),
        ]
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MQuery.height(1.2, context),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    width: MQuery.height(1, context),
                    color: Palette.handlesBackground,
                    child: //TODO: GET SERVICE PHOTO =X DISPLAY SAMPLE
                    AdaptiveIcon(
                      android: Icons.shopping_cart,
                      iOS: CupertinoIcons.cart_fill,
                      color: Palette.primary,
                      size: 32
                    )
                  ),
                ),
                Expanded(
                  flex: 16,
                  child: Container(
                    height: MQuery.height(0.3, context),
                    width: MQuery.height(1, context),
                    color: Colors.white,
                    padding: EdgeInsets.all(
                      MQuery.height(0.02, context)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.serviceModel.serviceName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          )
                        ),
                        SizedBox(height: MQuery.height(0.015, context)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                widget.serviceModel.paymentStatus == ProjectPaymentStatus.paid
                                ? GeneralStatusTag(
                                    status: "PAID",
                                    color: Palette.secondary
                                  )
                                : widget.serviceModel.paymentStatus == ProjectPaymentStatus.unpaid
                                ? GeneralStatusTag(
                                    status: "UNPAID",
                                    color: Palette.primary
                                  )
                                : SizedBox(),
                                SizedBox(width: MQuery.width(0.01, context)),
                                widget.serviceModel.status == ProjectStatus.pending
                                ? GeneralStatusTag(
                                    status: "PENDING",
                                    color: Colors.grey[800]!
                                  )
                                : widget.serviceModel.status == ProjectStatus.in_progress
                                ? GeneralStatusTag(
                                    status: "IN PROGRESS",
                                    color: Palette.tertiary
                                  )
                                : widget.serviceModel.status == ProjectStatus.completed
                                ? GeneralStatusTag(
                                    status: "COMPLETED",
                                    color: Palette.secondary
                                  )
                                : GeneralStatusTag(
                                    status: "CANCELLED",
                                    color: Palette.warning
                                  ),
                              ],
                            ),
                            Text(
                              NumberFormat.simpleCurrency(locale: 'en_AU').format(calculateTotalFee()),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: MQuery.height(0.015, context)),
                        Divider(),
                        SizedBox(height: MQuery.height(0.015, context)),
                        Container(
                          height: MQuery.height(0.15, context),
                          child: SingleChildScrollView(
                            child: Text(
                              widget.serviceModel.description,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              )
                            ),
                          ),
                        ),
                        SizedBox(height: MQuery.height(0.0075, context)),
                        Divider(),
                        SizedBox(height: MQuery.height(0.005, context)),
                        Text(
                          "Milestones",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )
                        ),
                        SizedBox(height: MQuery.height(0.01, context)),
                        Container(
                          height: MQuery.height(0.45, context),
                          child: ListView.builder(
                            itemCount: widget.serviceModel.milestones!.length,
                            itemBuilder: (context, index){

                              var target =  widget.serviceModel.milestones![index];

                              return Container(
                                height: MQuery.height(0.2, context),
                                child: TimelineTile(
                                  beforeLineStyle: LineStyle(
                                    color: widget.serviceModel.milestones![index].isCompleted ? Palette.secondary : Palette.tertiary
                                  ),
                                  afterLineStyle: LineStyle(
                                    color: index == widget.serviceModel.milestones!.length - 1
                                    ? widget.serviceModel.milestones!.last.isCompleted 
                                      ? Palette.secondary
                                      : Palette.tertiary
                                    : widget.serviceModel.milestones![index + 1].isCompleted ? Palette.secondary : Palette.tertiary
                                  ),
                                  indicatorStyle: IndicatorStyle(
                                    height: 15,
                                    width: 15,
                                    color: widget.serviceModel.milestones![index].isCompleted ? Palette.secondary : Palette.tertiary
                                  ),
                                  axis: TimelineAxis.vertical,
                                  alignment: TimelineAlign.start,
                                  endChild: GestureDetector(
                                    onTap: (){
                                      Get.dialog(
                                        Dialog(
                                          child: MilestoneDialog(
                                            fee: target.fee,
                                            milestoneName: target.milestoneName,
                                            description: target.description,
                                            paymentStatus: target.paymentStatus,
                                            isCompleted: target.isCompleted,
                                            status: target.status,
                                            dueDate: target.dueDate
                                          )
                                        )
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                        MQuery.width(0.02, context),
                                        MQuery.width(0.02, context),
                                        0,
                                        MQuery.width(0.02, context)
                                      ),
                                      padding: EdgeInsets.all(
                                        MQuery.height(0.0125, context)
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Palette.handlesChat
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    target.milestoneName.length >= 23
                                                      ? target.milestoneName.substring(0, 20) + "..."
                                                      : target.milestoneName,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Palette.primaryText,
                                                      fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                  Text(
                                                    NumberFormat.simpleCurrency(locale: 'en_AU').format(target.fee),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Palette.primaryText,
                                                      fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: MQuery.height(0.01, context)),
                                              Text(
                                                target.description.length >= 107
                                                ? target.description.substring(0, 107) + " .."
                                                : target.description,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Palette.primaryText,
                                                  fontWeight: FontWeight.w300
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                target.dueDate != null
                                                ? "Due: ${DateFormat.yMMMMd('en_US').format(target.dueDate!)}"
                                                : "No due date",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Palette.primaryText,
                                                  fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  target.paymentStatus == ProjectPaymentStatus.paid
                                                  ? GeneralStatusTag(
                                                      mini: true,
                                                      status: "PAID",
                                                      color: Palette.secondary
                                                    )
                                                  : target.paymentStatus == ProjectPaymentStatus.unpaid
                                                  ? GeneralStatusTag(
                                                      mini: true,
                                                      status: "UNPAID",
                                                      color: Palette.primary
                                                    )
                                                  : SizedBox(),
                                                  SizedBox(width: MQuery.width(0.005, context)),
                                                  target.status == ProjectStatus.pending
                                                  ? GeneralStatusTag(
                                                      mini: true,
                                                      status: "PENDING",
                                                      color: Colors.grey[800]!
                                                    )
                                                  : target.status == ProjectStatus.in_progress
                                                  ? GeneralStatusTag(
                                                      mini: true,
                                                      status: "IN PROGRESS",
                                                      color: Palette.tertiary
                                                    )
                                                  : target.status == ProjectStatus.completed
                                                  ? GeneralStatusTag(
                                                      mini: true,
                                                      status: "COMPLETED",
                                                      color: Palette.secondary
                                                    )
                                                  : GeneralStatusTag(
                                                      mini: true,
                                                      status: "CANCELLED",
                                                      color: Palette.warning
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                ),
                              );
                            }
                          )
                        ),
                        SizedBox(height: MQuery.height(0.02, context)),
                        widget.serviceModel.paymentStatus == ProjectPaymentStatus.paid
                        ? Button(
                            width: double.infinity - MQuery.width(0.075, context),
                            color: Palette.secondary,
                            method: (){},
                            textColor: Colors.white,
                            title: "SERVICE HAS BEEN PAID",
                          )
                        : widget.serviceModel.paymentStatus == ProjectPaymentStatus.unpaid
                        ? Button(
                            width: double.infinity,
                            color: Palette.secondary,
                            method: (){},
                            textColor: Colors.white,
                            title: "PAY SERVICE",
                          )
                        : Button(
                            width: double.infinity - MQuery.width(0.075, context),
                            color: Palette.warning,
                            method: (){},
                            textColor: Colors.white,
                            title: "SERVICE HAS BEEN CANCELLED",
                          ),
                      ]
                    )
                  ),
                )
              ],
            )
          ),
        )
      )
    );
  }
}