
class APIRoutes{

  static const API_URL = "https://sandbox.nellys-coin.ejaraapis.xyz/";
  static const API_PORT = null;
  static const ROOT = API_URL + (API_PORT!=null?":$API_PORT":"")  + "/api";

  static const CHECK_CREDENTIALS = ROOT + "/v1/auth/sign-up/check-signup-details";

}
