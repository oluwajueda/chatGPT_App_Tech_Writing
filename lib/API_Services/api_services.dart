import 'dart:convert';
import 'dart:io';
import 'package:chat_tutorial/models/chatModel.dart';
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

  static Future<List<ChatModel>> sendMessages(
      {required String message, required String modelId}) async {
    try {
      var response = await http.post(
        Uri.parse("https://api.openai.com/v1/completions"),
        headers: {
          "Authorization":
              "Bearer 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",
          "Content-Type": "application/json"
        },
        body: jsonEncode(
            {"model": modelId, "prompt": message, "max_tokens": 100}),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse["error"] != null) {
        // print("jsonResponse['error'] ${jsonResponse["error"]["message"]}");
        throw HttpException(jsonResponse["error"]["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // print("jsonResponse[choices] ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
                  msg: jsonResponse["choices"][index]["text"],
                  chatIndex: 1,
                ));
      }
      return chatList;
    } catch (e) {
      print("error $e");
      rethrow;
    }
  }
}
