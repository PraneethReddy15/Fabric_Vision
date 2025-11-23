import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Widgets
import '../widgets/dual_image_preview.dart'; // Ensure this widget exists
// Ensure this widget exists
import '../widgets/color_picker_widget.dart'; // Ensure this widget exists

// Services
import '../services/favorites_service.dart'; // Ensure this service exists
import '../services/api_service.dart';

// Models
import '../models/favorite_design.dart'; // Ensure this model exists

// Screens
import 'favorites_screen.dart'; // Ensure this screen exists
import 'recent_screen.dart';

/// HomeScreen: Main screen of the app where fabric images are displayed,
/// edited, AI-generated, and managed in favorites/recents.
class HomeScreen extends StatefulWidget {
  final File? fabricFile;

  const HomeScreen({super.key, this.fabricFile});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // ------------------------------
  // State Variables
  // ------------------------------
  File? _fabricFile;
  String _selectedOverlay = 'M_Shirt.png'; // Default overlay
  double _tileScale = 1.0;
  Color? _selectedColor;
  bool _isFavorite = false;
  FavoriteDesign? _currentFavorite;

  // Key for capturing preview image
  final _previewKey = GlobalKey<DualImagePreviewState>();

  // Services
  final FavoritesService _favoritesService = FavoritesService();

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Available Garments
  final List<Map<String, String>> _garmentTypes = [
    {'label': 'Male Shirt', 'asset': 'M_Shirt.png'},
    {'label': 'Female Shirt', 'asset': 'F_Shirt.png'},
    {'label': 'Trouser', 'asset': 'Trouser.png'},
    {'label': 'Suit', 'asset': 'Suit.png'},
    {'label': 'Female Kurthi', 'asset': 'F_kurthi.png'},
    {'label': 'Nehru Jacket', 'asset': 'Nehru_Jacket.png'},
    {'label': 'Female Dress', 'asset': 'F_Dress.png'},
  ];

  // ------------------------------
  // Initialization
  // ------------------------------
  @override
  void initState() {
    super.initState();
    _fabricFile = widget.fabricFile;

    // Save to recents on init
    if (_fabricFile != null) saveToRecents(_fabricFile!);

    // Fade animation for fabric preview
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ------------------------------
  // Helper & Async Functions
  // ------------------------------

  /// Pick and crop fabric image from Gallery/Camera
  Future<void> _pickFabricImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
        ],
      );
      if (croppedFile != null && mounted) {
        final newFile = File(croppedFile.path);
        setState(() {
          _fabricFile = newFile;
          _animationController.forward(from: 0);
        });
        await saveToRecents(newFile); // Save to Recents after updating
      }
    }
  }

  /// Show AI generation prompt dialog
  Future<void> _showPromptDialog(BuildContext context) async {
    final TextEditingController promptController = TextEditingController();
    String? selectedStyle;
    List<String> selectedColors = [];

    // Map color names to Flutter Colors
    Color getColorFromName(String colorName) {
      switch (colorName.toLowerCase()) {
        case 'red':
          return Colors.red;
        case 'blue':
          return Colors.blue;
        case 'yellow':
          return Colors.yellow;
        case 'green':
          return Colors.green;
        case 'pink':
          return Colors.pink;
        case 'maroon':
          return Colors.red[900]!;
        case 'beige':
          return Colors.brown[100]!;
        case 'black':
          return Colors.black;
        case 'indigo':
          return Colors.indigo;
        case 'cream':
          return Colors.yellow[50]!;
        case 'turquoise':
          return Colors.teal;
        case 'orange':
          return Colors.orange;
        case 'mustard':
          return Colors.yellow[700]!;
        case 'gold':
          return Colors.amber;
        case 'purple':
          return Colors.purple;
        case 'white':
          return Colors.white;
        case 'brown':
          return Colors.brown;
        default:
          return Colors.grey;
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Prompt Input
                TextField(
                  controller: promptController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., A pattern or color',
                  ),
                ),
                const SizedBox(height: 10),
                // Style Selection
                const Text(
                  'Select a Style:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
                              backgroundColor:
                                  selectedStyle == style ? Colors.blue : null,
                            ),
                            child: Text(
                              style,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        // Color selection for selected style
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
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
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
                if (selectedStyle == null &&
                    promptController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select a style or \n Enter the prompt',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
                _generateAndCropImage(
                  promptController.text,
                  selectedStyle ?? " ",
                  selectedColors,
                );
              },
              child: const Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }

  /// AI image generation and cropping
  Future<void> _generateAndCropImage(
    String userPrompt,
    String selectedStyle,
    List<String> selectedColors,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final generatedFile = await generateAIImage(
        userPrompt,
        selectedStyle,
        selectedColors,
      );
      Navigator.pop(context);
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: generatedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (croppedFile != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(fabricFile: File(croppedFile.path)),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating image: $e')));
      }
    }
  }

  /// Save selected fabric to Recents
  Future<void> saveToRecents(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'recent_${DateTime.now().millisecondsSinceEpoch}.png';
    final savedFile = await imageFile.copy('${appDir.path}/$fileName');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recents = prefs.getStringList('recents') ?? [];
    recents.insert(0, savedFile.path);

    if (recents.length > 20) {
      final oldPath = recents.removeLast();
      await File(oldPath).delete();
    }
    await prefs.setStringList('recents', recents);
  }

  /// Set overlay garment image
  void _setOverlayImage(String overlay) {
    setState(() {
      _selectedOverlay = overlay;
      _onDesignChanged();
    });
  }

  /// Toggle favorite status for current design
  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      if (_currentFavorite != null) {
        await _favoritesService.removeFavorite(_currentFavorite!);
        setState(() {
          _isFavorite = false;
          _currentFavorite = null;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Removed from Favorites')));
      }
    } else {
      if (_fabricFile != null) {
        final state = _previewKey.currentState;
        if (state != null) {
          final tempFile = await state.captureImage();
          if (tempFile != null) {
            final appDir = await getApplicationDocumentsDirectory();
            final thumbnailFileName =
                'thumbnail_${DateTime.now().millisecondsSinceEpoch}.png';
            final thumbnailPath = '${appDir.path}/$thumbnailFileName';
            await tempFile.copy(thumbnailPath);
            await tempFile.delete();

            String generateUniqueId() {
              return DateTime.now().millisecondsSinceEpoch.toString();
            }

            final favorite = FavoriteDesign(
              id: generateUniqueId(),
              fabricPath: _fabricFile!.path,
              overlayAsset: _selectedOverlay,
              thumbnailPath: thumbnailPath,
              tileScale: _tileScale,
              tintColor: _selectedColor,
            );
            await _favoritesService.saveFavorite(favorite);
            setState(() {
              _isFavorite = true;
              _currentFavorite = favorite;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved to Favorites!')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Select fabric first')));
      }
    }
  }

  /// Reset favorite status when design changes
  void _onDesignChanged() {
    if (_isFavorite) {
      setState(() {
        _isFavorite = false;
        _currentFavorite = null;
      });
    }
  }

  // ------------------------------
  // Main Build Method
  // ------------------------------
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // ------------------------------
      // AppBar
      // ------------------------------
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'FabricVision',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            color: Colors.white,
            tooltip: 'View Favorites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              ).then((selectedFavorite) {
                if (selectedFavorite != null &&
                    selectedFavorite is FavoriteDesign) {
                  setState(() {
                    _fabricFile = File(selectedFavorite.fabricPath);
                    _selectedOverlay = selectedFavorite.overlayAsset;
                    _tileScale = selectedFavorite.tileScale;
                    _selectedColor = selectedFavorite.tintColor;
                    _isFavorite = true;
                    _currentFavorite = selectedFavorite;
                    _animationController.forward(from: 0);
                  });
                }
              });
            },
          ),
        ],
      ),

      // ------------------------------
      // Body
      // ------------------------------
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.pink.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ------------------------------
              // Fabric Preview & Color Picker
              // ------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fabric Preview Section
                  Expanded(
                    flex: 2,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _fabricFile != null
                          ? _buildFabricPreview(screenSize)
                          : _buildEmptyPreview(screenSize),
                    ),
                  ),
                  // Color Picker Section
                  if (_fabricFile != null)
                    Expanded(
                      flex: 1,
                      child: _buildColorPickerSection(screenSize),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Tile Scale Slider
              _buildTileScaleSlider(screenSize),

              const SizedBox(height: 20),

              // Upload / Action Buttons
              _buildActionButtons(),

              const SizedBox(height: 20),

              // Overlay Garment Selector
              _buildOverlaySelector(),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // Widgets: Fabric Preview
  // ------------------------------
  Widget _buildFabricPreview(Size screenSize) {
    return Container(
      height: screenSize.height * 0.5,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          DualImagePreview(
            key: _previewKey,
            fabricFile: _fabricFile!,
            overlayAsset: _selectedOverlay,
            tileScale: _tileScale,
            tintColor: _selectedColor,
          ),
          // Favorite Button
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: _isFavorite ? Colors.red : Colors.grey,
                size: 30,
              ),
              tooltip: _isFavorite ? 'Remove Favorite' : 'Add to Favorites',
              onPressed: _toggleFavorite,
            ),
          ),
          // Enlarge Button
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.zoom_out_map, color: Colors.deepPurple),
              tooltip: 'Enlarge',
              onPressed: () {
                if (_fabricFile != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(
                        fabricFile: _fabricFile!,
                        overlayAsset: _selectedOverlay,
                        tileScale: _tileScale,
                        tintColor: _selectedColor,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          // Share Button
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.share, color: Colors.deepPurple),
              tooltip: 'Share Design',
              onPressed: () async {
                final state = _previewKey.currentState;
                if (state != null) {
                  final file = await state.captureImage();
                  if (file != null) {
                    await Share.shareFiles([file.path],
                        text: 'Check out my fabric design!');
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPreview(Size screenSize) {
    return Container(
      height: screenSize.height * 0.5,
      width: screenSize.width * 0.4,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Upload a fabric to start!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // Color Picker Section
  // ------------------------------
  Widget _buildColorPickerSection(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 45.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenSize.height * 0.45,
            child: ColorPicker(
              height: screenSize.height * 0.4,
              currentColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                  _onDesignChanged();
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
            ),
            onPressed: () {
              setState(() {
                _selectedColor = null; // Reset color
                _onDesignChanged();
              });
            },
            child: const Text(
              'Reset',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // Tile Scale Slider
  // ------------------------------
  Widget _buildTileScaleSlider(Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Tile Scale:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: screenSize.width * 0.6,
          child: Slider(
            value: _tileScale,
            min: 0.01,
            max: 5.0,
            divisions: 200,
            activeColor: Colors.deepPurple,
            onChanged: (value) {
              setState(() {
                _tileScale = value;
                _onDesignChanged();
              });
            },
            label: _tileScale.toStringAsFixed(2),
          ),
        ),
      ],
    );
  }

  // ------------------------------
  // Action Buttons (Gallery, Camera, AI, Recent)
  // ------------------------------
  Widget _buildActionButtons() {
    return Wrap(
      spacing: 20.0,
      runSpacing: 10.0,
      alignment: WrapAlignment.center,
      children: [
        _gradientButton(
          text: 'Gallery',
          onPressed: () => _pickFabricImage(ImageSource.gallery),
        ),
        _gradientButton(
          text: 'Camera',
          onPressed: () => _pickFabricImage(ImageSource.camera),
        ),
        _gradientButton(
          text: 'AI Gen',
          onPressed: () => _showPromptDialog(context),
        ),
        _gradientButton(
          text: 'Recent',
          onPressed: () async {
            final selectedPath = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecentsScreen(),
              ),
            );
            if (selectedPath != null) {
              setState(() {
                _fabricFile = File(selectedPath);
              });
            }
          },
        ),
      ],
    );
  }

  // ------------------------------
  // Overlay Garment Selector (Horizontal Scroll)
  // ------------------------------
  Widget _buildOverlaySelector() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _garmentTypes.length,
        itemBuilder: (context, index) {
          final garment = _garmentTypes[index];
          return GestureDetector(
            onTap: () => _setOverlayImage(garment['asset']!),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/${garment['asset']}',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    garment['label']!,
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------
  // Custom Gradient Button Widget
  // ------------------------------
  Widget _gradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.pink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ------------------------------
// FullScreenImage: Shows fabric design fullscreen
// ------------------------------
class FullScreenImage extends StatelessWidget {
  final File fabricFile;
  final String overlayAsset;
  final double tileScale;
  final Color? tintColor;

  const FullScreenImage({
    super.key,
    required this.fabricFile,
    required this.overlayAsset,
    required this.tileScale,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: DualImagePreview(
                fabricFile: fabricFile,
                overlayAsset: overlayAsset,
                tileScale: tileScale,
                tintColor: tintColor,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
