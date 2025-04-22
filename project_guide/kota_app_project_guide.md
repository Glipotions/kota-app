# Kota App Project Guide

## Project Overview

Kota App is a B2B e-commerce mobile application built with Flutter that allows business customers to browse products, place orders, and manage their accounts. The app is designed to serve multiple companies with customizable themes and configurations.

## Project Structure

The project follows a feature-first architecture with clean architecture principles (presentation, domain, data layers) and uses GetX for state management and dependency injection.

### Main Directories

- **apps/kota_app/lib/**
  - **companies/**: Contains company-specific configurations and entry points
  - **development/**: Development and preview configurations
  - **features/**: Feature modules organized by functionality
  - **product/**: Shared components, utilities, and business logic
  - **resources/**: Shared resources across the app

### Key Features

1. **Authentication**
   - Login/Register/Forgot Password
   - Session management
   - Role-based access control

2. **Product Management**
   - Product browsing and searching
   - Product categories
   - Product details with variants (size, color)
   - Filtering and sorting

3. **Cart & Orders**
   - Shopping cart management
   - Order creation
   - Order history
   - Order details

4. **Account Management**
   - User profile
   - Current account information
   - Transaction history
   - Sales invoice details

5. **Multi-company Support**
   - Company-specific themes and configurations
   - White-label support

## Technical Architecture

### Navigation

The app uses Go Router for navigation with a structured routing system:
- Initial routes (splash screen)
- Auth routes (login, register, forgot password)
- Bottom navigation routes (products, cart, profile)
- Sub-routes (product details, order history, etc.)

### State Management

- **GetX**: Used for reactive state management and dependency injection
- **Controllers**: Each feature has its own controller that extends BaseControllerInterface
- **Models**: Data models for API requests and responses

### Theming

- Supports light and dark modes
- Company-specific theming with customizable colors
- Consistent design system with reusable components

### API Integration

- RESTful API integration using Dio
- Structured repositories for different API endpoints
- Error handling and response parsing

### Localization

- Multi-language support (TR, EN, AR, RU)
- Localized strings and formatting

## Development Workflow

### Environment Configuration

The app supports different environments:
- Development: For testing and development
- Production: For release builds

Each environment can be configured with different API endpoints and settings.

### Company Configuration

The app supports multiple companies with different configurations:
- Company-specific themes
- Company-specific API endpoints
- Company-specific assets

### Build Commands

Example build commands:
```bash
# Development build
flutter run --flavor development lib/main_development.dart

# Production build
flutter run --flavor product lib/main_production.dart

# Company-specific build
flutter run --flavor product lib/companies/company1/main_production.dart
```

## Key Components

### Session Handler

Manages user authentication state and session information.

### Cart Controller

Manages the shopping cart, including adding/removing products and checkout.

### Routing Manager

Handles navigation and routing throughout the app.

### Theme Manager

Manages theme settings and provides theme data to the app.

## Data Flow

1. User authenticates via login or register
2. Session is established and stored
3. User can browse products, add to cart, and place orders
4. Orders and transactions are stored and can be viewed in history

## Dependencies

Key dependencies include:
- GetX for state management
- Go Router for navigation
- Dio for API requests
- Shared Preferences for local storage
- Flutter Local Notifications for notifications
