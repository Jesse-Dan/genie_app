const String OPEN_AI_KEY =
    "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";

const String baseURL = "https://api.openai.com/v1";

String endPoint(String endPoint) => "$baseURL/$endPoint";

Map<String, String> headerBearerOption(String token) => {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

enum ApiState { loading, success, error, notFound }
