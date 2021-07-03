import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:favicon/favicon.dart' as Favicon;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:handles/config/config.dart';
import 'package:handles/model/models.dart';
import 'package:handles/widget/widgets.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:animate_do/animate_do.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_contact/contact.dart';  
import 'package:permission_handler/permission_handler.dart';

part 'auth/onboarding.dart';
part 'auth/phone_input.dart';
part 'auth/phone_verification.dart';
part 'auth/account_creation.dart';
part 'homepage/homepage.dart';
part 'homepage/archived_handles.dart';
part 'homepage/detailed_call_page.dart';
part 'homepage/empty_handles.dart';
part 'homepage/handles_page.dart';
part 'homepage/image_previewer.dart';
part 'homepage/video_previewer.dart';
part 'homepage/meeting_detailed_page.dart';
part 'homepage/project_detailed_page.dart';
part 'homepage/meeting_creator.dart';
part 'homepage/pick_images_page.dart';
part 'homepage/preview_images_page.dart';
part 'homepage/pick_videos_page.dart';
part 'homepage/preview_videos_page.dart';
part 'homepage/settings_page.dart';
part 'homepage/profile_page.dart';
part 'homepage/subscription_page.dart';
part 'homepage/project_creator.dart';
part 'homepage/handles_detailed_page.dart';
part 'homepage/handles_medias_page.dart';
part 'homepage/active_subscription_page.dart';
part 'homepage/handles_creator.dart';
part 'homepage/contact_picker.dart';
