# FabricVision — Transform Your Fabric into Designer Outfits

**Project:** FabricVision  
**Course:** ITCS / ITIS 6112: Software Systems Design & Implementation (Fall 2025)  
**Team:** Stack Masters  
**Team Members:** Sai Praneeth Reddy Kaithi, Shabareesh Lingala, Lalitha Kesaraju, Banvitha Balaji, Sai Ratan Maheshwaram

---

## Overview
FabricVision is a cross-platform Flutter application that lets users preview fabric patterns on outfit templates, generate AI-driven fabric designs from text prompts, and customize patterns with overlays, tile scale and color tints. The project's full documentation and details are in the project report. 

---

## Quick Setup & Run (Flutter)

> These steps assume you have Flutter and a suitable IDE installed. See *Software Requirements* in the report for full details. 

1. **Install Flutter**
   - Follow official instructions: https://flutter.dev/docs/get-started/install

2. **Clone / Download Project**
   - Download the project ZIP or clone the repo to your machine.
   - Repo Link : https://github.com/PraneethReddy15/Fabric_Vision

3. **Open project**
   - In terminal: `cd /path/to/fabricvision` (project root containing `pubspec.yaml`)

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Configure API keys (optional for AI features)**
   - If using Stability AI or other text→image services, add your API key to a secure config (do **not** commit keys).
   - Suggested: store in `.env` or platform-specific secure storage and read at runtime.

6. **Run on an emulator/device**
   ```bash
   flutter run
   ```
   - To run a web build: `flutter run -d chrome`
   - To build release APK: `flutter build apk`

---

## Local development (recommended)
- Use Android Studio, VS Code, or IntelliJ with Flutter plugin.
- Useful commands:
  - `flutter analyze` — static analysis
  - `flutter test` — run unit/widget tests
  - `flutter build apk` / `flutter build ios` — production builds

---

## Project Structure (concise)
- `android/` — Android platform configs  
- `ios/` — iOS platform configs  
- `lib/` — main app code  
  - `models/` — data models  
  - `screens/` — UI screens (Home, Main, Favorites, Recent)  
  - `services/` — API & image-processing services  
  - `utils/` — helper methods  
  - `widgets/` — reusable components  
- `assets/` — overlays, templates, sample images  
- `pubspec.yaml` — dependencies and assets

(Full directory description and rationale available in project report.) 

---

## Key Features
- Upload fabric images (gallery / camera) and crop for pattern extraction.
- AI-driven fabric generation from text prompts and style selection (Stability AI integration optional). 
- Overlay application to garment templates (male shirts, kurthis, trousers, etc.).
- Tile scale & color tint adjustments with live preview.
- Favorites and Recents management persisted locally (SharedPreferences + file system).
- Share/export designs via native share dialog.

---

## Dependencies (high level)
- Flutter SDK (3.0+ recommended)
- Dart (2.17+)
- `image_picker`, `image_cropper`, `shared_preferences`, `http`, `share_plus`, `path_provider` (see `pubspec.yaml` for exact versions). 

---

## How to use (user flow)
1. Launch app → Home screen.  
2. Upload or capture image, or generate via AI.  
3. Crop / adjust the fabric image.  
4. Choose overlay template and apply tile/scale and tint.  
5. Preview final design; save to Favorites or Recents; share if desired.  
(Steps and activity flow described in detail in the project report.) 

---

## Testing
- Unit tests for core utilities and models.  
- Widget tests for UI components.  
- Integration tests for end-to-end flows (image selection → apply → save).  
(Testing approach and results are in the project report.)

---

## Known limitations & future work
- 3D outfit simulation and AR try-on (future scope).
- Cloud sync & multi-device access.  
- Fabric material recognition (ML model) and marketplace integration.

---

## Contact / Team Roles
- Team Coordinator: Sai Praneeth Reddy Kaithi  
- Backend: Lalitha Kesaraju, Shabareesh Lingala  
- Frontend: Banvitha Balaji  
- Tester: Sai Ratan Maheshwaram

---

## Quick links (local)
- App entry: `lib/main.dart`  
- Assets: `assets/`  
- Run locally: `flutter run`

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
