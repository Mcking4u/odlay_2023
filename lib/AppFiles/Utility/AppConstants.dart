// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AppConstants {
//coanfiguring base url fro api's
  static String BaseUrlDevPk = "https://pakapi.odlay.com/api_dev/api";
  static String BaseUrlDevEu =
      "https://euapi.odlay.com/api_servicesfin_dev/api";
  static String BaseUrlProPk = "https://pakapi.odlay.com/api_234/api";
  static String BaseUrlProEu =
      "https://euapi.odlay.com/api_servicesfin_234/api";
  static String base_api_url = "";
  //Images urls
  static String ImagesBaseUrlPk = "https://pakapi.odlay.com/public/images/";
  static String ImagesBaseUrlDevEU = "https://euapi.odlay.com/public/images/";
  static String ImagesBaseUrlProPk = "https://pakapi.odlay.com/public/images/";
  static String ImagesBaseUrlProEU = "https://euapi.odlay.com/public/images/";

  static String BANNERIMAGESURLS = "";
  static String PROFESSIONIMAGESURLS = "";
  static String PROFILEIMAGESURLS = "";
  static String GIGIMAGESURLS = "";
  static String REVIEWIMAGESURLS = "";
  static String JObIMAGESURLS = "";
  static String PORTFOLIOIMAGESURLS = "";
  static String IMAGESLIBRARYURLS = "";

// user production
  static bool useProduction = true;
// allow notfication same page load
  static bool allowCustLoad = false;
  static bool allowSpLoad = false;
  //App Api's Headers
  static String AUTHOEIZATION_KEY_PRIMARY =
      "Bearer wfbdNZJaPFRb3BYDFFXKfvRdcESZYBH6fmvJ6DM8yxsN7BLf9GQSFCpJYeCXCAK7Qf6YJuxxAbWDN6UgBV3V9Hpk8Q9RkFznjtZS6QJN4dCeqAx3yVSPQKfW9NdZDdXe";
  static String AUTHOEIZATION_BEARER = "Bearer ";

//image type constant
  static String IMAGETYPEJOBS = "jobs";
  static String IMAGETYPEGIG = "gig";
  static String IMAGETYPEPORTFOLIO = "portfolio";
  static String IMAGETYPEPORTREVIEWS = "reviews";
  static String IMAGETYPEIDENTITY = "identity";
  static String IMAGETYPEPROFILE = "profile_type";

//gig status types
  static String GIGSTATUS = "status_change";
  static String DELTEGIG = "del";
  static String EDITGIG = "edit";

  static late String APP_NUMBER = "+923115920803";
//gig statuses server
  static int ACTVIESTATUS = 1;
  static int DEACTVIESTATUS = 0;
  static int DELETEGIGSTATUS = 2;

//user enable disable user
  static int DISABLEMYACCOUNT = 3;
  static int DELETEMYACCOUNT = 5;
  static int ENABLEMYACCOUNT = 1;

  static const String PRIVATE_KEY =
      "MIIEpQIBAAKCAQEAxl67IEBsTRBJlf1bt40mTChDQ8p9/HJRy3dyYs+mq4EM2UOa2IUrUaWJJrbFkCpDQTUmNc6FPOjU5l7+4N3ymfMlTP9/RQSgKJFmGl7QNrv00AAmwMgjL1/lzF9dgvTLaJxPseDiBJbj1b8s7UOoeREtgje3DrqAR7JAEI/uhVgdnyIWI/LAkg1bH9Fh6rXcfG0Q0WhTXAeBd6Ll1muCK8Vk1HS55ki2Zai9v78znsxVJKMwpJFUHHzNFFypdEjyK55VG1eNEeuuVGI5Zc30Nz1JDV0+PQ/Sml834pCrVbEgcZQyaR+ZhCKyq1iC7/uC0Ovyo5wxGTrv4lRDIBe1nwIDAQABAoIBAQCDlGyNLQ5pY6db3S2MKA1CMObFPbipze6hhr6R+mj0k+pA5w38FwEv7Bx4WH3dbZsk0qtgv3czesFVeaeY4r+8DEMuur7hufq+Tguq7D8yPyRZH/CUqWxlTTfxg0RUzClsX1qhg6iIIMpJisCzNNC4VYOZP3mmRGE4rWy/T6mIOkkcxzH/zQihuiySFoCwSbRFzxBeR3NpISvkOxd/YOS3dzTN/SxCbOXxxr/9ogvOUQ33lMYvchdmHUgwU89GWlVRiOsqD4PCBZpgBsQxzmc7Fm0S+7a7rdlEC11xErdsg3V6jSILK27pVjTKYfYxkAriaA57FGf4X9+UMs5DNGwJAoGBAPknBuJtITkV4mUNdpke4jPcs+ceR6tbC3KrHcp3N5kgKHtmB391spZ9md3pWtEmcaWor0Cl2W7WyR7B7i6j0Q0aKynFBZzYxqb0cL/cTd2d5tNjypTVNTwSToZYMpais4jKtszSQ86s2hvx28V95e7h8I69LmYfyFL0132nNHE7AoGBAMvSaXlK4QzQIlOCuk+VoM9Vx3vd3vFjkZK1s0KvGKfSoC27Ct/5wG9PPyXR5InCYSxoyqm4cAV+3j0k2E6fWEFWaJIlrdA/r2fiuBXW0bWZQFz6sGKWnWbcXkEkCiLobw4z8A42cPo8odvvLznP3u/vOUo9ssm0JCR/X3cPcobtAoGBAN4jNJkmUUuzPlF4ingEuAsjSGbUcXPOzcsj04DTgAePS2iR1DeI+XwBafEXgDgffY4EcpRCCjUvXMuGflSpC9cRsNAh8FoiUCNEp034HphrkwR/4XuHCFqRu989vYTedRGOIyNEiN448JGftqFDGYE9gpvRAhBdX97Om15VeIVHAoGBAItyi+MGTe7cP3/vQtTMRFdWEsM2Sx/PxXsggWKwNSgsvJZND+WpE/WTvFp9veRabu1ZTL7NhybbY+VlXfB8qH8bRTQoP0DpMXLb9KJMdPHPxe9XPHJXJZ2IS5w5sg2sBL8s3aJ7sNQjw4GbpS3igF6bxxB6IeZKLyghVQk6MlsJAoGAV6O/SVpXQ+QD3+v+/SrduOT85tZZpEkkpkpC4GQ0Urnx0ivrraAMDJxHzZ+L4nPUufAgsqxE0HtloH4mtt7foVl6OSAIkz5ecQ2kZGTEEzNH1yJ69jhJ+jnA2uYNn8Vf4isT5YwEr8UNayqkU23AR2mz7PlUwgm9N24PSdAdqKQ=";
  static bool isSlectedUserCustomer = false;

  static late BuildContext baseContext;

//lagauge value
  static int LANGUAGE_ENGLISH = 7;
  static int LANGUAGE_SWEDISH = 6;
  static int LANGUAGE_SUOMI = 5;

//Help links
  static String privacy_policy_link = "http://www.odlay.com/privacy-policy";
  static String privacy_terms_links =
      "http://www.odlay.com/terms-and-conditions";
}
