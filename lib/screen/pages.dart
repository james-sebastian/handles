import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:handles/config/config.dart';
import 'package:handles/widget/widgets.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pin_put/pin_put.dart';

part 'auth/onboarding.dart';
part 'auth/phone_input.dart';
part 'auth/phone_verification.dart';
part 'auth/account_creation.dart';
part 'homepage/handles_list.dart';