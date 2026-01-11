import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {
  final baseUrl = dotenv.env['BASE_URL']!;
}
