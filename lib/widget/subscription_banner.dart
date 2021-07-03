part of "widgets.dart";

class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){Get.to(() => SubscriptionPage(), transition: Transition.cupertino);},
      tileColor: Palette.tertiary,
      leading: CircleAvatar(
        backgroundColor: Palette.tertiary,
        radius: MQuery.height(0.025, context),
        child: SvgPicture.asset(
          "assets/mdi_chat-plus-outline.svg",
          color: Colors.black,
          height: 30, width: 30
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(
        MQuery.width(0.02, context),
        MQuery.height(0, context),
        MQuery.width(0.02, context),
        MQuery.height(0, context),
      ),
      title: Font.out(
        "Create your Handles",
        fontSize: 16,
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.start
      ),
      subtitle: Font.out(
        "and collaborate with ease",
        fontSize: 14,
        fontWeight: FontWeight.w400,
        textAlign: TextAlign.start
      ),
      trailing: Container(
        height: 27.5,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: ProTag()
      ),
    );
  }
}