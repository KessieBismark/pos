import 'package:http/http.dart' as http;

class Sms {
  static String mail = '';
  static String smsAPI = '';
  static String smsHeader = '';

  Future sendSms(String phone, String message) async {
    try {
      final res = await http.get(
          Uri.parse(
              "http://dashboard.eazismspro.com/sms/api?action=send-sms&api_key= ${smsAPI.trim()}&to=${phone.trim()}&from=${smsHeader.trim()}&sms=${message.trim()}"
              
              ),
          );
      print(
          "http://dashboard.eazismspro.com/sms/api?action=send-sms&api_key= ${smsAPI.trim()}&to=${phone.trim()}&from=${smsHeader.trim()}&sms=${message.trim()}");
      print(res.body);
      return res.statusCode;
    } catch (e) {
      print.call(e);
      return null;
    }
  }
}
