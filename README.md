# Bookify - Book Rental Application

![Bookify Logo](app_logo.png)

A Flutter-based book rental application with user and admin roles, implementing clean architecture and BLoC state management.

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Technical Stack](#technical-stack)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

## Features

### Authentication System

- Clean architecture separation (domain, data, presentation)
- Complete user registration and login flows
- Role-based access control (admin/user)
- Form validation with error handling
- BLoC state management
- SQLite local storage for user data

### Admin Panel

- Modern, responsive UI with Material Design
- Full CRUD operations for book management
- Rental status management (view/update)
- Real-time updates using BookBloc events
- Exclusive role-based access

### User Features

- Book listing with search functionality
- Detailed book view
- Complete rental process flow
- User profile with rental history
- Account management

## Architecture

lib/
- core/ # Shared utilities and constants
- features/ # Feature modules
  - auth/ # Authentication
  - books/ # Book management
  - profile/ # User profile
  - admin/ # Admin features
- app/ # App configuration

**Clean Architecture Layers:**

1. **Presentation**: UI + BLoCs
2. **Domain**: Entities + Use Cases
3. **Data**: Repositories + Data Sources

## Technical Stack

| Category            | Technologies                          |
|---------------------|---------------------------------------|
| Framework           | Flutter 3.x (Null Safety)             |
| State Management    | BLoC Pattern                          |
| Routing            | GoRouter                              |
| Local Database      | SQLite                                |
| Dependency Injection| get_it                                |
| Testing            | flutter_test + mockito                |
| UI Components       | Custom Material Design System        |

## Installation

1. Clone the repository:
   

