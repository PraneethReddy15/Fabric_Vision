import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Map of style names to their corresponding prompt descriptions
const Map<String, String> stylePrompts = {
  'Stripes': 'Linear patterns of varying widths, often vertical or horizontal, creating a clean, structured look. A timeless and versatile design with a crisp, orderly appearance.',
  'Checks': 'Grid-like patterns formed by intersecting horizontal and vertical lines, offering a balanced, geometric aesthetic. A polished and symmetrical fabric design.',
  'Ikat': 'Resist-dyeing technique with blurred, feathered patterns, creating geometric or abstract designs. A woven fabric showcasing a blend of tradition and modernity.',
  'Ajrakh Print': 'Complex geometric patterns, often crafted with natural dyes, featuring hand-block printed symmetrical designs. A traditional Sindhi fabric with rich, intricate detailing.',
  'Bandhani': 'Tie-and-dye technique with small, dotted patterns, forming intricate circular motifs. A lightweight, breathable fabric with traditional Gujarati textile artistry.',
  'Patola': 'Double ikat weaving with precise geometric patterns, luxurious silk fabric featuring symmetrical designs. A traditional Gujarati weave with a refined, elegant texture.',
  'Sanganeri Print': 'Intricate floral patterns with fine lines and detailed motifs, created through hand-block printing. A traditional Rajasthani fabric with a delicate, artistic appeal.',
  'Bagru Print': 'Traditional hand-block printing with natural dyes, featuring geometric patterns. A rustic, textured fabric with an earthy, authentic charm.',
  'Leheriya': 'Tie-and-dye technique with diagonal wave-like stripes, offering a lightweight and flowing texture. A traditional Rajasthani design with a dynamic, rippled effect.',
  'Kalamkari': 'Hand-painted or block-printed designs with mythological themes and floral motifs. A traditional South Indian fabric with storytelling artistry.',
  'Paisley (Mango Motif)': 'Iconic mango-shaped motifs with intricate, swirling patterns. A classic Indian textile design with rich, ornamental detailing.',
  'Banarasi Silk': 'Luxurious silk with gold and silver zari work, featuring intricate brocade patterns with floral and paisley motifs. A traditional Varanasi fabric with opulent texture.',
  'Kanjeevaram Silk': 'Heavy silk with gold zari borders, adorned with temple-inspired motifs and checks. A traditional Tamil Nadu fabric with a bold, regal finish.',
  'Phulkari': 'Embroidered floral patterns on a plain base, incorporating geometric and folk motifs. A traditional Punjabi fabric with vibrant, handcrafted charm.',
  'Chikankari': 'Delicate white thread embroidery on pastel fabrics, featuring floral and vine patterns. A subtle, elegant fabric with traditional Lucknowi finesse.',
  'Kantha': 'Running stitch embroidery with folk motifs, floral, and animal designs on a simple base. A traditional Bengali fabric with a textured, narrative quality.',
  'Madhubani': 'Hand-painted folk art with bold lines, featuring mythological and nature-inspired motifs. A traditional Bihari fabric with a striking, artistic flair.',
  'Kashmiri Embroidery': 'Intricate thread work with floral and paisley motifs. A traditional Kashmiri fabric with elaborate, handcrafted elegance.',
  'Temple Designs': 'Motifs inspired by South Indian temple architecture, featuring gopurams and deities. A traditional woven fabric with a spiritual, architectural aesthetic.',
  'Tribal and Folk Motifs': 'Bold, abstract patterns inspired by indigenous art, offering a handcrafted, rustic appearance. A fabric with earthy, cultural vibrancy.',
};

// Map of styles to their recommended colors
const Map<String, List<String>> styleColors = {
  'Stripes': ['Blue', 'White', 'red', 'Black', 'green','grey'],
  'Checks': ['Black', 'White', 'red', 'Blue', 'Green','Yellow','Grey'],
  'Sanganeri Print': ['Red', 'Blue', 'Yellow', 'Green', 'Pink'],
  'Ikat': ['Blue', 'red', 'white', 'black', 'orange', 'green'],
  'Ajrakh Print': ['Indigo', 'red', 'green', 'black', 'white'],
  'Bandhani': ['Red', 'yellow', 'green', 'blue', 'orange'],
  'Patola': ['Red', 'green', 'yellow', 'blue', 'black'],
  'Bagru Print': ['Maroon', 'Beige', 'Black', 'Indigo', 'Cream'],
  'Leheriya': ['Pink', 'Turquoise', 'Orange', 'Yellow', 'Green'],
  'Kalamkari': ['Brown', 'Red', 'Black', 'Mustard', 'Green'],
  'Paisley (Mango Motif)': ['Gold', 'Red', 'Green', 'Blue', 'Purple'],
  'Banarasi Silk': ['Red', 'Gold', 'Green', 'Blue', 'Pink'],
  'Kanjeevaram Silk': ['Red', 'Gold', 'Green', 'Blue', 'Yellow'],
  'Phulkari': ['Red', 'Pink', 'Yellow', 'Orange', 'Green'],
  'Chikankari': ['White', 'Pink', 'Blue', 'Yellow'],
  'Kantha': ['Red', 'Blue', 'Yellow', 'Green', 'Black'],
  'Madhubani': ['Red', 'Black', 'Yellow', 'Green', 'Blue'],
  'Kashmiri Embroidery': ['Green', 'Blue', 'Gold', 'Red', 'Purple'],
  'Temple Designs': ['Gold', 'Red', 'Black', 'Green', 'Blue'],
  'Tribal and Folk Motifs': ['Brown', 'Orange', 'Black', 'Red', 'Yellow'],
};

Future<File> generateAIImage(String userPrompt, String selectedStyle, List<String> selectedColors) async {
  const apiKey = 'sk-TeQw1ueqb3vxTFVcLACqqd4dukmuELUO5iFemUrkj7IvHPOg'; 
  const url = "https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image";
  // Get the style-specific prompt text
  final styleText = (stylePrompts[selectedStyle] ?? '');
  // Add selected colors to the prompt if provided
  final colorsText = selectedColors.isNotEmpty ? ", using colors: ${selectedColors.join(', ')}" : '';
  // Combine user prompt with style-specific text and colors
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(content: Text(userPrompt)),
  // );
  final fullPrompt = "$userPrompt$colorsText${styleText.isNotEmpty ? ', $styleText' : ''}";

  final body = {
    "steps": 40,
    "width": 1024,
    "height": 1024,
    "seed": 0,
    "cfg_scale": 5,
    "samples": 1,
    "text_prompts": [
      {"text": fullPrompt, "weight": 1},
      {"text": "blurry, bad", "weight": -1} // Negative prompt to avoid poor quality
    ],
  };

  final headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['artifacts'] == null || data['artifacts'].isEmpty) {
      throw Exception('No image generated by the API');
    }
    final imageBase64 = data['artifacts'][0]['base64'];
    final imageBytes = base64Decode(imageBase64);

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'ai_generated_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${appDir.path}/$fileName');
    await file.writeAsBytes(imageBytes);

    return file;
  } else {
    throw Exception('Failed to generate image: ${response.statusCode} - ${response.body}');
  }
}