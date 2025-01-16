# GitHub Users App - Documentation

## Overview

This app fetches a list of GitHub users and displays their details when tapped. The app uses **Clean Architecture** principles, which promote separation of concerns, modularity, and testability. The app is written using **SwiftUI** and **Async/Await** for asynchronous operations.

### Core Features

1. **User List View**: Displays a list of GitHub users.
2. **User Detail View**: Displays detailed information about a user when tapped.
3. **Router/Coordinator**: Manages navigation between the list and detail views.

## Architecture

The app follows **Clean Architecture**, which separates concerns into distinct layers:

- **Presentation Layer**: Contains SwiftUI views and view models.
- **Domain Layer**: Contains use cases and business logic.
- **Data Layer**: Manages data fetching and repositories.

### Layers in the App

1. **Presentation Layer**
    - SwiftUI views and view models.
    - Responsible for displaying the UI and reacting to state changes.
    - The `UserListView` and `UserDetailView` represent the UI components.
2. **Domain Layer**
    - Contains **use cases** which encapsulate the business logic.
    - The `UserUseCase` are the core use case.
3. **Data Layer**
    - Responsible for data fetching and storage.
    - The `UserRepository` handles network requests to GitHub API.

---

## Folder Structure

```
plaintext
Copy code
GitHubUsersApp
│
├── Models
│   ├── User.swift
│   └── UserDetail.swift
│
├── UseCases
│   ├── UsersUseCase.swift
│
├── Repositories
│   └── UserRepository.swift
│
├── ViewModels
│   ├── UserListViewModel.swift
│   └── UserDetailViewModel.swift
│
├── Views
│   ├── UserListView.swift
│   └── UserDetailView.swift
│
├── Routers
│   └── UserRouter.swift
│
└── Resources
    └── (Any assets like images, etc.)

```

---

## Data Flow

The data flow in the app follows these steps:

1. **User List Fetching**:
    - The `UserListViewModel` calls the `FetchUseUseCase` to fetch users.
    - The `FetchUsersUseCase` calls the `UserRepository` to fetch data from the GitHub API.
2. **User Detail Fetching**:
    - When a user is tapped on the list, the `UserRouter` triggers navigation to the `UserDetailView`.
    - The `UserDetailViewModel` then calls the `FetchUserDetailUseCase` to get detailed information about the user.
3. **Navigation**:
    - The `UserRouter` manages navigation between the `UserListView` and `UserDetailView` via a shared state (`selectedUserLogin`).
    - The `UserRouter` is injected into views via environment objects, decoupling navigation logic from the views.

---

## Diagrams

### 1. **Data Flow Diagram**

This diagram shows the flow of data through the application when a user is fetched from the API and displayed in the UI:

![image.png](Untitled%2017d2bbf5797180a1b24de0f96754b0dc/image.png)

---

## Router/Coordinator Explanation

In Clean Architecture, the **Router** (or **Coordinator**) is responsible for managing the flow of navigation between views, decoupling the presentation layer from the navigation logic. It does this by maintaining a navigation state and allowing the views to respond to changes in that state.

---

## Summary

The **GitHub Users App** uses Clean Architecture to separate concerns into distinct layers: Presentation, Domain, and Data. Each layer has its own responsibilities:

- **Presentation Layer** (SwiftUI Views & ViewModels) displays data and reacts to user input.
- **Domain Layer** (Use Cases) encapsulates the business logic of fetching users and their details.
- **Data Layer** (Repositories) handles network requests to the GitHub API.

The **Router** is responsible for managing navigation, decoupling the view logic from the navigation flow. By following these principles, the app remains modular, testable, and scalable.

---

## Future Improvements

- **Error Handling**: Currently, errors are printed to the console. Implementing user-friendly error handling (e.g., showing error messages in the UI) is a future enhancement.
- **Persistence Layer**: Adding a persistence layer to store fetched user data would improve performance and allow offline functionality.
- **Unit Testing**: Add more unit tests to ensure each layer is functioning as expected.
