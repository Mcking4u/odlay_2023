import 'package:odlay_services/AppFiles/Utility/AppConstants.dart';
import 'package:odlay_services/AppFiles/Utility/HeaderFilterConstants.dart';
import 'package:odlay_services/AppFiles/Utility/LocationConstants.dart';

class ConfigureAppVariable {
  static configureUrls(int? code) {
    if (code == 2) {
      if (AppConstants.useProduction) {
        AppConstants.base_api_url = AppConstants.BaseUrlProEu;
        AppConstants.BANNERIMAGESURLS =
            "${AppConstants.ImagesBaseUrlDevEU}banners/";
        AppConstants.PROFESSIONIMAGESURLS =
            "${AppConstants.ImagesBaseUrlDevEU}new_icons/";
        AppConstants.PROFILEIMAGESURLS =
            "${AppConstants.ImagesBaseUrlDevEU}profile/";
        AppConstants.GIGIMAGESURLS = "${AppConstants.ImagesBaseUrlDevEU}gig/";
        AppConstants.REVIEWIMAGESURLS =
            "${AppConstants.ImagesBaseUrlDevEU}reviews/";
        AppConstants.JObIMAGESURLS = "${AppConstants.ImagesBaseUrlDevEU}jobs/";
        AppConstants.PORTFOLIOIMAGESURLS =
            "${AppConstants.ImagesBaseUrlDevEU}portfolio/";
        AppConstants.IMAGESLIBRARYURLS =
            "${AppConstants.ImagesBaseUrlDevEU}liberary/";
      } else {
        AppConstants.base_api_url = AppConstants.BaseUrlDevEu;
        AppConstants.BANNERIMAGESURLS =
            "${AppConstants.ImagesBaseUrlDevEU}banners/";
        AppConstants.PROFESSIONIMAGESURLS =
            "${AppConstants.ImagesBaseUrlDevEU}new_icons/";
        AppConstants.PROFILEIMAGESURLS =
            "${AppConstants.ImagesBaseUrlDevEU}profile/";
        AppConstants.GIGIMAGESURLS = "${AppConstants.ImagesBaseUrlDevEU}gig/";
        AppConstants.REVIEWIMAGESURLS =
            "${AppConstants.ImagesBaseUrlDevEU}reviews/";
        AppConstants.JObIMAGESURLS = "${AppConstants.ImagesBaseUrlDevEU}jobs/";
        AppConstants.PORTFOLIOIMAGESURLS =
            "${AppConstants.ImagesBaseUrlDevEU}portfolio/";
        AppConstants.IMAGESLIBRARYURLS =
            "${AppConstants.ImagesBaseUrlDevEU}liberary/";
      }
//set default location
      HeaderFilterConstant.defualtCityId = HeaderFilterConstant.cityIdFin;
      HeaderFilterConstant.defaultCityName = HeaderFilterConstant.cityNameFin;
      HeaderFilterConstant.defaultCityAddress =
          HeaderFilterConstant.cityAddressFin;
      // LocationConstants.USERCURRENTLATITUDE = HeaderFilterConstant.defLatFin;
      // LocationConstants.USERCURRENTLONGITUDE = HeaderFilterConstant.defLngFin;
    } else {
      if (AppConstants.useProduction) {
        AppConstants.base_api_url = AppConstants.BaseUrlProPk;
        AppConstants.BANNERIMAGESURLS =
            "${AppConstants.ImagesBaseUrlPk}banners/";
        AppConstants.PROFESSIONIMAGESURLS =
            "${AppConstants.ImagesBaseUrlPk}new_icons/";
        AppConstants.PROFILEIMAGESURLS =
            "${AppConstants.ImagesBaseUrlPk}profile/";
        AppConstants.GIGIMAGESURLS = "${AppConstants.ImagesBaseUrlPk}gig/";
        AppConstants.REVIEWIMAGESURLS =
            "${AppConstants.ImagesBaseUrlPk}reviews/";
        AppConstants.JObIMAGESURLS = "${AppConstants.ImagesBaseUrlPk}jobs/";
        AppConstants.PORTFOLIOIMAGESURLS =
            "${AppConstants.ImagesBaseUrlPk}portfolio/";
        AppConstants.IMAGESLIBRARYURLS =
            "${AppConstants.ImagesBaseUrlPk}liberary/";
      } else {
        AppConstants.base_api_url = AppConstants.BaseUrlDevPk;
        AppConstants.BANNERIMAGESURLS =
            "${AppConstants.ImagesBaseUrlPk}banners/";
        AppConstants.PROFESSIONIMAGESURLS =
            "${AppConstants.ImagesBaseUrlPk}new_icons/";
        AppConstants.PROFILEIMAGESURLS =
            "${AppConstants.ImagesBaseUrlPk}profile/";
        AppConstants.GIGIMAGESURLS = "${AppConstants.ImagesBaseUrlPk}gig/";
        AppConstants.REVIEWIMAGESURLS =
            "${AppConstants.ImagesBaseUrlPk}reviews/";
        AppConstants.JObIMAGESURLS = "${AppConstants.ImagesBaseUrlPk}jobs/";
        AppConstants.PORTFOLIOIMAGESURLS =
            "${AppConstants.ImagesBaseUrlPk}portfolio/";
        AppConstants.IMAGESLIBRARYURLS =
            "${AppConstants.ImagesBaseUrlPk}liberary/";
      }
      HeaderFilterConstant.defualtCityId = HeaderFilterConstant.cityIdPk;
      HeaderFilterConstant.defaultCityName = HeaderFilterConstant.cityNamePk;
      HeaderFilterConstant.defaultCityAddress =
          HeaderFilterConstant.cityAddressPk;
      // LocationConstants.USERCURRENTLATITUDE = HeaderFilterConstant.defLatPk;
      // LocationConstants.USERCURRENTLONGITUDE = HeaderFilterConstant.defLngPk;
    }
  }
}
