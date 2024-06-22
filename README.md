# It's Urgent
![Static Badge](https://img.shields.io/badge/GSoC'24-8A2BE2) ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?s&logo=Flutter&logoColor=white) ![Firebase](https://img.shields.io/badge/Firebase-a08021?&logo=firebase&logoColor=ffcd34)

This is frontend repo for `It's Urgent` Project which is being developed in Flutter. 

Live YouTube Updates: https://www.youtube.com/playlist?list=PLLx2TfaNTPhxWUjVwRsbgZxqJ1j0NkrC5

## Backend
Backend repo can be found at https://github.com/0xharkirat/its_urgent_backend

## Project Structure
This project follows feature first project approach like this:
```
lib
└───src
    ├───commons
    │   ├───common_controllers
    │   ├───common_models
    │   │   ├───common_class_models
    │   │   └───common_data_constants
    │   ├───common_providers
    │   └───common_views
    │       ├───common_screens
    │       └───common_widgets
    ├───core
    │   ├───constants
    │   ├───helpers
    │   └───routing
    └───features
        ├───auth
        │   ├───auth_controllers
        │   ├───auth_providers
        │   ├───auth_views
        │   │   ├───auth_screens
        │   │   └───auth_widgets
        │   └───models
        │       ├───class_models
        │       └───data_constants
        ├───notification
        │   ├───notification_controllers
        │   ├───notification_providers
        │   └───notification_views
        │       ├───notification_screens
        │       └───notification_widgets
        └───splash
            ├───splash_controllers
            ├───splash_providers
            └───splash_views
                ├───screens
                └───splash_widgets
```
+ For more information about the project structure read this article [Flutter Project Structure: Feature-first or Layer-first?](https://codewithandrea.com/articles/flutter-project-structure/)


## Pub.dev packages currently being used:
+ firebase_core
+ flutter_riverpod
+ go_router
+ firebase_auth
+ google_fonts
+ firebase_ui_auth
+ pinput
+ flutter_libphonenumber
+ transparent_image
+ image_picker
+ cloud_firestore
+ firebase_storage
+ firebase_messaging