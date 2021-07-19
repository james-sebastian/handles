part of "widgets.dart";

class AddMemberViaNumberDialog extends StatefulWidget {
  
  final void Function(UserModel, String)? addMember;
  final String? handlesID;
  final Map<String, String>? handlesMembers;
  final UserModel? userModel;
  const AddMemberViaNumberDialog({ Key? key, this.addMember, this.handlesID, this.handlesMembers, this.userModel}) : super(key: key);

  @override
  _AddMemberViaNumberDialogState createState() => _AddMemberViaNumberDialogState();
}

class _AddMemberViaNumberDialogState extends State<AddMemberViaNumberDialog> {

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  bool isError = false;
  String dropdownValue = "Member";

  @override
  void initState() { 
    super.initState();
    if(widget.userModel != null){
      phoneNumberController.text = widget.userModel!.phoneNumber.substring(widget.userModel!.countryCode.length, widget.userModel!.phoneNumber.length);
      countryCodeController.text = widget.userModel!.countryCode.replaceAll("+", "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, watch,child) {

        final _handlesProvider = watch(handlesProvider);

        return Dialog(
          insetPadding: EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MQuery.height(0.75, context),
              minWidth: MQuery.width(0.8, context)
            ),
            child: Container(
              padding: EdgeInsets.all(MQuery.height(0.01, context)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MQuery.height(0.02, context)),
                    Text(
                      "Add Collaborator",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Palette.primaryText,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(height: MQuery.height(0.02, context)),
                    Container(
                      child: Row(
                        children: [
                          SizedBox(width: MQuery.width(0.01, context)),
                          Text(
                            "+",
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                          SizedBox(width: MQuery.width(0.005, context)),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: MQuery.height(0.065, context),
                              padding: const EdgeInsets.only(left: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Palette.formColor,
                              ),
                              child: Center(
                                child: TextFormField(
                                  readOnly: widget.userModel != null,
                                  keyboardType: TextInputType.number,
                                  controller: countryCodeController,
                                  cursorColor: Palette.primary,
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: isError ? Palette.warning : Colors.black.withOpacity(0.4)
                                    ),
                                    hintText: "61",
                                    contentPadding: EdgeInsets.fromLTRB(2.5, 10, 5, 10),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                            )
                          ),
                          SizedBox(width: MQuery.width(0.01, context)),
                          Expanded(
                            flex: 14,
                            child: Container(
                              height: MQuery.height(0.065, context),
                              width: MQuery.width(0.9, context),
                              margin: const EdgeInsets.only(left: 0.0, right: 7.5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isError ? Palette.warning : Colors.transparent
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Palette.formColor,
                              ),
                              child: Center(
                                child: TextFormField(
                                  readOnly: widget.userModel != null,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp("^0+"), replacementString: "")
                                  ],
                                  keyboardType: TextInputType.phone,
                                  controller: phoneNumberController,
                                  cursorColor: Palette.primary,
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      color: isError ? Palette.warning : Colors.black.withOpacity(0.4)
                                    ),
                                    hintText: "Ex: 2 3456 7890",
                                    contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    border: InputBorder.none
                                  ),
                                  onEditingComplete: (){
                                    phoneNumberController.text.replaceAll("0", "");
                                  },
                                  onFieldSubmitted: (value){
                                    value.replaceAll("0", "");
                                  },
                                ),
                              )
                            ),
                          )
                        ],
                      )
                    ),
                    SizedBox(height: MQuery.height(0.01, context)),
                    Container(
                      child: Row(
                        children: [
                          SizedBox(width: MQuery.width(0.01, context)),
                          Text(
                            "Role: ",
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                          SizedBox(width: MQuery.width(0.01, context)),
                          Expanded(
                            flex: 14,
                            child: Container(
                              height: MQuery.height(0.065, context),
                              width: MQuery.width(0.9, context),
                              margin: const EdgeInsets.only(left: 0.0, right: 7.5),
                              padding: EdgeInsets.symmetric(
                                horizontal: MQuery.width(0.015, context)
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isError ? Palette.warning : Colors.transparent
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Palette.formColor,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: dropdownValue,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text("Admin"),
                                      value: "Admin",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Client"),
                                      value: "Client",
                                    ),
                                    DropdownMenuItem(
                                      child: Text("Member"),
                                      value: "Member",
                                    )
                                  ],
                                  onChanged: (String? value){
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  }
                                )
                              )
                            ),
                          )
                        ],
                      )
                    ),
                    SizedBox(height: MQuery.height(0.02, context)),
                    Button(
                      width: MQuery.height(0.3, context),
                      title: widget.userModel != null ? "Edit Collaborator Role" : "Add Collaborator",
                      textColor: Colors.white,
                      method: (){
                        _handlesProvider.addMember("+" + countryCodeController.text + phoneNumberController.text).then((value){
                          if(value != null){
                            print("bo");
                            if(widget.addMember != null){
                              widget.addMember!(value, dropdownValue);
                            } else {
                              print("kapow");
                              Map<String, String> newHandleMembers = widget.handlesMembers!;
                              newHandleMembers[value.id] = dropdownValue;

                              _handlesProvider.addHandleCollaborators(value, newHandleMembers, widget.handlesID!, widget.userModel != null);
                            }
                            Get.back();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The user with that phone number cannot be found.')));
                            Get.back();
                          }
                        });
                      },
                      color: Palette.primary
                    ),
                    SizedBox(height: MQuery.height(0.02, context)),
                  ]
                )
              )
            )
          )
        );
      },
    );
  }
}

