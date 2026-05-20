# Event Ticket App

Minimal Flutter client for the interview project: browse events and purchase multiple ticket types (VIP, General Admission, etc.). Pairs with the Laravel API in the sibling [`event-ticketing-backend`](../event-ticketing-backend/) directory.

## Core functionality

- Browse a list of events
- View event details and available ticket types
- Purchase one or more ticket types in a single order
- View purchased tickets under **My Tickets** (with QR codes)

Payment is **simulated on the backend** — `POST /purchase` validates stock, creates tickets, and returns immediately with `payment_simulated: true`. No payment gateway.

## Stack

Toolchain: **Dart ^3.10** / **Flutter ≥3.38** (see `pubspec.yaml` `environment`). Resolved versions below are from **`pubspec.lock`**.

- **Flutter** (SDK) + **flutter_riverpod** **3.3.1** (**riverpod** **3.2.1**) + **go_router** **17.2.3**
- **dio** **5.9.2** for REST API calls
- **flutter_secure_storage** **10.2.0** for JWT and cached tickets
- **flutter_screenutil** **5.9.3** for responsive layout
- **freezed** **3.2.3** / **freezed_annotation** **3.1.0** for models (dev: **build_runner** **2.15.0**, **json_serializable** **6.11.2**). `freezed` is capped below **3.2.5** so codegen stays compatible with **flutter_test** on current stable Flutter.
- **flutter_svg** **2.3.0**, **cached_network_image** **3.4.1**, **intl** **0.20.2**, **connectivity_plus** **7.1.1**, **shared_preferences** **2.5.5**, **qr_flutter** **4.1.0**

`StateNotifier` providers use `import 'package:flutter_riverpod/legacy.dart';` (recommended bridge until migrated to `Notifier`).

Constraint ranges live in **`pubspec.yaml`**; run `flutter pub get` after changes to refresh the lockfile.

## Also included (minimal extras)

- Register / login (JWT)
- Light / dark theme
- Admin: create events + ticket types (guarded by role)
- List error states with retry on Events and My Tickets
- **Offline support** — cached events, tickets, and details; auto-refresh when back online

## Offline behavior

While online, the app caches events (including per-filter and a master list), categories, ticket lists, and opened event/ticket details in `shared_preferences`.

When offline:

- **Events** — shows cached list (filters applied client-side from master cache when needed)
- **Event detail** — works if the event was opened or listed while online
- **My Tickets** — shows last synced tickets and QR codes
- **Purchase / create event / cancel ticket** — blocked with a clear message

A banner at the top of the home screen indicates offline mode. Sign out clears cached data.

## Project structure

```
lib/
├── main.dart
├── app/app_router.dart
├── models/
├── providers/
├── services/
│   ├── api/
│   └── *_service.dart
└── ui/
    ├── common/
    ├── dialogs/
    ├── widgets/
    └── screens/
```

## Setup

1. Start the Laravel API (see [`event-ticketing-backend/README.md`](../event-ticketing-backend/README.md)).
2. Set the API base URL in `lib/services/api/api_constants.dart`.
   - iOS Simulator: `https://127.0.0.1:8000/api`
   - Android Emulator: `https://10.0.2.2:8000/api`
3. Install and run:

```bash
flutter pub get
flutter run
```

After changing Freezed/JSON models, regenerate code (if `build_runner` fails to compile builders in AOT mode on your machine, use JIT):

```bash
dart run build_runner build --force-jit
```

## API endpoints used

| Method | Path | Purpose |
|--------|------|---------|
| POST | `/auth/register` | Register |
| POST | `/auth/login` | Login |
| POST | `/auth/logout` | Logout |
| GET | `/auth/me` | Current user |
| POST | `/auth/refresh` | Refresh JWT (on app startup) |
| GET | `/events` | List events |
| GET | `/events/{id}` | Event detail |
| POST | `/events` | Create event (admin) |
| POST | `/events/{id}/ticket-types` | Add ticket type (admin) |
| POST | `/purchase` | Purchase tickets (simulated payment) |
| GET | `/my-tickets` | User tickets |
| GET | `/tickets/{id}` | Ticket detail |
| POST | `/tickets/{id}/cancel` | Cancel ticket |

## Tests

```bash
flutter test
flutter analyze
```
