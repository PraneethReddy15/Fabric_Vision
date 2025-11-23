// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'screens/home_screen.dart'; // Adjust the import path as needed
//
// class IntroScreen extends StatefulWidget {
//   const IntroScreen({super.key});
//
//   @override
//   _IntroScreenState createState() => _IntroScreenState();
// }
//
// class _IntroScreenState extends State<IntroScreen> {
//   // List of sample image paths for the slideshow (add these to your assets)
//   final List<String> imagePaths = [
//     'assets/slideshow/image1.jpg',
//     'assets/slideshow/image2.jpg',
//     'assets/slideshow/image3.jpg',
//     'assets/slideshow/image4.jpg',
//     'assets/slideshow/image5.jpg',
//     'assets/slideshow/image6.jpg',
//     'assets/slideshow/image7.jpg',
//   ];
//
//   // Function to pick and crop an image
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: pickedFile.path,
//         aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: Colors.blue,
//             toolbarWidgetColor: Colors.white,
//             lockAspectRatio: true,
//           ),
//           IOSUiSettings(
//             title: 'Crop Image',
//             aspectRatioLockEnabled: true,
//           ),
//         ],
//       );
//       if (croppedFile != null) {
//         // Navigate to HomeScreen with the cropped image
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomeScreen(fabricFile: File(croppedFile.path)),
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Responsive slideshow
//           CarouselSlider(
//             options: CarouselOptions(
//               height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height
//               autoPlay: true, // Auto-cycle images
//               enlargeCenterPage: true, // Highlight the center image
//               viewportFraction: 0.9, // Show part of adjacent images
//             ),
//             items: imagePaths.map((path) {
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: const EdgeInsets.symmetric(horizontal: 5.0),
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(path),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 20), // Space between slideshow and buttons
//           // Image selection buttons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () => _pickImage(ImageSource.gallery),
//                 child: const Text('Upload from Gallery'),
//               ),
//               const SizedBox(width: 20), // Space between buttons
//               ElevatedButton(
//                 onPressed: () => _pickImage(ImageSource.camera),
//                 child: const Text('Capture from Camera'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:tailing/screens/recent_screen.dart';
// import 'screens/home_screen.dart';
// import 'services/api_service.dart';
//
// class IntroScreen extends StatefulWidget {
//   const IntroScreen({super.key});
//
//   @override
//   _IntroScreenState createState() => _IntroScreenState();
// }
//
// class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin {
//   final List<String> imagePaths = [
//     'assets/slideshow/image1.jpg',
//     'assets/slideshow/image2.jpg',
//     'assets/slideshow/image3.jpg',
//     'assets/slideshow/image4.jpg',
//     'assets/slideshow/image5.jpg',
//     'assets/slideshow/image6.jpg',
//     'assets/slideshow/image7.jpg',
//   ];
//
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     )..forward();
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: pickedFile.path,
//         aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: Colors.blue,
//             toolbarWidgetColor: Colors.white,
//             lockAspectRatio: true,
//           ),
//           IOSUiSettings(
//             title: 'Crop Image',
//             aspectRatioLockEnabled: true,
//           ),
//         ],
//       );
//       if (croppedFile != null) {
//         // Navigate to HomeScreen with the cropped image
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomeScreen(fabricFile: File(croppedFile.path)),
//           ),
//         );
//       }
//     }
//   }
//
//   Future<void> _showPromptDialog(BuildContext context) async {
//     final TextEditingController promptController = TextEditingController();
//
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Enter Your Prompt'),
//         content: TextField(
//           controller: promptController,
//           decoration: const InputDecoration(hintText: 'e.g., '),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _generateAndCropImage(promptController.text);
//             },
//             child: const Text('Generate'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _generateAndCropImage(String userPrompt) async {
//     if (userPrompt.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a prompt')),
//       );
//       return;
//     }
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(child: CircularProgressIndicator()),
//     );
//
//     try {
//       final generatedFile = await generateAIImage(userPrompt);
//       Navigator.pop(context);
//
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: generatedFile.path,
//         aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
//       );
//
//       if (croppedFile != null && mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomeScreen(fabricFile: File(croppedFile.path)),
//           ),
//         );
//       }
//     } catch (e) {
//       Navigator.pop(context);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error generating image: $e')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Dynamic Gradient Background
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.blue.shade400,
//                   Colors.purple.shade600,
//                 ],
//               ),
//             ),
//           ),
//           // Full-Screen Slideshow with Parallax
//           CarouselSlider(
//             options: CarouselOptions(
//               height: MediaQuery.of(context).size.height,
//               autoPlay: true,
//               enlargeCenterPage: true,
//               viewportFraction: 1.0,
//               autoPlayCurve: Curves.easeInOut,
//               autoPlayAnimationDuration: const Duration(milliseconds: 1000),
//             ),
//             items: imagePaths.map((path) {
//               return Transform(
//                 transform: Matrix4.identity()
//                   ..setEntry(3, 2, 0.001) // Perspective
//                   ..rotateY(0.05), // Slight tilt
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage(path),
//                       fit: BoxFit.cover,
//                       colorFilter: ColorFilter.mode(
//                         Colors.black.withOpacity(0.2),
//                         BlendMode.dstATop,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           // App Name with Gradient and Animation
//           Positioned(
//             top: 50,
//             left: 0,
//             right: 0,
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: Center(
//                   child: ShaderMask(
//                     shaderCallback: (bounds) => const LinearGradient(
//                       colors: [Colors.pink, Colors.blue],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ).createShader(bounds),
//                     child: const Text(
//                       'FabricVision',
//                       style: TextStyle(
//                         fontSize: 48,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Image Selection Buttons
//           Positioned(
//             bottom: 50,
//             left: 0,
//             right: 0,
//             child: FadeTransition(
//               opacity: _fadeAnimation, // Assuming _fadeAnimation is defined in your state
//               child: Wrap(
//                 spacing: 20.0,           // Horizontal space between buttons
//                 runSpacing: 10.0,        // Vertical space between lines when wrapping occurs
//                 alignment: WrapAlignment.center, // Center buttons within each line
//                 children: [
//                   _buildButton(
//                     icon: Icons.photo_library,
//                     label: 'Gallery',
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                   ),
//                   _buildButton(
//                     icon: Icons.camera_alt,
//                     label: 'Camera',
//                     onPressed: () => _pickImage(ImageSource.camera),
//                   ),
//                   _buildButton(
//                     icon: Icons.auto_awesome,
//                     label: 'AI Gen',
//                     onPressed: () => _showPromptDialog(context),
//                   ),
//                   _buildButton(
//                     icon: Icons.recent_actors,
//                     label: 'Recents',
//                     onPressed: () async {
//                       final selectedPath = await Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => RecentsScreen()),
//                       );
//                       if (selectedPath != null) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => HomeScreen(fabricFile: File(selectedPath)),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Material(
//         elevation: 10, // Adds elevation similar to ElevatedButton
//         shadowColor: Colors.black45, // Shadow for depth
//         borderRadius: BorderRadius.circular(50), // Rounded corners
//         child: InkWell(
//           onTap: onPressed, // Handles tap events
//           borderRadius: BorderRadius.circular(50), // Matches container shape for ripple effect
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.purple.shade700, Colors.blue.shade700], // Gradient colors
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(50), // Consistent rounding
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min, // Keeps content compact
//               children: [
//                 Icon(icon, color: Colors.white), // Icon with white color
//                 const SizedBox(width: 10), // Spacing between icon and text
//                 Text(
//                   label,
//                   style: const TextStyle(color: Colors.white), // White text
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(const MaterialApp(home: IntroScreen()));
// }


//
// class IntroScreen extends StatefulWidget {
//   const IntroScreen({super.key});
//
//   @override
//   _IntroScreenState createState() => _IntroScreenState();
// }
//
// class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin {
//   final List<String> imagePaths = [
//     'assets/slideshow/image1.jpg',
//     'assets/slideshow/image2.jpg',
//     'assets/slideshow/image3.jpg',
//     'assets/slideshow/image4.jpg',
//     'assets/slideshow/image5.jpg',
//     'assets/slideshow/image6.jpg',
//     'assets/slideshow/image7.jpg',
//   ];
//
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     )..forward();
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile != null) {
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: pickedFile.path,
//         aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Image',
//             toolbarColor: Colors.blue,
//             toolbarWidgetColor: Colors.white,
//             lockAspectRatio: true,
//           ),
//           IOSUiSettings(
//             title: 'Crop Image',
//             aspectRatioLockEnabled: true,
//           ),
//         ],
//       );
//       if (croppedFile != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomeScreen(fabricFile: File(croppedFile.path)),
//           ),
//         );
//       }
//     }
//   }
//
//   Future<void> _showPromptDialog(BuildContext context) async {
//     final TextEditingController promptController = TextEditingController();
//     String? selectedStyle;
//
//     final List<String> styles = [
//       'Sanganeri Print',
//       'Bagru Print',
//       'Ajrakh Print',
//       'Bandhani',
//       'Leheriya',
//       'Kalamkari',
//       'Ikat',
//       'Paisley (Mango Motif)',
//       'Banarasi Silk',
//       'Kanjeevaram Silk',
//       'Phulkari',
//       'Chikankari',
//       'Kantha',
//       'Patola',
//       'Madhubani',
//       'Kashmiri Embroidery',
//       'Checks and Stripes',
//       'Temple Designs',
//       'Tribal and Folk Motifs',
//     ];
//
//     await showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Enter Your Prompt'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: promptController,
//                   decoration: const InputDecoration(
//                     hintText: 'e.g., A floral pattern',
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text('Select a Style:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 5),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: styles.map((style) {
//                     return ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           selectedStyle = style;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: selectedStyle == style ? Colors.blue : null,
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                       ),
//                       child: Text(style),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (selectedStyle == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Please select a style')),
//                   );
//                   return;
//                 }
//                 Navigator.pop(context);
//                 _generateAndCropImage(promptController.text, selectedStyle!);
//               },
//               child: const Text('Generate'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _generateAndCropImage(String userPrompt, String selectedStyle) async {
//     if (userPrompt.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a prompt')),
//       );
//       return;
//     }
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(child: CircularProgressIndicator()),
//     );
//
//     try {
//       final generatedFile = await generateAIImage(userPrompt, selectedStyle);
//       Navigator.pop(context);
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: generatedFile.path,
//         aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
//       );
//       if (croppedFile != null && mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomeScreen(fabricFile: File(croppedFile.path)),
//           ),
//         );
//       }
//     } catch (e) {
//       Navigator.pop(context);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error generating image: $e')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.blue.shade400,
//                   Colors.purple.shade600,
//                 ],
//               ),
//             ),
//           ),
//           CarouselSlider(
//             options: CarouselOptions(
//               height: MediaQuery.of(context).size.height,
//               autoPlay: true,
//               enlargeCenterPage: true,
//               viewportFraction: 1.0,
//               autoPlayCurve: Curves.easeInOut,
//               autoPlayAnimationDuration: const Duration(milliseconds: 1000),
//             ),
//             items: imagePaths.map((path) {
//               return Transform(
//                 transform: Matrix4.identity()
//                   ..setEntry(3, 2, 0.001)
//                   ..rotateY(0.05),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage(path),
//                       fit: BoxFit.cover,
//                       colorFilter: ColorFilter.mode(
//                         Colors.black.withOpacity(0.2),
//                         BlendMode.dstATop,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//           Positioned(
//             top: 50,
//             left: 0,
//             right: 0,
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: Center(
//                   child: ShaderMask(
//                     shaderCallback: (bounds) => const LinearGradient(
//                       colors: [Colors.pink, Colors.blue],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ).createShader(bounds),
//                     child: const Text(
//                       'FabricVision',
//                       style: TextStyle(
//                         fontSize: 48,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 50,
//             left: 0,
//             right: 0,
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Wrap(
//                 spacing: 20.0,
//                 runSpacing: 10.0,
//                 alignment: WrapAlignment.center,
//                 children: [
//                   _buildButton(
//                     icon: Icons.photo_library,
//                     label: 'Gallery',
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                   ),
//                   _buildButton(
//                     icon: Icons.camera_alt,
//                     label: 'Camera',
//                     onPressed: () => _pickImage(ImageSource.camera),
//                   ),
//                   _buildButton(
//                     icon: Icons.auto_awesome,
//                     label: 'AI Gen',
//                     onPressed: () => _showPromptDialog(context),
//                   ),
//                   _buildButton(
//                     icon: Icons.recent_actors,
//                     label: 'Recents',
//                     onPressed: () async {
//                       final selectedPath = await Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => RecentsScreen()),
//                       );
//                       if (selectedPath != null) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => HomeScreen(fabricFile: File(selectedPath)),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Material(
//         elevation: 10,
//         shadowColor: Colors.black45,
//         borderRadius: BorderRadius.circular(50),
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(50),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.purple.shade700, Colors.blue.shade700],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(icon, color: Colors.white),
//                 const SizedBox(width: 10),
//                 Text(
//                   label,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }







import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'services/api_service.dart'; // Ensure this import points to your services.dart file
import 'screens/home_screen.dart'; // Replace with your actual HomeScreen import
import 'screens/recent_screen.dart'; // Replace with your actual RecentsScreen import
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  final File? fabricFile;
  const IntroScreen({super.key, this.fabricFile});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  final List<String> imagePaths = [
    'assets/slideshow/image1.jpg',
    'assets/slideshow/image2.jpg',
    'assets/slideshow/image3.jpg',
    'assets/slideshow/image4.jpg',
    'assets/slideshow/image5.jpg',
    'assets/slideshow/image6.jpg',
    'assets/slideshow/image7.jpg',
  ];

  late Animation<Offset> _slideAnimation;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimationHeading;
  late Animation<double> _scaleAnimationHeading;
  late Animation<double> _fadeAnimationSubheading;

  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );


    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Heading fade animation (0 to 50% of duration)
    _fadeAnimationHeading = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Heading scale animation (0 to 50% of duration)
    _scaleAnimationHeading = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Subheading fade animation (50% to 100% of duration)
    _fadeAnimationSubheading = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward(); // Start the animation
  }



  @override
  void dispose() {
    _animationController.dispose();
    _gradientController.dispose();
    _controller.dispose();
    super.dispose();
  }



  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Square crop
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (croppedFile != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(fabricFile: File(croppedFile.path)),
          ),
        );
      }
    }
  }

  Future<void> _showPromptDialog(BuildContext context) async {
    final TextEditingController promptController = TextEditingController();
    String? selectedStyle;
    List<String> selectedColors = [];

    // Helper function to map color names to Flutter Colors
    Color getColorFromName(String colorName) {
      switch (colorName.toLowerCase()) {
        case 'red': return Colors.red;
        case 'blue': return Colors.blue;
        case 'yellow': return Colors.yellow;
        case 'green': return Colors.green;
        case 'pink': return Colors.pink;
        case 'maroon': return Colors.red[900]!;
        case 'beige': return Colors.brown[100]!;
        case 'black': return Colors.black;
        case 'indigo': return Colors.indigo;
        case 'cream': return Colors.yellow[50]!;
        case 'turquoise': return Colors.teal;
        case 'orange': return Colors.orange;
        case 'mustard': return Colors.yellow[700]!;
        case 'gold': return Colors.amber;
        case 'purple': return Colors.purple;
        case 'white': return Colors.white;
        case 'brown': return Colors.brown;
        default: return Colors.grey;
      }
    }


    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Enter Your Prompt'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center, // Center all children horizontally
              children: [
                TextField(
                  controller: promptController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., A pattern or color',
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Select a Style:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 18,
                  runSpacing: 18,
                  children: stylePrompts.keys.map((style) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (selectedStyle == style) {
                                  selectedStyle = null;
                                  selectedColors.clear();
                                } else {
                                  selectedStyle = style;
                                  selectedColors.clear();
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: selectedStyle == style ? Colors.blue : null,
                            ),
                            child: Text(
                              style,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        if (selectedStyle == style) ...[
                          const SizedBox(height: 5),
                          Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: styleColors[style]!.map((color) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedColors.contains(color)) {
                                      selectedColors.remove(color);
                                    } else {
                                      selectedColors.add(color);
                                    }
                                  });
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: getColorFromName(color),
                                    border: Border.all(color: Colors.black),
                                    shape: BoxShape.circle,
                                  ),
                                  child: selectedColors.contains(color)
                                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    );
                  }).toList(),
                ),


              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedStyle == null && promptController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a style or \n Enter the prompt')),
                  );
                  return;
                }
                Navigator.pop(context);
                _generateAndCropImage(promptController.text, selectedStyle ?? " ", selectedColors);
              },
              child: const Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateAndCropImage(String userPrompt, String selectedStyle, List<String> selectedColors) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final generatedFile = await generateAIImage(userPrompt, selectedStyle, selectedColors);
      Navigator.pop(context);
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: generatedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (croppedFile != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(fabricFile: File(croppedFile.path)),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final headingStyle = GoogleFonts.montserrat(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: Colors.white, // Required for ShaderMask gradient
      letterSpacing: 2.0, // Adds a modern touch
    );

    final subheadingStyle = GoogleFonts.playpenSans(
      fontSize: 24,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(255, 250, 250, 250), // Required for ShaderMask gradient
    );
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 232, 235, 236),
                  const Color.fromARGB(255, 209, 201, 211),
                ],
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              autoPlayCurve: Curves.easeInOut,
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            ),
            items: imagePaths.map((path) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(0.05),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(path),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.dstATop,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          Positioned(
  top: MediaQuery.of(context).size.height * 0.35,
  left: 0,
  right: 0,
  child: SlideTransition(
    position: _slideAnimation,
    child: FadeTransition(
      opacity: _fadeAnimationHeading,
      child: ScaleTransition(
        scale: _scaleAnimationHeading,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🌈 GRADIENT + GLOW HEADING
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Color(0xFF6A11CB), // Royal purple
                          Color(0xFF2575FC), // Bright blue
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'FabricVision',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 22,
                              color: Colors.blueAccent.withOpacity(0.8),
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 18),

                    // ✨ Subheading
                    FadeTransition(
                      opacity: _fadeAnimationSubheading,
                      child: Text(
                        'Transform Your Fabric into Designer Outfits',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 37, 8, 202).withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ),
)
,
    Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Wrap(
                spacing: 20.0,
                runSpacing: 10.0,
                alignment: WrapAlignment.center,
                children: [
                  _buildButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  _buildButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  _buildButton(
                    icon: Icons.auto_awesome,
                    label: 'AI Gen',
                    onPressed: () => _showPromptDialog(context),
                  ),
                  _buildButton(
                    icon: Icons.recent_actors,
                    label: 'Recents',
                    onPressed: () async {
                      final selectedPath = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecentsScreen()),
                      );
                      if (selectedPath != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(fabricFile: File(selectedPath)),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Color(0xFF6A11CB), // Purple
            Color(0xFF2575FC), // Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.45),
            blurRadius: 18,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    ),
  );
}
}