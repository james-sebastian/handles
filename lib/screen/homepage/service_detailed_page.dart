part of "../pages.dart";

class ServiceDetailedPage extends StatefulWidget {

  final ServiceModel serviceModel;
  final String senderUID;

  const ServiceDetailedPage({
    Key? key,
    required this.serviceModel,
    required this.senderUID
  }) : super(key: key);

  @override
  _ServiceDetailedPageState createState() => _ServiceDetailedPageState();
}

class _ServiceDetailedPageState extends State<ServiceDetailedPage> {
  @override
  Widget build(BuildContext context) {
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
          "Service Details",
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
            height: MQuery.height(1, context),
            child: Column(
              children: [
                Expanded(
                  flex: 5,
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
                            widget.serviceModel.status == ServiceStatus.paid
                            ? GeneralStatusTag(
                                status: "PAID",
                                color: Palette.secondary
                              )
                            : widget.serviceModel.status == ServiceStatus.unpaid
                            ? GeneralStatusTag(
                                status: "UNPAID",
                                color: Palette.primary
                              )
                            : GeneralStatusTag(
                                status: "CANCELLED",
                                color: Palette.warning
                              ),
                            Text(
                              NumberFormat.simpleCurrency(locale: 'en_AU').format(widget.serviceModel.serviceFee),
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
                        Text(
                          widget.serviceModel.description,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          )
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
                          height: MQuery.height(0.315, context),
                          child: ListView.builder(
                            itemCount: widget.serviceModel.milestones!.length,
                            itemBuilder: (context, index){
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
                                  endChild: Container(
                                    margin: EdgeInsets.fromLTRB(
                                      MQuery.width(0.02, context),
                                      MQuery.width(0.02, context),
                                      0,
                                      MQuery.width(0.02, context)
                                    ),
                                    padding: EdgeInsets.all(
                                      MQuery.height(0.015, context)
                                    ),
                                    decoration: BoxDecoration(
                                      color: Palette.handlesChat,
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.serviceModel.milestones![index].milestoneName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        SizedBox(height: MQuery.height(0.005, context)),
                                        Text(
                                          widget.serviceModel.milestones![index].description.length >= 145
                                          ? widget.serviceModel.milestones![index].description.substring(0, 145) + " .."
                                          : widget.serviceModel.milestones![index].description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400
                                          ),
                                        )
                                      ],
                                    )
                                  ),
                                ),
                              );
                            }
                          )
                        ),
                        SizedBox(height: MQuery.height(0.02, context)),
                        widget.serviceModel.status == ServiceStatus.paid
                        ? Button(
                            width: double.infinity - MQuery.width(0.075, context),
                            color: Palette.secondary,
                            method: (){},
                            textColor: Colors.white,
                            title: "SERVICE HAS BEEN PAID",
                          )
                        : widget.serviceModel.status == ServiceStatus.unpaid
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