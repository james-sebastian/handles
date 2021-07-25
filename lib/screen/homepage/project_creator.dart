part of "../pages.dart";

class ProjectCreator extends StatefulWidget {

  final String handlesID;
  final ProjectModel? projectModel;
  const ProjectCreator({ Key? key, required this.handlesID, this.projectModel }) : super(key: key);

  @override
  _ProjectCreatorState createState() => _ProjectCreatorState();
}

class _ProjectCreatorState extends State<ProjectCreator> {
  
  FormError errorLocation = FormError.none;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<MilestoneModel> milestones = [];

  @override
  void initState() { 
    super.initState();
    if(widget.projectModel != null){
      titleController.text = widget.projectModel!.serviceName;
      descriptionController.text = widget.projectModel!.description;
    }
  }
  
  @override
  Widget build(BuildContext context) {

    void addMilestone(MilestoneModel model){
      setState(() {
        milestones.add(model);
      });
    }

    print(milestones);

    return Consumer(
      builder: (ctx, watch,child) {

        Map? localeModel;
        final _chatProvider = watch(chatProvider);
        final _userProvider = watch(currentUserProvider);
        if(widget.projectModel != null){
          watch(projectChatMilestonesProvider(widget.projectModel!.id)).whenData((value){
            setState(() {
              milestones = value;
            });
          });
        }

        print(milestones);

        _userProvider.whenData((user){
          localeModel = CountryCodeModel.countryCodes.firstWhere((element){
            return element['dial_code'] == user.countryCode;
          });
        });

        return _userProvider.when(
          data: (user){
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
                  widget.projectModel != null ? "Edit Project Chat" : "Send a Project Chat",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  )
                ),
                actions: [
                  widget.projectModel != null
                  ? IconButton(
                    icon: AdaptiveIcon(
                      android: Icons.delete,
                      iOS: CupertinoIcons.trash,
                    ),
                    onPressed: (){
                      Get.dialog(
                        Platform.isAndroid
                          ? AlertDialog(
                              title: Text(
                                "Are you sure you want to delete this project chat?",
                              ),
                              content: Text(
                                "This action is irreversible"
                              ),
                              actions: [
                                TextButton(
                                  child: Text("CANCEL"),
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(
                                      color: Palette.warning,
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                  onPressed: (){
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: Text("DELETE"),
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(
                                      color: Palette.primary,
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                  onPressed: (){
                                    _chatProvider.deleteProjectChat(widget.handlesID, widget.projectModel!);
                                    Get.offAll(HandlesPage(handlesID: widget.handlesID));
                                  },
                                )
                              ],
                            )
                          : CupertinoAlertDialog(
                              title: Text(
                                "Are you sure you want to delete this project chat?",
                              ),
                              content: Text(
                                "This action is irreversible"
                              ),
                              actions: [
                                TextButton(
                                  child: Text("CANCEL"),
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(
                                      color: Palette.warning,
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                  onPressed: (){
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: Text("DELETE"),
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(
                                      color: Palette.primary,
                                      fontWeight: FontWeight.w500
                                    )
                                  ),
                                  onPressed: (){
                                    _chatProvider.deleteProjectChat(widget.handlesID, widget.projectModel!);
                                    Get.off(HandlesPage(handlesID: widget.handlesID));
                                  },
                                )
                              ],
                            )
                          );
                        }
                      )
                    : SizedBox()
                ]
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: MQuery.height(0.03, context),
                    horizontal: MQuery.width(0.025, context)
                  ),
                  height: MQuery.height(1.075, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0
                        ),
                        child: Font.out(
                          "Project's title",
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      SizedBox(height: MQuery.height(0.01, context)),
                      Container(
                        height: MQuery.height(0.06, context),
                        width: MQuery.width(0.9, context),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: errorLocation == FormError.title ? Palette.warning : Colors.transparent
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Palette.formColor,
                        ),
                        child: Center(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            controller: titleController,
                            cursorColor: Palette.primary,
                            style: TextStyle(
                              fontSize: 16
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: errorLocation == FormError.title ? Palette.warning : Colors.black.withOpacity(0.4)
                              ),
                              hintText: "Enter the project's title...",
                              contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              border: InputBorder.none
                            ),
                          ),
                        )
                      ),
                      SizedBox(height: MQuery.height(0.02, context)),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0
                        ),
                        child: Font.out(
                          "Project's description (optional)",
                          fontSize: 14,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      SizedBox(height: MQuery.height(0.01, context)),
                      Container(
                        height: MQuery.height(0.15, context),
                        width: MQuery.width(0.9, context),
                        padding: EdgeInsets.only(
                          top: MQuery.height(0.005, context)
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: errorLocation == FormError.description ? Palette.warning : Colors.transparent
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Palette.formColor,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          controller: descriptionController,
                          cursorColor: Palette.primary,
                          minLines: 3,
                          maxLines: 5,
                          style: TextStyle(
                            fontSize: 16
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: errorLocation == FormError.description ? Palette.warning : Colors.black.withOpacity(0.4)
                            ),
                            hintText: "Enter project's description (optional)",
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            border: InputBorder.none
                          ),
                        )
                      ),
                      SizedBox(height: MQuery.height(0.02, context)),
                      Divider(),
                      Row(
                        children: [
                          Font.out(
                            "Add milestones:",
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                          SizedBox(width: MQuery.width(0.01, context)),
                          Font.out(
                            "(optional)",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Palette.primaryText
                          )
                        ],
                      ),
                      SizedBox(height: MQuery.height(0.02, context)),
                    Container(
                        height: MQuery.height(
                          milestones.length == 0
                          ? 0
                          : milestones.length == 1
                            ? 0.2
                            : 0.4
                        , context),
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
                                endChild: Container(
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
                                                NumberFormat.simpleCurrency(
                                                  locale: localeModel!['code'] == "US" || localeModel!['code'] == "GB" || localeModel!['code'] == "AU"
                                                  ? 'en_$localeModel!["code"]'
                                                  : localeModel!['code']
                                                ).format(target.fee),
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
                            );
                          }
                        )
                      ),
                      SizedBox(height: MQuery.height(0.02, context)),
                      Button(
                        width: double.infinity,
                        title: "Create a milestone",
                        textColor: Palette.primary,
                        color: Colors.white,
                        borderColor: Palette.primary,
                        method: (){
                          Get.dialog(
                            Dialog(
                              child: MilestoneCreatorDialog(addMilestoneFunction: addMilestone, userCountryCode: user.countryCode),
                            )
                          );
                        }
                      ),
                      SizedBox(height: MQuery.height(0.02, context)),
                      Divider(),
                      SizedBox(height: MQuery.height(0.025, context)),
                      Button(
                        width: double.infinity,
                        title: widget.projectModel != null ? "Edit Project Chat" : "Send Project Chat",
                        textColor: Colors.white,
                        color: Palette.primary,
                        method: (){
                          if(titleController.text == ""){
                            setState(() {
                              errorLocation = FormError.title;
                            });
                          } else {
                            if(widget.projectModel != null){
                              _chatProvider.editProjectChat(
                                widget.projectModel!.id,
                                ProjectModel(
                                  id: widget.projectModel!.id,
                                  description: descriptionController.text,
                                  status: widget.projectModel!.status,
                                  serviceName: titleController.text,
                                  timestamp: widget.projectModel!.timestamp,
                                  paymentStatus: widget.projectModel!.paymentStatus,
                                  sender: widget.projectModel!.sender,
                                  isPinned: widget.projectModel!.isPinned,
                                  milestones: milestones
                                )
                              ).then((value){
                                Get.back();
                              });
                            } else {
                              _chatProvider.sendProjectChat(
                                widget.handlesID,
                                ProjectModel(
                                  id: Uuid().v4(),
                                  timestamp: DateTime.now(),
                                  serviceName: titleController.text,
                                  description: descriptionController.text,
                                  status: ProjectStatus.pending,
                                  paymentStatus: ProjectPaymentStatus.unpaid,
                                  milestones: milestones
                                )
                              ).then((value){
                                Get.back();
                              });
                            }
                          }
                        }
                      )
                    ],
                  )
                ),
              )
            );
          },
          loading: (){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Palette.primary)
              )
            );
          },
          error: (object , error){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Palette.warning)
              )
            );
          }
        );
      },
    );
  }
}

class MilestoneCreatorDialog extends StatefulWidget {

  final void Function(MilestoneModel) addMilestoneFunction;
  final String userCountryCode;
  const MilestoneCreatorDialog({ Key? key, required this.addMilestoneFunction, required this.userCountryCode }) : super(key: key);

  @override
  _MilestoneCreatorDialogState createState() => _MilestoneCreatorDialogState();
}

class _MilestoneCreatorDialogState extends State<MilestoneCreatorDialog> {

  DateTime? baseDate;
  FormError errorLocation = FormError.none;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController feeController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Future<void> _selectDate(BuildContext context) async {

      baseDate = DateTime.now();

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: baseDate!,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2100)
      );
      if (picked != null && picked != baseDate)
        setState(() {
          baseDate = picked;
        }
      );
    }

    Map? localeModel = CountryCodeModel.countryCodes.firstWhere((element){
      return element['dial_code'] == widget.userCountryCode;
    });

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MQuery.height(0.75, context)
      ),
      child: Container(
        width: MQuery.width(0.9, context),
        padding: EdgeInsets.all(MQuery.height(0.02, context)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0
                ),
                child: Font.out(
                  "Milestone's title",
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: MQuery.height(0.01, context)),
              Container(
                height: MQuery.height(0.06, context),
                width: MQuery.width(0.9, context),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: errorLocation == FormError.title ? Palette.warning : Colors.transparent
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.formColor,
                ),
                child: Center(
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: titleController,
                    cursorColor: Palette.primary,
                    style: TextStyle(
                      fontSize: 16
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: errorLocation == FormError.title ? Palette.warning : Colors.black.withOpacity(0.4)
                      ),
                      hintText: "Enter the milestone's title...",
                      contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      border: InputBorder.none
                    ),
                  ),
                )
              ),
              SizedBox(height: MQuery.height(0.02, context)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0
                ),
                child: Font.out(
                  "Milestone's description (opt.)",
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: MQuery.height(0.01, context)),
              Container(
                height: MQuery.height(0.15, context),
                width: MQuery.width(0.9, context),
                padding: EdgeInsets.only(
                  top: MQuery.height(0.005, context)
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: errorLocation == FormError.description ? Palette.warning : Colors.transparent
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Palette.formColor,
                ),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: descriptionController,
                  cursorColor: Palette.primary,
                  minLines: 3,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 16
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: errorLocation == FormError.description ? Palette.warning : Colors.black.withOpacity(0.4)
                    ),
                    hintText: "Enter milestone's description (optional)",
                    contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    border: InputBorder.none
                  ),
                )
              ),
              SizedBox(height: MQuery.height(0.02, context)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0
                ),
                child: Font.out(
                  "Milestone's Due Date (opt.)",
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: MQuery.height(0.01, context)),
              GestureDetector(
                onTap: (){
                  _selectDate(context);
                },
                child: Container(
                  height: MQuery.height(0.06, context),
                  width: MQuery.width(0.9, context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Palette.formColor,
                  ),
                  child: Center(
                    child: Text(
                      baseDate == null
                      ? "No due date"
                      : DateFormat.yMMMMd().format(baseDate!),
                      style: TextStyle(
                        fontSize: 16
                      )
                    ),
                  )
                ),
              ),
              SizedBox(height: MQuery.height(0.02, context)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0
                ),
                child: Font.out(
                  "Milestone's fee (opt.)",
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: MQuery.height(0.01, context)),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        NumberFormat.simpleCurrency(
                          locale: localeModel['code'] == "US" || localeModel['code'] == "GB" || localeModel['code'] == "AU"
                          ? 'en_$localeModel!["code"]'
                          : localeModel['code']
                        ).currencySymbol.toString(),
                        style: TextStyle(
                          fontSize: 16
                        )
                      )
                    ),
                  ),
                  Spacer(flex: 1),
                  Expanded(
                    flex: 20,
                    child: Container(
                      height: MQuery.height(0.06, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Palette.formColor,
                      ),
                      child: Center(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: feeController,
                          cursorColor: Palette.primary,
                          style: TextStyle(
                            fontSize: 16
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.4)
                            ),
                            hintText: "Enter the milestone's fee...",
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            border: InputBorder.none
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
              SizedBox(height: MQuery.height(0.02, context)),
              Button(
                width: double.infinity,
                title: "Create a milestone",
                textColor: Palette.primary,
                color: Colors.white,
                borderColor: Palette.primary,
                method: (){
                  Get.back();
                  if(titleController.text == ""){
                    setState(() {
                      errorLocation = FormError.title;
                    });
                  } else {
                    widget.addMilestoneFunction(
                      MilestoneModel(
                        id: Uuid().v4(),
                        milestoneName: titleController.text,
                        description: descriptionController.text,
                        status: ProjectStatus.pending,
                        paymentStatus: ProjectPaymentStatus.unpaid,
                        isCompleted: false,
                        dueDate: baseDate,
                        fee: int.parse(
                          feeController.text == ""
                          ? "0"
                          : feeController.text
                        )
                      )
                    );
                  }
                }
              ),
            ]
          )
        )
      ),
    );
  }
}