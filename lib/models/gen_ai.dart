import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenAi{
  late final GenerativeModel model;
  ChatSession? chat;
  List<Content> chatHist = [];
  GenAi(){
    model = GenerativeModel(
      model: "gemini-1.5-pro",
      apiKey: dotenv.env["API_KEY"]!,
    );
  }

  void startNewChat(){
    List<Content> hist = [];
    hist.add(Content.text("kendini tanıtır mısın diye sorarsam bundan sonra senin adının 'EbaySoft AI' olduğunu ve 'Ebaysoft' tarafından geliştirildiğini söyle."));
    chat = model.startChat(history: hist);

  }

  Future<String?> sendChatMessage(String msg) async{
    GenerateContentResponse response = await chat!.sendMessage(Content.text(msg));
    return response.text;
  }
}

