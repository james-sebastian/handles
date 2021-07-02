part of "widgets.dart";

class MilestoneDialog extends StatelessWidget {
  final String milestoneName;
  final String description;
  final bool isCompleted;
  final ProjectPaymentStatus paymentStatus;
  final ProjectStatus status;
  final DateTime? dueDate;
  final int? fee;

  const MilestoneDialog({
    this.fee,
    this.dueDate,
    required this.milestoneName,
    required this.description,
    required this.isCompleted,
    required this.paymentStatus,
    required this.status,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MQuery.height(0.75, context)
      ),
      child: Container(
        width: MQuery.width(0.8, context),
        padding: EdgeInsets.all(MQuery.height(0.02, context)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                this.milestoneName,
                style: TextStyle(
                  fontSize: 18,
                  color: Palette.primaryText,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: MQuery.height(0.005, context)),
              Text(
                NumberFormat.simpleCurrency(locale: 'en_AU').format(this.fee),
                style: TextStyle(
                  fontSize: 16,
                  color: Palette.primaryText,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: MQuery.height(0.015, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.dueDate != null
                    ? "Due: ${DateFormat.yMMMMd('en_US').format(this.dueDate!)}"
                    : "No due date",
                    style: TextStyle(
                      fontSize: 14,
                      color: Palette.primaryText,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      this.paymentStatus == ProjectPaymentStatus.paid
                      ? GeneralStatusTag(
                          mini: true,
                          status: "PAID",
                          color: Palette.secondary
                        )
                      : this.paymentStatus == ProjectPaymentStatus.unpaid
                      ? GeneralStatusTag(
                          mini: true,
                          status: "UNPAID",
                          color: Palette.primary
                        )
                      : SizedBox(),
                      SizedBox(width: MQuery.width(0.005, context)),
                      this.status == ProjectStatus.pending
                      ? GeneralStatusTag(
                          mini: true,
                          status: "PENDING",
                          color: Colors.grey[800]!
                        )
                      : this.status == ProjectStatus.in_progress
                      ? GeneralStatusTag(
                          mini: true,
                          status: "IN PROGRESS",
                          color: Palette.tertiary
                        )
                      : this.status == ProjectStatus.completed
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
              SizedBox(height: MQuery.height(0.025, context)),
              Text(
                this.description,
                textAlign: TextAlign.start,
                style: TextStyle(
                  height: 1.5,
                  fontSize: 14,
                  color: Palette.primaryText,
                  fontWeight: FontWeight.w400
                ),
              ),
              //TODO: CHECK IF CURRENT USER ROLE == ADMIN
              Column(
                children: [
                  SizedBox(height: MQuery.height(0.025, context)),
                  this.status == ProjectStatus.pending
                  ? Button(
                      width: double.infinity,
                      height: MQuery.height(0.05, context),
                      title: "Mark as Working",
                      textColor: Colors.white,
                      color: Palette.primary,
                      method: (){}
                    )
                  : this.status == ProjectStatus.in_progress
                    ? Button(
                        width: double.infinity,
                        height: MQuery.height(0.05, context),
                        title: "Mark as Done",
                        textColor: Colors.white,
                        color: Palette.primary,
                        method: (){}
                      )
                    : SizedBox(),
                  SizedBox(height: MQuery.height(0.01, context)),
                  this.paymentStatus == ProjectPaymentStatus.unpaid
                  ? Button(
                      width: double.infinity,
                      height: MQuery.height(0.05, context),
                      title: "Mark as Paid",
                      textColor: Colors.white,
                      color: Palette.secondary,
                      method: (){}
                    )
                  : SizedBox(),
                  SizedBox(height: MQuery.height(0.01, context)),
                  Button(
                    width: double.infinity,
                    height: MQuery.height(0.05, context),
                    title: "Delete Milestone",
                    textColor: Palette.warning,
                    color: Colors.white,
                    borderColor: Palette.warning,
                    method: (){}
                  ),
                ],
              )
            ],
          )
        )
      ),
    );
  }
}