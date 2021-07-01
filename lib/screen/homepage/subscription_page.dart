part of "../pages.dart";

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({ Key? key }) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
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
          height: MQuery.height(0.975, context),
          width: MQuery.width(1, context),
          padding: EdgeInsets.symmetric(
            vertical: MQuery.height(0.015, context)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                              "Basic",
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
                                color: Palette.primary,
                                borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              child: Center(
                                child: Text(
                                  "YOUR PLAN",
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
                          "FREE",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Palette.secondaryText
                          )
                        ),
                      ]
                    ),
                    SizedBox(height: MQuery.height(0.02, context)),
                    Row(
                      children: [
                        AdaptiveIcon(
                          android: Icons.check_circle_outline_rounded,
                          iOS: CupertinoIcons.checkmark_alt_circle,
                          color: Colors.grey
                        ),
                        SizedBox(width: MQuery.width(0.02, context)),
                        Text(
                          "Join a Handles and its feature via invitation-only",
                          style: TextStyle(
                            color: Palette.secondaryText,
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
                          color: Colors.grey
                        ),
                        SizedBox(width: MQuery.width(0.02, context)),
                        Text(
                          "Add company name on your profile",
                          style: TextStyle(
                            color: Palette.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w400
                          )
                        ),
                      ]
                    )
                  ],
                )
              ),
              Divider(height: 0),
              SizedBox(height: MQuery.height(0.02, context)),
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
                    SizedBox(height: MQuery.height(0.02, context)),
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
                    )
                  ],
                )
              ),
              Divider(height: 0),
              SizedBox(height: MQuery.height(0.02, context)),
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
                              "Starter",
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
                          ],
                        ),
                        Text(
                          //TODO: INTL LOCAL CURRENCY HERE
                          "\$9.99/mo",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Palette.secondaryText
                          )
                        ),
                      ]
                    ),
                    SizedBox(height: MQuery.height(0.02, context)),
                    Row(
                      children: [
                        AdaptiveIcon(
                          android: Icons.check_circle_outline_rounded,
                          iOS: CupertinoIcons.checkmark_alt_circle,
                          color: HexColor("00BFA5")
                        ),
                        SizedBox(width: MQuery.width(0.02, context)),
                        Text(
                          "Up to 5 Handles creation",
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
                )
              ),
              Divider(height: 0),
              Container(
                padding: EdgeInsets.all(MQuery.height(0.02, context)),
                child: Text(
                  "The default payment method provided will be charged correspondingly every month until cancelled",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.25,
                    color: Palette.secondaryText.withOpacity(0.75),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  )
                ),
              ),
              SizedBox(height: MQuery.height(0.035, context)),
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
              SizedBox(height: MQuery.height(0.01, context)),
              Button(
                title: "GO PREMIUM",
                color: Palette.primary,
                textColor: Colors.white,
                method: (){},
              )
            ],
          )
        )
      )
    );
  }
}