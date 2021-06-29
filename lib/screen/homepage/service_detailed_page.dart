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
          "Meeting Details",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16,
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
            height: MQuery.height(0.93, context),
            child: Stack(
              children: [
                Column(
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
                            Container(
                              height: MQuery.height(0.25, context),
                              child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, index){
                                  return SizedBox();
                                },
                              ),
                            ),
                          ]
                        )
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      MQuery.height(0.0375, context),
                      MQuery.height(0, context),
                      MQuery.height(0.0375, context),
                      MQuery.height(0.075, context),
                    ),
                    child: widget.serviceModel.status == ServiceStatus.paid
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