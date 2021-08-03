import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:handles/model/models.dart';
import 'package:handles/screen/pages.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path/path.dart' as flutter_path;

part "authentication_services.dart";
part 'user_services.dart';
part 'handles_services.dart';
part 'chat_services.dart';
part 'call_services.dart';
part 'purchases_services.dart';