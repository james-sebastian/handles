part of "../pages.dart";

class ProjectDetailedPage extends StatefulWidget {

  final ProjectModel projectModel;
  final String currentUserID;
  final String handlesID;

  const ProjectDetailedPage({
    Key? key,
    required this.projectModel,
    required this.currentUserID,
    required this.handlesID
  }) : super(key: key);

  @override
  _ProjectDetailedPageState createState() => _ProjectDetailedPageState();
}

class _ProjectDetailedPageState extends State<ProjectDetailedPage> {
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
              widget.currentUserID == widget.projectModel.sender
              ? IconButton(
                  icon: AdaptiveIcon(
                    android: Icons.edit,
                    iOS: CupertinoIcons.pencil,
                  ),
                  onPressed: (){
                    Get.to(() => ProjectCreator(
                      handlesID: widget.handlesID,
                      projectModel: widget.projectModel,
                    ));
                  }
                )
              : SizedBox()
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
                        child: AdaptiveIcon(
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
                              widget.projectModel.serviceName,
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
                                    widget.projectModel.paymentStatus == ProjectPaymentStatus.paid
                                    ? GeneralStatusTag(
                                        status: "PAID",
                                        color: Palette.secondary
                                      )
                                    : widget.projectModel.paymentStatus == ProjectPaymentStatus.unpaid
                                    ? GeneralStatusTag(
                                        status: "UNPAID",
                                        color: Palette.primary
                                      )
                                    : SizedBox(),
                                    SizedBox(width: MQuery.width(0.01, context)),
                                    widget.projectModel.status == ProjectStatus.pending
                                    ? GeneralStatusTag(
                                        status: "PENDING",
                                        color: Colors.grey[800]!
                                      )
                                    : widget.projectModel.status == ProjectStatus.in_progress
                                    ? GeneralStatusTag(
                                        status: "IN PROGRESS",
                                        color: Palette.tertiary
                                      )
                                    : widget.projectModel.status == ProjectStatus.completed
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
                                )
                              ],
                            ),
                            SizedBox(height: MQuery.height(0.015, context)),
                            Divider(),
                            SizedBox(height: MQuery.height(0.013, context)),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: MQuery.height(0.15, context)
                              ),
                              child: Container(
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.projectModel.description,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      height: 1.5,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    )
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: MQuery.height(0.015, context)),
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
                            _projectChatMilestonesProvider.when(
                              data: (milestones){
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: MQuery.height(0.45, context),
                                  ),
                                  child: ListView.builder(
                                    itemCount: milestones.length,
                                    itemBuilder: (context, index){
                                
                                      var target =  milestones[index];
                                
                                      return Container(
                                        height: MQuery.height(0.2, context),
                                        child: TimelineTile(
                                          beforeLineStyle: LineStyle(
                                            color: milestones[index].isCompleted ? Palette.secondary : Palette.tertiary
                                          ),
                                          afterLineStyle: LineStyle(
                                            color: index == milestones.length - 1
                                            ? milestones.last.isCompleted 
                                              ? Palette.secondary
                                              : Palette.tertiary
                                            : milestones[index + 1].isCompleted ? Palette.secondary : Palette.tertiary
                                          ),
                                          indicatorStyle: IndicatorStyle(
                                            height: 15,
                                            width: 15,
                                            color: milestones[index].isCompleted ? Palette.secondary : Palette.tertiary
                                          ),
                                          axis: TimelineAxis.vertical,
                                          alignment: TimelineAlign.start,
                                          endChild: GestureDetector(
                                            onTap: (){
                                              Get.dialog(
                                                Dialog(
                                                  child: MilestoneDialog(
                                                    milestoneID: target.id,
                                                    handlesID: widget.handlesID,
                                                    userID: widget.currentUserID,
                                                    projectID: widget.projectModel.id,
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
                                  ),
                                );
                              },
                              loading: (){
                                return CircularProgressIndicator(color: Palette.primary);
                              },
                              error: (object, error){
                                print(object);
                                return SizedBox();
                              }
                            ),
                            SizedBox(height: MQuery.height(0.01, context)),
                            widget.projectModel.paymentStatus == ProjectPaymentStatus.paid
                            ? Button(
                                width: double.infinity - MQuery.width(0.075, context),
                                color: Palette.secondary,
                                method: (){},
                                textColor: Colors.white,
                                title: "SERVICE HAS BEEN PAID",
                              )
                            : widget.projectModel.paymentStatus == ProjectPaymentStatus.unpaid
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
      },
    );
  }
}