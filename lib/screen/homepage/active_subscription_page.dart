part of "../pages.dart";

class ActiveSubscriptionPage extends StatefulWidget {
  const ActiveSubscriptionPage({ Key? key }) : super(key: key);

  @override
  _ActiveSubscriptionPageState createState() => _ActiveSubscriptionPageState();
}

class _ActiveSubscriptionPageState extends State<ActiveSubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MQuery.height(0.07, context),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: AdaptiveIcon(
            android: Icons.arrow_back,
            iOS: CupertinoIcons.back,
            color: Colors.black
          ),
          onPressed: (){
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MQuery.height(0.85, context),
          width: MQuery.width(1, context),
          padding: EdgeInsets.symmetric(
            vertical: MQuery.height(0.015, context)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: MQuery.height(0.01, context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/handles_logo.png",
                        height: MQuery.height(0.1, context)
                      ),
                      SizedBox(width: MQuery.width(0.02, context)),
                      FadeInLeft(
                        from: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Handles",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Palette.secondaryText
                              )
                            ),
                            SizedBox(height: MQuery.height(0.005, context)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: MQuery.height(0.01, context),
                                vertical: MQuery.height(0.005, context)
                              ),
                              decoration: BoxDecoration(
                                color: Palette.tertiary,
                                borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: Center(
                                child: Text(
                                  "PRO",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700
                                  )
                                ),
                              )
                            ),
                          ]
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: MQuery.height(0.035, context)),
                  Divider(height: 0),
                  Container(
                    padding: EdgeInsets.all(MQuery.height(0.02, context)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Premium",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Palette.secondaryText
                                  )
                                ),
                                SizedBox(width: MQuery.width(0.01, context)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MQuery.height(0.01, context),
                                    vertical: MQuery.height(0.0075, context)
                                  ),
                                  decoration: BoxDecoration(
                                    color: Palette.tertiary,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: Center(
                                    child: Text(
                                      "PRO",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700
                                      )
                                    ),
                                  )
                                ),
                                SizedBox(width: MQuery.width(0.01, context)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MQuery.height(0.01, context),
                                    vertical: MQuery.height(0.0075, context)
                                  ),
                                  decoration: BoxDecoration(
                                    color: Palette.primary,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: Center(
                                    child: Text(
                                      "BEST",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500
                                      )
                                    ),
                                  )
                                ),
                              ],
                            ),
                            Text(
                              //TODO: INTL LOCAL CURRENCY HERE
                              "\$19.99/mo",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Palette.secondaryText
                              )
                            ),
                          ]
                        ),
                        SizedBox(height: MQuery.height(0.025, context)),
                        Text(
                          "Your Handles PRO next charge will be on:",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Palette.secondaryText
                          )
                        ),
                        SizedBox(height: MQuery.height(0.015, context)),
                        Text(
                          "July 31st, 2021",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Palette.primaryText
                          )
                        ),
                      ],
                    )
                  ),
                  Divider(height: 0),
                  Container(
                    padding: EdgeInsets.all(
                      MQuery.height(0.02, context)
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            AdaptiveIcon(
                              android: Icons.check_circle_outline_rounded,
                              iOS: CupertinoIcons.checkmark_alt_circle,
                              color: HexColor("00BFA5")
                            ),
                            SizedBox(width: MQuery.width(0.02, context)),
                            Text(
                              "Unlimited Handles creation",
                              style: TextStyle(
                                color: HexColor("00BFA5"),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                              )
                            ),
                          ]
                        ),
                        SizedBox(height: MQuery.height(0.015, context)),
                        Row(
                          children: [
                            AdaptiveIcon(
                              android: Icons.check_circle_outline_rounded,
                              iOS: CupertinoIcons.checkmark_alt_circle,
                              color: HexColor("00BFA5")
                            ),
                            SizedBox(width: MQuery.width(0.02, context)),
                            Text(
                              "Add company informations on your profile",
                              style: TextStyle(
                                color: HexColor("00BFA5"),
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                              )
                            ),
                          ]
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Got any question? Contact us!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.25,
                      color: Palette.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    )
                  ),
                  SizedBox(height: MQuery.height(0.025, context)),
                  Button(
                    title: "CHANGE PLAN",
                    color: Palette.warning,
                    textColor: Colors.white,
                    method: (){},
                  ),
                ],
              )
            ]
          )
        )
      )
    );
  }
}