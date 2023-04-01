import 'dart:convert';
import 'dart:io';
import 'package:chat_tutorial/models/openAI_Model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<List<OpenaiModel>> getModels() async {
    try {
      var res = await http.get(Uri.parse("https://api.openai.com/v1/models"),
          headers: {
            "Authorization":
                "Bearer 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"
          });

      Map response = jsonDecode(res.body);

      if (response["error"] != null) {
        throw HttpException(response["error"]["message"]);
      }
      print(res);
      List models = [];
      for (var model in response["data"]) {
        models.add(model);
        print(model);
      }
      return OpenaiModel.modelsFromSnapshot(models);
    } catch (e) {
      print(" $e");
      rethrow;
    }
  }
}
