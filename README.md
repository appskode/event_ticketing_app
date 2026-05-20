# Event Ticketing System

A full-stack event ticketing platform: a **Laravel 12 REST API** (`event-ticketing-backend`) and a **Flutter mobile client** (`event_ticketing_app`). Users browse events, purchase multiple ticket types in one order, and manage tickets with QR codes. Admins create events and ticket types. Payment is **simulated on the backend** — purchases validate stock inside a database transaction and complete immediately.

## Repository layout

| Directory | Description |
|-----------|-------------|
| [`event-ticketing-backend/`](event-ticketing-backend/) | Laravel API (JWT auth, events, purchases, tickets) |
| [`event_ticketing_app/`](event_ticketing_app/) | Flutter app (Riverpod, go_router, offline cache) |

Deeper docs: [backend README](event-ticketing-backend/README.md) · [mobile README](event_ticketing_app/README.md)

## Features

### Backend
- JWT authentication with register, login, logout, `me`, and token refresh
- Public event listing, search, suggestions, and categories
- Admin-only event and ticket-type creation (role-based middleware)
- Multi-type tickets per event (VIP, Early Bird, General, custom names)
- Transaction-safe purchasing with row locks (`lockForUpdate`) to prevent overselling
- Configurable per-event cancellation rules
- Purchase history and ticket lifecycle (`active`, `used`, `cancelled`)
- Custom business exceptions and consistent JSON API error responses
- OpenAPI/Swagger docs via `l5-swagger`

### Mobile app
- Browse events with filters (category, date range) and pagination
- Event detail, multi-ticket purchase flow, and purchase confirmation
- **My Tickets** with QR codes for venue check-in (display only — no in-app scanner)
- Register / login with JWT stored in `flutter_secure_storage`
- Admin screens to create events and ticket types (when user role is `admin`)
- Light / dark theme (follows system)
- **Offline read access** — cached events, categories, and tickets in `shared_preferences`; purchase, cancel, and admin actions blocked offline with a banner when disconnected

## Architecture

```
┌─────────────────────────┐     HTTPS/REST      ┌─────────────────────────┐
│  event_ticketing_app    │ ◄─────────────────► │ event-ticketing-backend │
│  (Flutter + Riverpod)   │                     │ (Laravel 12 + JWT)      │
│                         │                     │                         │
│ • go_router             │                     │ • API controllers       │
│ • Services + providers  │                     │ • Service layer         │
│ • Offline cache         │                     │ • DB transactions       │
│ • QR display (qr_flutter)│                    │ • Swagger at /api/documentation │
└─────────────────────────┘                     └───────────┬─────────────┘
                                                            │
                                                            ▼
                                                ┌─────────────────────────┐
                                                │ SQLite (default) or     │
                                                │ MySQL 8.0+              │
                                                └─────────────────────────┘
```

**Backend layering:** HTTP controllers delegate to `app/Services/` (`AuthService`, `EventService`, `PurchaseService`, `TicketService`). Middleware: `JwtMiddleware`, `IsAdminMiddleware`, and `ForceJsonResponse` on all API routes.

**Mobile layering:** `models/` (Freezed + JSON) → `services/` (Dio API clients) → `providers/` (Riverpod) → `ui/screens/`.

## Tech stack

| Layer | Technologies |
|-------|----------------|
| API | PHP 8.2+, Laravel **12.60** (`laravel/framework` **v12.60.1** in `composer.lock`), **tymon/jwt-auth** **2.3.0**, **darkaonline/l5-swagger** **9.0.1**, **intervention/image** **3.11.8** |
| API assets | **Vite** **8.0.13**, **Tailwind CSS** **4.3.0**, **laravel-vite-plugin** **3.1.0**, **Axios** **1.16.1** (`package-lock.json`) |
| Database | SQLite by default (`.env.example`); MySQL 8.0+ supported |
| Mobile | Flutter **≥3.38**, Dart **^3.10**; **flutter_riverpod** **3.3.1** (**riverpod** **3.2.1**), **go_router** **17.2.3**, **dio** **5.9.2**, **freezed** **3.2.3** / **freezed_annotation** **3.1.0**, **flutter_secure_storage** **10.2.0**, **flutter_svg** **2.3.0**, **qr_flutter** **4.1.0**, **connectivity_plus** **7.1.1**, **shared_preferences** **2.5.5** (`pubspec.lock`) |
| Tests | **PHPUnit** **11.5.55** (backend), `flutter test` (unit + widget tests in app) |

## Project structure

### Backend (`event-ticketing-backend/`)

```
app/
├── Http/
│   ├── Controllers/API/     # Auth, Event, Purchase, Ticket
│   └── Middleware/          # Jwt, IsAdmin, ForceJsonResponse
├── Models/                  # User, Event, TicketType, Ticket, Purchase
├── Services/                # Business logic
└── Exceptions/              # Stock, expiry, cancellation, payment
database/migrations|seeders|factories/
routes/api.php
```

### Mobile (`event_ticketing_app/lib/`)

```
app/           # go_router, page transitions
models/        # Event, Ticket, Purchase, User (Freezed)
providers/     # auth, events, tickets, connectivity, …
services/      # API client, auth, events, purchases, offline cache
ui/
├── common/    # theme, helpers
├── screens/   # auth, events, purchase, tickets, admin, home
└── widgets/
main.dart
```

## Getting started

### Prerequisites

- **Backend:** PHP 8.2+, Composer; optional [Caddy](https://caddyserver.com/) for local HTTPS (`brew install caddy`)
- **Mobile:** Flutter SDK **≥3.38**, Dart **^3.10** (see `event_ticketing_app/pubspec.yaml`), iOS Simulator or Android Emulator
- **Database:** SQLite works out of the box; use MySQL if you prefer (see backend `.env`)

### 1. Backend

```bash
cd event-ticketing-backend
composer install
cp .env.example .env
php artisan key:generate
php artisan jwt:secret
php artisan migrate
php artisan db:seed
php artisan l5-swagger:generate
```

**HTTPS (recommended — matches the Flutter app default):**

```bash
composer serve:https
# API: https://127.0.0.1:8000/api
# Swagger UI: https://127.0.0.1:8000/api/documentation
```

Plain HTTP alternative: `php artisan serve` (then update the app `baseUrl` to `http://127.0.0.1:8000/api`).

**MySQL (optional):** set in `.env`:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=event_ticketing_db
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

Then create the database and run `php artisan migrate` and `php artisan db:seed`.

### 2. Mobile app

```bash
cd event_ticketing_app
flutter pub get
```

Set the API base URL in [`lib/services/api/api_constants.dart`](event_ticketing_app/lib/services/api/api_constants.dart):

| Environment | `baseUrl` |
|-------------|-----------|
| iOS Simulator (HTTPS dev server) | `https://127.0.0.1:8000/api` |
| Android Emulator | `https://10.0.2.2:8000/api` |

In debug builds, the app trusts the local Caddy self-signed certificate (see `lib/services/api/dio_ssl.dart`).

```bash
flutter run
```

After seeding, you can sign in with:

| Role | Email | Password |
|------|-------|----------|
| User | `test1@example.com` | `password123` |
| Admin | `admin@example.com` | `admin123` |

## API overview

Base path: `/api`. Protected routes require `Authorization: Bearer <token>`.

### Authentication

| Method | Path | Access |
|--------|------|--------|
| POST | `/auth/register` | Public |
| POST | `/auth/login` | Public |
| POST | `/auth/logout` | JWT |
| GET | `/auth/me` | JWT |
| POST | `/auth/refresh` | JWT |

### Events

| Method | Path | Access |
|--------|------|--------|
| GET | `/events` | Public — supports `category`, `location`, `date_from`, `date_to`, `on_sale`, `upcoming`, `past`, `q`, `sort`, `sort_dir`, `per_page` |
| GET | `/events/categories` | Public |
| GET | `/events/{id}` | Public |
| GET | `/events/search-suggestions` | Public |
| GET | `/events/search` | Public |
| POST | `/events` | Admin |
| POST | `/events/{id}/ticket-types` | Admin |

### Purchases & tickets

| Method | Path | Access |
|--------|------|--------|
| POST | `/purchase` | JWT — simulated payment; response includes `payment_simulated: true` |
| GET | `/purchases` | JWT |
| GET | `/purchases/{id}` | JWT |
| GET | `/my-tickets` | JWT |
| GET | `/tickets/{id}` | JWT |
| POST | `/tickets/{id}/cancel` | JWT |

### Example success response

```json
{
  "success": true,
  "data": { },
  "message": "Events retrieved successfully"
}
```

### Example purchase body

```json
{
  "event_id": 1,
  "tickets": [
    { "ticket_type_id": 1, "quantity": 2 },
    { "ticket_type_id": 2, "quantity": 1 }
  ]
}
```

## Database schema (summary)

- **users** — `name`, `email`, `password`, `role` (`user` \| `admin`)
- **events** — details, `category`, dates, `is_active`, cancellation settings
- **ticket_types** — per-event types with `price`, `total_quantity`, `available_quantity`
- **purchases** — `purchase_code`, `total_amount`, `status`, `purchase_details` (JSON)
- **tickets** — `ticket_code`, `status`, `price_paid`, `purchase_id` (FK), timestamps

## Testing

**Backend:**

```bash
cd event-ticketing-backend
composer test
# or: php artisan test
```

**Mobile:**

```bash
cd event_ticketing_app
flutter test
flutter analyze
```

Existing app tests cover models, API client helpers, offline cache, and the splash screen widget. Backend includes Laravel example feature/unit tests as a starting point.

## Security notes

Implemented today:

- JWT authentication and admin-only routes via middleware
- Eloquent ORM and request validation
- `DB::transaction` + `lockForUpdate` on ticket types during purchase
- Per-user ticket and purchase access checks in services
- CORS middleware on API routes
- Secure token storage on device (`flutter_secure_storage`)

Not implemented (do not assume from older docs):

- Payment gateway integration (payments are simulated)
- API rate limiting on routes (beyond standard Laravel auth throttle config)
- Certificate pinning in production (debug-only trust for local HTTPS)
- Biometric login, app attestation, or admin audit logs
- QR code **scanning** in the mobile app (QR **display** only)

## Screenshots

<img width="320" alt="1" src="https://github.com/user-attachments/assets/e38843a6-5bff-4ac1-9635-db692a14bb79" />
<img width="320" alt="2" src="https://github.com/user-attachments/assets/8121fc34-e924-4c48-a845-0913d5f97ee9" />
<img width="320" alt="3" src="https://github.com/user-attachments/assets/62c82559-8455-499e-a542-37a8ba891d6a" />
<img width="320" alt="4" src="https://github.com/user-attachments/assets/29937086-b77b-42b5-9c5a-6888a8b1970d" />
<img width="320" alt="5" src="https://github.com/user-attachments/assets/03962a62-2079-4d93-b7d2-0751e09c8f70" />
<img width="320" alt="6" src="https://github.com/user-attachments/assets/40ff7034-8fc6-4ac2-90c2-f52b6f7fbf30" />
<img width="320" alt="7" src="https://github.com/user-attachments/assets/9b616755-c03b-4e82-9c97-e6fbd3c7a1b2" />
<img width="320" alt="8" src="https://github.com/user-attachments/assets/a65f3446-c380-425d-be6a-c2947b993366" />
<img width="320" alt="9" src="https://github.com/user-attachments/assets/cf42b65d-cc17-421a-84fc-ef34059804ee" />
<img width="320" alt="10" src="https://github.com/user-attachments/assets/69ce7710-be1a-4c2e-a38a-4d736676b865" />
<img width="320" alt="11" src="https://github.com/user-attachments/assets/c5d253a4-46bf-4189-939a-a2dfbbd2f739" />
<img width="320" alt="12" src="https://github.com/user-attachments/assets/33c56884-8a86-4108-81f5-a6f37d4c45c6" />

## License

MIT — see [`event-ticketing-backend/composer.json`](event-ticketing-backend/composer.json).
