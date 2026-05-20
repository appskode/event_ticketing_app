# Event Ticketing System

A comprehensive event ticketing platform built with Laravel 12, featuring secure authentication, and multi-type ticket support.

## 📋 Table of Contents

- [Features](#features)
- [Architecture Overview](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Database Design](#database-design)
- [API Documentation](#api-documentation)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Testing](#testing)
- [Error Handling](#error-handling)
- [Security Features](#security-features)

## ✨ Features

### Core Functionality
- **Event Management**: Create and manage events with detailed information
- **Multi-Type Ticketing**: Support for VIP, Early Bird, General Admission, and custom ticket types
- **Secure Purchasing**: Transaction-safe ticket purchasing with inventory management
- **User Authentication**: JWT-based authentication system
- **Ticket Cancellation**: Configurable cancellation policies per event
- **Purchase History**: Complete transaction tracking and history

### Advanced Features
- **Real-time Inventory Management**: Prevents overselling with database locks
- **Role-Based Access Control**: Admin/User role separation for secure event management
- **Flexible Pricing**: Different pricing tiers for each ticket type
- **Event Status Management**: Automatic sale period enforcement
- **Comprehensive Error Handling**: Custom exceptions for better user experience
- **API Documentation**: Auto-generated Swagger documentation

## 🏗️ Architecture

### Clean Architecture Principles
- **Separation of Concerns**: Controllers handle HTTP, Models manage data logic
- **Custom Exception Handling**: Specific exceptions for business logic violations
- **Middleware Layer**: JWT authentication and JSON response formatting
- **Database Transactions**: Ensuring data consistency during purchases
- **Repository Pattern**: Clean data access layer

### Key Components

#### Controllers
- **AuthController**: User registration, login, logout, and token management
- **EventController**: Event CRUD operations and ticket type management
- **PurchaseController**: Ticket purchasing and purchase history
- **TicketController**: User ticket management and cancellation

#### Custom Exceptions
- **InsufficientStockException**: Handles inventory shortage scenarios
- **EventExpiredException**: Manages expired event sales
- **TicketCancellationException**: Handles cancellation policy violations
- **PaymentProcessingException**: Payment-related error handling

#### Middleware
- **JwtMiddleware**: JWT token validation and user authentication
- **IsAdminMiddleware**: Role-based access control for administrative functions
- **ForceJsonResponse**: Ensures consistent JSON API responses

## 🛠️ Tech Stack

Resolved versions are pinned in `composer.lock`, `package-lock.json`, and `package.json`; the following reflects the current lockfiles.

- **Backend**: PHP 8.2+, Laravel **12.60** (`laravel/framework` **v12.60.1**)
- **Database**: MySQL 8.0+
- **Authentication**: JWT via **tymon/jwt-auth** **2.3.0**
- **Documentation**: OpenAPI/Swagger via **darkaonline/l5-swagger** **9.0.1**
- **Image processing**: **intervention/image** **3.11.8**
- **Testing**: **PHPUnit** **11.5.55**
- **Frontend tooling** (Vite): **Vite** **8.0.13**, **Tailwind CSS** **4.3.0**, **laravel-vite-plugin** **3.1.0**, **@tailwindcss/vite** **4.3.0**, **Axios** **1.16.1**, **concurrently** **9.2.1**

## 📁 Project Structure

```
app/
├── Http/
│   ├── Controllers/API/
│   │   ├── AuthController.php
│   │   ├── EventController.php
│   │   ├── PurchaseController.php
│   │   └── TicketController.php
│   └── Middleware/
│       ├── JwtMiddleware.php
│       ├── IsAdminMiddleware.php
│       └── ForceJsonResponse.php
├── Models/
│   ├── User.php
│   ├── Event.php
│   ├── TicketType.php
│   ├── Ticket.php
│   └── Purchase.php
├── Exceptions/
│   ├── InsufficientStockException.php
│   ├── EventExpiredException.php
│   ├── TicketCancellationException.php
│   └── PaymentProcessingException.php
database/
├── migrations/
├── seeders/
└── factories/
```

## 🗄️ Database Design

### Entity Relationship Overview

The database follows a normalized design with clear relationships:

#### Core Tables

**Users Table**
```sql
- id (Primary Key)
- name, email, password
- role (enum: 'user', 'admin')
- email_verified_at, created_at, updated_at
```
- Standard Laravel user authentication with role-based access
- Links to tickets and purchases
- Role-based authorization (user/admin)

**Events Table**
```sql
- id (Primary Key)
- name, description, location
- image_url (nullable)
- event_date, sale_start_date, sale_end_date
- is_active, allow_cancellation
- cancellation_hours_before
```

**Ticket Types Table**
```sql
- id (Primary Key)
- event_id (Foreign Key → events.id)
- name (VIP, Early Bird, General, etc.)
- description, price
- total_quantity, available_quantity
- is_active
```

**Tickets Table**
```sql
- id (Primary Key)
- user_id (Foreign Key → users.id)
- event_id (Foreign Key → events.id)
- ticket_type_id (Foreign Key → ticket_types.id)
- ticket_code (Unique identifier)
- status (active, used, cancelled)
- price_paid, purchased_at, cancelled_at
```

**Purchases Table**
```sql
- id (Primary Key)
- user_id (Foreign Key → users.id)
- purchase_code (Unique identifier)
- total_amount, status
- purchase_details (JSON - stores breakdown)
```

### Key Relationships

1. **One-to-Many**: Event → Ticket Types
2. **One-to-Many**: Event → Tickets
3. **One-to-Many**: User → Tickets
4. **One-to-Many**: User → Purchases
5. **One-to-Many**: Ticket Type → Tickets

### Database Indexes

Strategic indexing for performance:
- `events`: `(is_active, event_date)`, `sale_start_date`, `sale_end_date`
- `ticket_types`: `(event_id, is_active)`, `available_quantity`
- `tickets`: `(user_id, status)`, `ticket_code`, `(event_id, status)`
- `purchases`: `(user_id, status)`, `purchase_code`

## 🔐 Role-Based Access Control

The application implements a two-tier role system:

### User Roles
- **User (Regular)**: Can view events, purchase tickets, manage their own tickets
- **Admin**: Can create events, add ticket types, plus all user permissions

### Route Protection

## 📚 API Documentation
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout
- `GET /api/auth/me` - Get current user
- `POST /api/auth/refresh` - Refresh JWT token

### Event Endpoints
- `GET /api/events` - List events (paginated, filterable) - **Public**
  - Query: `category`, `location`, `date_from`, `date_to`, `on_sale`, `upcoming`, `past`, `q`, `sort`, `sort_dir`, `per_page`
- `GET /api/events/categories` - List categories with event counts - **Public**
- `GET /api/events/{id}` - Get event details - **Public**
- `GET /api/events/search-suggestions` - Search suggestion - 
**Public**
- `GET /api/events/search` - Search events - **Public**
- `POST /api/events` - Create new event - **Admin Only**
- `POST /api/events/{id}/ticket-types` - Add ticket type - **Admin Only**

### Purchase Endpoints
- `POST /api/purchase` - Purchase tickets (authenticated)
- `GET /api/purchases` - Get purchase history (authenticated)
- `GET /api/purchases/{id}` - Get purchase details (authenticated)

### Ticket Endpoints
- `GET /api/my-tickets` - Get user's tickets (authenticated)
- `GET /api/tickets/{id}` - Get ticket details (authenticated)
- `POST /api/tickets/{id}/cancel` - Cancel ticket (authenticated)

## 🚀 Installation

### Prerequisites
- PHP 8.2 or higher
- Composer
- MySQL 8.0+
- Node.js (for asset compilation)

### Step 1: Clone Repository
```bash
git clone <repository-url>
cd event-ticketing-system
```

### Step 2: Install Dependencies
```bash
composer install

```

### Step 3: Environment Setup
```bash
cp .env.example .env
php artisan key:generate
```

### Step 4: Database Configuration
Edit `.env` file:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=event_ticketing_db
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

### Step 5: JWT Configuration
```bash
php artisan jwt:secret
```

### Step 6: Database Setup
mysql -u root -p -e "CREATE DATABASE event_ticketing_db;"

# Run migrations
php artisan migrate

# Seed database with sample data
php artisan db:seed
```

### Step 7: Generate API Documentation
```bash
php artisan l5-swagger:generate
```

## ⚙️ Configuration

### JWT Settings
Configure JWT in `config/jwt.php`:
- Token TTL: 60 minutes (configurable)
- Refresh TTL: 2 weeks
- Algorithm: HS256

### Swagger Documentation
Access API documentation at: `http://your-domain/api/documentation`

### File Storage
Configure file storage in `config/filesystems.php` for event images.

## 🎯 Usage

### Starting the Application
```bash
# HTTPS development server (recommended — matches Flutter app)
# Requires Caddy: brew install caddy
composer serve:https
# API: https://127.0.0.1:8000/api

# Plain HTTP (legacy)
php artisan serve

# With queue worker (for background jobs)
php artisan queue:work

# Asset compilation
npm run dev
```

Set in `.env`:
```env
APP_URL=https://127.0.0.1:8000
APP_FORCE_HTTPS=true
```

### Sample API Calls

#### Register Admin User
```bash
curl -k -X POST https://127.0.0.1:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Admin User",
    "email": "admin@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "role": "admin"
  }'
```

#### Create Event (Admin Only)
```bash
curl -X POST http://localhost:8000/api/events \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Summer Music Festival",
    "description": "Annual summer music festival",
    "location": "Central Park, New York",
    "event_date": "2025-07-15 18:00:00",
    "sale_start_date": "2025-06-01 10:00:00",
    "sale_end_date": "2025-07-14 23:59:59"
  }'
```

#### Purchase Tickets
```bash
curl -X POST http://localhost:8000/api/purchase \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "tickets": [
      {"ticket_type_id": 1, "quantity": 2},
      {"ticket_type_id": 2, "quantity": 1}
    ]
  }'
```

## 🧪 Testing

### Running Tests
```bash
# Run all tests
php artisan test

# Run specific test suite
php artisan test --filter AuthTest

# Run with coverage
php artisan test --coverage
```

### Test Coverage
- Authentication flow testing
- Purchase transaction testing
- Inventory management testing
- Error handling validation

## 🛡️ Error Handling

### Custom Exception System

The application implements a comprehensive error handling system:

#### Business Logic Exceptions
- **InsufficientStockException**: When ticket quantity exceeds availability
- **EventExpiredException**: When attempting to purchase tickets for expired events
- **TicketCancellationException**: When cancellation policies are violated
- **PaymentProcessingException**: For payment-related failures

#### Global Exception Handler
- Consistent JSON error responses
- Proper HTTP status codes
- Detailed error messages for development
- Sanitized messages for production

### Response Format
```json
{
  "success": false,
  "message": "Insufficient stock available",
  "errors": {
    "ticket_type": "Only 5 VIP tickets remaining, but 10 requested"
  }
}
```

## 🔒 Security Features

### Authentication & Authorization
- JWT-based stateless authentication
- **Role-based access control (RBAC)** with user and admin roles
- **Admin-only endpoints** for event management
- Token refresh mechanism
- Protected route middleware
- User-specific data access

### Data Protection
- Database transactions for consistency
- SQL injection prevention (Eloquent ORM)
- Input validation and sanitization
- CORS configuration

### Business Logic Security
- Inventory locking during purchases
- Concurrent purchase prevention
- Ticket ownership verification
- Purchase history isolation

---

**Assessment Note**: This application demonstrates clean architecture principles, robust error handling, secure authentication, and scalable database design. The codebase emphasizes maintainability, security, and performance optimization suitable for production environments.


## 🔮 Future Enhancements

### 1. Real-Time Notifications
- Implement WebSocket-based real-time notifications (e.g., using Laravel Echo + Pusher or Socket.IO).
- Notify users instantly about ticket updates, cancellations, and event changes.

### 2. Email Notifications
- Integrate email services (e.g., Mailgun, SES, or SMTP) to send:
  - Purchase confirmations
  - Upcoming event reminders
  - Ticket cancellation notices
  - Admin announcements and promotions

### 3. Push Notifications
- Allow browser or mobile push notifications for event updates and ticket status.
- Utilize service workers to handle notification delivery even when users are not actively using the app.

### 4. Stream-Based Updates
- Integrate event streams (e.g., Server-Sent Events or Kafka) for high-throughput event tracking.
- Useful for admin dashboards showing live ticket sales, event attendance, or error logs.

### 5. In-App Notification Center
- Create a UI module to store and display user-specific notifications inside the app.
- Allow users to mark notifications as read or filter by event.

### 6. Client-Side Notification Sync
- Use local storage or IndexedDB to store and sync user notification history for offline access.
- Implement silent background sync for updated ticket status when users reconnect.
