# It's Urgent
![Static Badge](https://img.shields.io/badge/GSoC'24-8A2BE2) ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?s&logo=Flutter&logoColor=white) ![Firebase](https://img.shields.io/badge/Firebase-a08021?&logo=firebase&logoColor=ffcd34)

This is frontend repo for `It's Urgent` Project which is being developed in Flutter. 

**Note: This app is all ready working with real otps (10 sms/day free). Please do not abuse the otp verification as Firebase otp verification is on paid plan. (Send me DM on slack @0xharkirat & I will add your number for testing purpose with OTP 123456.**

[Accepted Proposal](https://github.com/0xharkirat/gsoc-proposal/blob/main/Copy%20of%20harkirat-singh-its-urgent-proposal-gsoc24.pdf)  
[Org's Project Idea here](https://ccextractor.org/public/gsoc/2024/itsurgent/)  
See Releases: [beta-v1.0](https://github.com/0xharkirat/its_urgent/releases/tag/beta-v1.0)  
Download apk from [here](https://github.com/0xharkirat/its_urgent/releases/download/beta-v1.0/app-release.apk)  
YouTube Demo [part 1](https://youtu.be/Ve58RqI_5is)  
YouTube Demo [part 2](https://youtu.be/3gKUTA-tHmE) (Watch on 1.25x speed)

## Backend
Backend repo can be found at https://github.com/0xharkirat/its_urgent_backend

![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/splash_screen.jpg)

## Table of Contents
- [Project Overview](#project-overview)
- [1. Introduction](#1-introduction)
- [2. Why Firebase?](#2-why-firebase)
   * [Firebase Features to be Used](#firebase-features-to-be-used)
   * [Pros and Cons of Firebase (Especially Firebase Cloud Messaging)](#pros-and-cons-of-firebase-especially-firebase-cloud-messaging)
      + [Pros](#pros)
      + [Cons](#cons)
   * [Why Not Use Alternatives to FCM?](#why-not-use-alternatives-to-fcm)
- [3. User Authentication & Management](#3-user-authentication--management)
   * [Implementation Overview](#implementation-overview)
      + [1. Firebase Phone Authentication:](#1-firebase-phone-authentication)
      + [2. Firestore Integration for User Data:](#2-firestore-integration-for-user-data)
      + [3. Phone Number Formatting and Validation](#3-phone-number-formatting-and-validation)
      + [4. OTP UI Implementation](#4-otp-ui-implementation)
      + [5. User Profile Image Storage](#5-user-profile-image-storage)
   * [Authentication Flow](#authentication-flow)
- [4. Notification Management](#4-notification-management)
   * [Contacts Management](#contacts-management)
      + [1. Reading Device Contacts](#1-reading-device-contacts)
      + [2. Fetching and Filtering Contacts](#2-fetching-and-filtering-contacts)
      + [3. Pull to Refresh & Manual Update](#3-pull-to-refresh--manual-update)
      + [4. Error Handling](#4-error-handling)
   * [Tab Functionality](#tab-functionality)
      + [1. App Contacts Tab](#1-app-contacts-tab)
      + [2. Non-App Contacts Tab](#2-non-app-contacts-tab)
   * [Notification Sending Flow](#notification-sending-flow)
      + [Flow Overview](#flow-overview)
      + [1. Triggering the Callable Function](#1-triggering-the-callable-function)
      + [2. Checking DND Status](#2-checking-dnd-status)
      + [3. Handling Notification Scenarios](#3-handling-notification-scenarios)
      + [4. On-Device Notification Handling](#4-on-device-notification-handling)
- [5. Permission Handling](#5-permission-handling)
   * [1. Accessing Device Contacts](#1-accessing-device-contacts)
   * [2. Notification Permissions](#2-notification-permissions)
   * [3. Adding App Notifications to Bypass DND](#3-adding-app-notifications-to-bypass-dnd)
- [6. State Management and Navigation](#6-state-management-and-navigation)
   * [State Management with Flutter Riverpod](#state-management-with-flutter-riverpod)
   * [Navigation with GoRouter](#navigation-with-gorouter)
   * [Popping Dialogs](#popping-dialogs)
   * [Automatically Refreshing the Router](#automatically-refreshing-the-router)
   * [Redirecting on Refresh with GoRouter](#redirecting-on-refresh-with-gorouter)
   * [Splash Screen Implementation](#splash-screen-implementation)
- [Future Features Ideas, Bug Fixes, Improvements, and Testing Plans](#future-features-ideas-bug-fixes-improvements-and-testing-plans)
   * [1. Future Feature Ideas](#1-future-feature-ideas)
   * [2. Bug Fixes](#2-bug-fixes)
   * [3. Code Refactoring](#3-code-refactoring)
   * [4. UI Improvements](#4-ui-improvements)
   * [5. Testing Plans](#5-testing-plans)
   * [6. iOS Implementation](#6-ios-implementation)
- [Project Structure](#project-structure)
- [Pub.dev packages currently being used:](#pubdev-packages-currently-being-used)

<!-- TOC end -->

## Project Overview
**Organisation**: CCExtractor Development  
**Mentor**: Akshat Tripathi (Slack: @Akshat Tripathi)  
**Tools/Tech Stack**:
- Frontend: Flutter
- Backend: Firebase

## 1. Introduction
It`s Urgent is a notification-based app that allows users to decide how urgent they want to notify others, bypassing standard Do-Not-Disturb (DND) mode when necessary. Unlike typical messaging apps, "It's Urgent" is built only for notifications, with the twist of user-controlled disruption based on challenges.

The idea is to allow the **Sender (User A)** to decide if they want to notify **recipient (User B)**, even when B is in DND mode. The recipient can set a challenge (like a question/answer, or password), and only if the sender solves it correctly will the notification trigger.

## 2. Why Firebase?
Firebase is the ideal backend solution for this project because it offers a simple, easy-to-set-up environment with out-of-the-box features that integrate seamlessly with Flutter. While future iterations of the project might require a more customized backend, Firebase provides everything needed to get started quickly and efficiently.

### Firebase Features to be Used
1. **Firebase Authentication**
	- For user authentication and ensuring that only verified users can access the app.  
2. **Firebase Cloud Firestore**
	- A real-time, scalable NoSQL database to store and manage user data.
	- **Reason for Choosing Firestore over Realtime Database**:
	In the past, Firebase Realtime Database caused issues in certain regions, while Firestore has proven to be more stable and sufficient for this project’s requirements.
3. **Firebase Storage**
	- For Storing User profile images.
4. **Firebase Cloud Messaging (FCM)**
	- For push notifications to users.
	- Each device is assigned a unique token used to send notifications directly.
	- Seamless integration with Flutter and Firebase Cloud Functions allows us to handle notification logic efficiently.
5. **Firebase Cloud Functions (Only on Blaze plan)**
	- Used to implement backend logic and enhance security:
		- Handles the Admin SDK inside the same environment seamlessly (doesn't require to store accessTokens or service credentials).
		- Checking DND status and sending challenges.
		- Validating challenge tasks submitted by the caller.
		- Sending notifications after successful DND and challenge checks.
		- Adding custom backend logic as the project evolves over time.
6. **Firebase App Check (Optional)**
	- In production, Firebase App Check adds an extra layer of security by ensuring that only verified instances of the app can make requests to Firebase.

### Pros and Cons of Firebase (Especially Firebase Cloud Messaging)
#### Pros
- Easy integration with Flutter applications.
- Free usage in Firebase’s plans, making it cost-effective for GSoC projects.
- Supports both in-app and push notifications.
- Admin SDKs available (Python, Node.js, etc.) to integrate with custom backends or cloud functions.
- Seamless notification handling, including background notifications.

#### Cons
- Firebase is a Google service, so dependency on Google infrastructure may be a concern.
- Other notification services (OneSignal, Twilio, AWS SNS, etc.) also rely on FCM device tokens, making it challenging to completely avoid Firebase Cloud Messaging.
- Limited offline capabilities in Firestore compared to some custom database solutions.

### Why Not Use Alternatives to FCM?
While there are alternatives like OneSignal, Pusher, Twilio, AWS SNS, and Pushy, many of these services rely on Firebase Cloud Messaging (FCM) internally to handle Android notifications. After researching the alternatives, it became clear that using Firebase’s own messaging service makes the most sense at this stage, as it offers:
- Simple, out-of-the-box integration with Flutter.
- No need to struggle with third-party services during initial development.
- Full compatibility with Firebase Cloud Functions for advanced backend logic.

Here are some sources discussing the reliance of alternatives on FCM:
- [Reddit AWS Discussion](https://www.reddit.com/r/aws/comments/14g42p2/please_help_me_understand_the_use_cases_for/)
- [Reddit Firebase Discussion](https://www.reddit.com/r/Firebase/comments/pp29sv/why_is_there_no_firebase_fcm_alternative/)
- [OneSignal Blog Comparison](https://onesignal.com/blog/firebase-vs-onesignal/#:~:text=OneSignal%20itself%20uses%20the%20FCM%20API%20internally%20to%20send%20messages%20to%20Android%20devices.)


## 3. User Authentication & Management

|   |   |   |
| ------------ | ------------ | ------------ |
| ![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/phone_auth_screen.jpg) | ![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/country_code_selector.jpg) | ![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/auth_confirm_dialog.jpg) |

### Implementation Overview
#### 1. Firebase Phone Authentication:
- Uses OTP-based authentication to verify the user’s phone number.
- Upon successful authentication, the user can either:
	- Create new profile details (if a first-time user).
	- Modify existing details (if a returning user).

#### 2. Firestore Integration for User Data:
- The user's profile details and device ID are stored in Cloud Firestore.
- Device ID is essential for:
	- FCM (Firebase Cloud Messaging) notifications to the specific device.

|   |   |
| ------------ | ------------ |
| ![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/Edit_profile_screen.jpg) | ![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/challenge_setup_screen.jpg) | 

#### 3. Phone Number Formatting and Validation
- Uses the `flutter_libphonenumber` package for:
  - Country code selection and formatting.
  - Phone number validation to ensure numbers are in the correct format.
  - Automatically formats the phone number input field based on the selected country.
#### 4. OTP UI Implementation
![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/verify_otp_screen.jpg)
- Uses the `pinput` package for:
  - **Stylized OTP input UI** with custom animation and input validation.
  - Easy user experience for entering OTPs with built-in features like:
    - Auto-focus on the next field.
    - Error feedback for incorrect OTP entries.
#### 5. User Profile Image Storage
- Profile images are uploaded and stored in **Firebase Storage**.
- The image URL is saved in **Firestore** to be retrieved and displayed in the app.

### Authentication Flow
1. **User Login with Phone Number**:
	- User provides their phone number.
	- Firebase sends an OTP for verification (Only on Blaze plan).
	- If OTP is valid, the user is authenticated.
2. **First-Time Users**:
	- The user is prompted to add profile details (name, photo, challenge configuration).
	- On submission, the data is saved to Firestore along with the device ID.
3. **Returning Users**:
	- Their existing details are fetched from Firestore upon login.
	- Users can update profile details (name, photo, challenge data).
	- Modified data is saved back to Firestore in real-time.
4. **Device ID Management**:
	- Each device generates a unique FCM token for push notifications.
	- The device ID is stored and updated for every login.
	- Used to send targeted notifications via FCM.


## 4. Notification Management

|   |   |
| ------------ | ------------ |
| ![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/home_screen(app_contacts_tab).jpg) | ![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/non_app_contacts_tab.jpg) |


The home screen is the primary interface for users, organized into two tabs:
1. **App Contacts**
2. **Non-App Contacts**

### Contacts Management
#### 1. Reading Device Contacts
- The app utilizes the `flutter_contacts` package to read all the contacts stored on the user's device.
- On launching the app, it retrieves and displays the complete list of contacts, which is then divided into two categories:
	- **App Contacts**: Contacts who have also registered for the app.
	- **Non-App Contacts**: Contacts who have not yet signed up.

#### 2. Fetching and Filtering Contacts
- The app fetches user data from Firebase to determine which contacts have registered.
- The filtering process involves comparing the user's device contacts against the Firestore database to identify which contacts have accounts in the app.

#### 3. Pull to Refresh & Manual Update
- Users can pull to refresh the contact lists, allowing the app to:
	- Re-fetch contacts from the device.
	- Re-query Firebase to check for any new users who may have signed up.
- A manual refresh button is also available to trigger the same process.

#### 4. Error Handling
- The app gracefully handles scenarios where:
	- The user's device contacts are empty.
		- In this case, a relevant message is displayed to inform the user.
	- Any errors during the fetching or filtering processes.

### Tab Functionality
#### 1. App Contacts Tab
- This tab displays the list of contacts who are registered users of the app.
- Interaction:
	- Tapping on any contact initiates the notification sending flow, allowing users to alert their contacts based on the dnd status.

#### 2. Non-App Contacts Tab
- This tab shows device contacts who are not yet registered.
- Invite Functionality:
	- An Invite Button is available, utilizing the `url_launcher` package to send an SMS invitation to contacts who do not have an account.
	- The message can be customized include a download link or a prompt to encourage registration.

### Notification Sending Flow
The notification sending flow is a crucial component of the app, enabling users to determine the urgency of their notifications based on the recipient's DND (Do Not Disturb) status. This process involves a series of steps, from triggering the notification function to managing responses based on the DND status.

#### Flow Overview
1. **User Interaction**: When a user taps on an app contact, it triggers a callable function in Firebase.
2. **DND Status Check**: A silent notification is sent to the recipient’s device to determine their DND status.
3. **Notification Handling**: Depending on the DND status, appropriate notifications are sent to both the sender and receiver.

#### 1. Triggering the Callable Function
Upon selecting an app contact, the app calls a Firebase function that initiates the notification flow. This function is responsible for sending a silent notification to the recipient's device, allowing the app to check the DND status without alerting the user.

#### 2. Checking DND Status
**Custom Flutter Package `focus_status`**:
Since there was no available Flutter package for checking DND status, I created `focus_status` package. This package currently supports Android only and utilizes Kotlin for the native implementation.

**Kotlin Implementation**  
The Kotlin function retrieves the current interruption filter (DND status) using the `NotificationManager` class:

```kotlin
private fun getFocusStatus(): Int {
    val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager


    return notificationManager.currentInterruptionFilter
}
```
- **Reference**: [Android Documentation](https://developer.android.com/reference/android/app/NotificationManager#getCurrentInterruptionFilter)

**Flutter Side Implementation**  
The Flutter side utilizes a platform channel to call the native Kotlin function:


```dart
@override
Future<int?> getFocusStatus() async {
    final status = await methodChannel.invokeMethod<int>('getFocusStatus');
    return status;
}
```
**Package Usage in pubspec.yaml**  
To include the `focus_status` package, add the following to your `pubspec.yaml`:

```yaml
focus_status:
  git:
    url: https://github.com/0xharkirat/focus_status.git
    ref: main
```

#### 3. Handling Notification Scenarios
Once the DND status is retrieved, the Firebase function proceeds to handle the notification based on three potential scenarios:

1. **Unable to Get DND Status**:
	- If the app cannot retrieve the DND status, a notification is sent to the sender, informing them that there was an error and to try again.
2. **Receiver Not in DND Mode**:
	- If the recipient is not in DND mode, a notification is sent to the receiver, indicating that they have an urgent message.
	- The sender receives a confirmation notification stating that their message has been successfully delivered.
3. **Receiver in DND Mode**:
	- If the recipient is in DND mode, the app sends a challenge to the sender. The challenge can be a simple math problem or a password that the sender must solve.
	- Upon successful verification of the challenge, the process repeats the second scenario, sending a notification to the receiver.

#### 4. On-Device Notification Handling
To manage on-device notifications, the `awesome_notifications` package is used, which integrates seamlessly with the `firebase_messaging` package. This combination ensures that notifications are handled appropriately across different app states:

- **Foreground**: Notifications can be displayed directly to the user.
- **Background**: Notifications are processed and shown without disrupting the user's experience.
- **Terminated**: Notifications are delivered even when the app is not running.

## 5. Permission Handling
For the app to function optimally, three main permissions are required. These permissions are managed in the `permission_screen`, which is presented to the user upon their first interaction with the app.

|   |   |   |
| ------------ | ------------ | ------------ |
| ![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/permissions_dialog.jpg) | ![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/readme_images/permissions_screen.jpg) | ![](https://raw.githubusercontent.com/0xharkirat/its_urgent/refs/heads/main/assets/notifications.gif) |
### 1. Accessing Device Contacts
- The app needs permission to access the user's device contacts to read and filter contacts effectively.
- This permission is managed using the `flutter_contacts` package, which simplifies the process of requesting and handling contacts permissions.

### 2. Notification Permissions
- The app requires permission to send notifications to users.
- This permission is handled using the `firebase_messaging` package, allowing the app to receive and manage notifications smoothly.

### 3. Adding App Notifications to Bypass DND
- This permission is more complex to implement compared to the first two. It is essential for allowing notifications from the app to bypass the user's Do Not Disturb (DND) settings.
- The app’s notifications can only bypass DND if the sender has completed the associated challenge, ensuring that only verified notifications receive priority.

**Challenges in Implementation**
- There is no native Android API to check which apps are on the DND override list. Users can manually add apps to this list in their phone settings, but there was no way to programmatically verify if our app is included.
- After extensive research, a native API was discovered that allows checking if a specific notification channel (identified by a unique name) can bypass DND settings. For more information, refer to the official [Android documentation](https://developer.android.com/reference/android/app/NotificationChannel#canBypassDnd/).

**Kotlin Implementation**  
The following Kotlin function checks if the app's notification channel can bypass DND:

```kotlin
private fun canBypassDnd(): Boolean {
    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    val channels = notificationManager.notificationChannels

    // Assuming you want to check for a specific channel, e.g., "its_urgent_notifications"
    val channel = channels.find { it.id == "its_urgent_notifications" }

    // Return true if the channel exists and can bypass DND, otherwise false
    return channel?.canBypassDnd() ?: false
}
```

**Flutter Implementation**  
To check the DND permission from Flutter, the following method is used:

```dart
Future<bool> _getDNDStatus() async {
    const platform = MethodChannel('com.hsiharki.itsurgent/battery');
    final dnd = await platform.invokeMethod<bool>('canBypassDnd');
    log("DND permissions: $dnd");
    return dnd ?? false;
}
```

**Setting Up Notification Channels**  
In the `awesome_notifications` package, a unique channel name is specified to ensure the proper functioning of notifications:

```dart
AwesomeNotifications().initialize(
    'resource://drawable/logo', // Use 'resource://drawable/<icon_name>'
    [
      NotificationChannel(
        channelKey: 'its_urgent_notifications', // This is a unique ID
        channelName: 'Its Urgent Notifications',
        channelDescription: 'Notification channel for Its Urgent App',
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        importance: NotificationImportance.Max,
      )
    ],
);
```

**Navigating to Permission Settings**  
To facilitate users in managing their permissions, the `app_settings package` is used to redirect users directly to specific settings of the device and app.

**Refreshing Permissions**  
To ensure the app has the latest permission status, `WidgetsBindingObserver` is implemented to refresh permissions when the app resumes:

```dart
@override
void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
}

@override
void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
}

@override
void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
        // Refresh permissions when the app resumes
        ref.read(permissionsController.notifier).refreshPermissions();
    }
    super.didChangeAppLifecycleState(state);
}
```

## 6. State Management and Navigation
### State Management with Flutter Riverpod
This app utilizes Flutter Riverpod for effective state management and dependency injection. Riverpod's declarative approach makes it easier to manage the app's state while maintaining a clear separation of concerns. By leveraging Riverpod, the app ensures that its various components can reactively respond to state changes, enhancing the overall user experience.

### Navigation with GoRouter
GoRouter is used for managing app navigation, providing a streamlined way to define routes and handle navigation. This framework simplifies complex routing scenarios, ensuring a smooth navigation experience throughout the app.

### Popping Dialogs
For simpler dialog management, the app uses `Navigator.of(context).pop()` to close dialogs, allowing for straightforward user interactions without complicating the navigation logic.

### Automatically Refreshing the Router
The app incorporates a refresh listener that automatically updates the router in response to changes in the Firebase user state. This is achieved through the following implementation:

```dart
// Automatically refresh the router when the Firebase user state changes 
refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),

```

### Redirecting on Refresh with GoRouter

In addition to refreshing, the app uses a redirect mechanism to control user access based on their authentication status. The redirect logic ensures that users are guided to the appropriate screens (e.g., splash, login, or home) based on their authentication state. This functionality is built into the GoRouter setup **(simple example)**:

```dart
final GoRouter router = GoRouter(
  refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
      ],
    ),
  ],
  redirect: (GoRouterState state) {
    final user = firebaseAuth.currentUser;
    final isSplash = state.matchedLocation == '/';
    if (user == null && !isSplash) {
      return '/login'; // Redirect to login if not authenticated
    }
    if (user != null && isSplash) {
      return '/home'; // Redirect to home if authenticated
    }
    return null; // No redirection needed (normal navigation)
  },
);
```

**Helper Method for Refreshing**  
The `GoRouterRefreshStream` class listens to a given stream and notifies listeners whenever a new event occurs. This allows the router to refresh its state based on the latest authentication status:

```dart
import 'dart:async';
import 'package:flutter/material.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

### Splash Screen Implementation
To enhance the app's initial loading experience, the flutter_native_splash package is utilized to create splash screens. This package simplifies the process of displaying a splash screen when the app starts, ensuring a smooth transition into the app's main interface.
	


## Future Features Ideas, Bug Fixes, Improvements, and Testing Plans
### 1. Future Feature Ideas
- **Action Button on Notifications**: Implement an action button on notifications that allows users to directly open the caller app and initiate a call to the sender of the notification. This will enhance user interaction and streamline the process of responding to notifications.

- **Recent Notifications**: Implement a feature to show a history of recent notifications, allowing users to review past alerts and actions taken.

- **Detailed Contact Information**: Add an individual app-contact screen/dialog (for each app contact) to display additional details such as the device contacts name and app account name associated with each contact, similar to features seen in messaging apps like WhatsApp.
- **Improved Error Handling**: Expand error handling capabilities to cover a broader range of scenarios, ensuring users receive clear feedback during issues.

### 2. Bug Fixes
- **Self-Notification Bug**: Currently, if users add their own number to device contacts, it appears in the app's contacts tab. This leads to the situation where tapping on their own contact triggers a notification to **self**. This bug needs to be resolved by filtering out the user's own contact from the app contacts list.

### 3. Code Refactoring
- **Profile Management**: The Edit Profile screen and Edit Profile dialog currently use 90% of the same logic. Refactoring this shared logic can simplify maintenance and improve code readability.

- **Simplify Redirect Logic**: The current redirect logic in the GoRouter setup is complex. Streamlining this logic will enhance clarity and maintainability, especially for screens that require conversion to full-screen dialogs (Many screens can be converted to Full Screen Dialogs).

### 4. UI Improvements
- **UI**: The app&#39;s UI design is very Material Design. I have created the design from Material Design Toolkit on Figma. If anyone has better design, It can change app&#39;s UI for better.

### 5. Testing Plans
- While I have done manual user testing on different devices with different phone numbers, Flutter's unit testing, widget testing & integration testing is yet to be done.

### 6. iOS Implementation
- For IOS, we only need to make our implementations of get focus status (DND Status), which is already exposed (native api in IOS) & to check if the app or app's notification channel id can bypass dnd or not. Everything else is same.

## Project Structure
This project follows feature first project approach like this:
```
lib  
│
└── src  
    │
    ├── core  
    │   ├── constants  
    │   ├── controllers  
    │   ├── helpers  
    │   ├── models  
    │   ├── routing  
    │   └── views  
    │       ├── screens  
    │       └── widgets  
    │
    └── features  
        ├── auth  
        │   ├── auth_controllers  
        │   ├── auth_providers  
        │   ├── auth_views  
        │   │   ├── auth_screens  
        │   │   └── auth_widgets  
        │   └── models  
        │       ├── class_models  
        │       └── data_constants  
        │
        ├── notification  
        │   ├── notification_controllers  
        │   ├── notification_models  
        │   └── notification_views  
        │       ├── notification_screens  
        │       └── notification_widgets  
        │
        └── splash  
            ├── splash_providers  
            └── splash_views  
                └── screens  
```
+ For more information about the project structure read this article [Flutter Project Structure: Feature-first or Layer-first?](https://codewithandrea.com/articles/flutter-project-structure/)


## Pub.dev packages currently being used:
+ cupertino_icons
+ firebase_core
+ flutter_riverpod
+ go_router:
+ firebase_auth
+ google_fonts
+ pinput
+ flutter_libphonenumber
+ transparent_image
+ image_picker
+ cloud_firestore
+ firebase_storage
+ firebase_messaging
+ flutter_contacts
+ app_settings
+ url_launcher
+ cloud_functions
+ focus_status:
  ```yml
  focus_status:
      git:
        url: https://github.com/0xharkirat/focus_status.git
        ref: main
  ```
+ awesome_notifications
+ flutter_native_splash
+ flutter_animate
+ shared_preferences
