# Store App

Store App is a Flutter e-commerce demo for browsing a clothing catalog, searching products, and managing a shopping cart. The code separates presentation, product models, and API services, with a singleton `CartManager` providing reactive cart state through `ChangeNotifier`.

## Features

- Dynamic product catalog loaded from the DummyJSON products API.
- Product search, details, and demo add/update product flows.
- Firebase Authentication sign-in and registration.
- Interactive cart with quantity increment/decrement, automatic removal at zero, and quantity-aware totals.
- Centralized cart state in `CartManager`; Flutter `AnimatedBuilder` updates the cart screen and cart badge when state changes.
- Reusable UI components separated from data models, API helpers, and service logic.

## Architecture and Tech Stack

- **Flutter and Dart** for the cross-platform application.
- **Models** in `lib/models` represent catalog products and cart entries.
- **Services and helpers** in `lib/services` and `lib/helper` handle API requests, response parsing, and product operations.
- **Pages and widgets** in `lib/pages` and `lib/widgets` contain screens and reusable UI components.
- **Cart state** is managed by the `CartManager` singleton in `lib/cart/cart_manager.dart`, using `ChangeNotifier` and `AnimatedBuilder` for reactive updates.
- **Firebase Authentication** handles account registration and sign-in.

The project follows clean architecture principles by keeping UI, data models, and application/service logic in separate areas of the codebase.

## Project Structure

```text
lib/
├── cart/        # Singleton cart state and quantity operations
├── constants/   # Shared authentication and UI constants
├── helper/      # API client, endpoint configuration, response parsing
├── models/      # Product, rating, and cart item models
├── pages/       # App screens and navigation destinations
├── services/    # Catalog and product API operations
└── widgets/     # Reusable presentation components
android/         # Android platform project
ios/             # iOS platform project
macos/           # macOS platform project
web/             # Web platform project
linux/           # Linux platform project
windows/         # Windows platform project
test/            # Flutter tests
```

## Getting Started

### Prerequisites

- Flutter SDK compatible with the Dart constraint in `pubspec.yaml`.
- A configured Firebase project with Email/Password Authentication enabled.
- FlutterFire CLI for generating local Firebase options.

### Run locally

1. Clone the repository and enter the project directory:

   ```sh
   git clone <repository-url>
   cd store_app
   ```

2. Configure Firebase for your app and platforms. Local Firebase configuration files are intentionally excluded from Git:

   ```sh
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   This generates `lib/firebase_options.dart` and the platform-specific Firebase configuration needed to initialize the app.

3. Fetch dependencies and launch the app:

   ```sh
   flutter pub get
   flutter run
   ```

The catalog uses DummyJSON as a demo backend. Product create/update operations are demonstration API calls and may not persist as a production store would.
