# App Account Deletion Request Webpage

A simple Webpage made with flutter. It allows user to sign in using firebase auth and Request to delete their Account.


https://github.com/Adaptavant/Android-Container-V2/assets/35376901/3911d3f9-4fdd-444a-9140-5f3b50fded51



## Setup guide

## Firebase configuration
  Install firebase[ CLI](https://firebase.google.com/docs/cli#setup_update_cli)
  Run the following commands
```
  firebase login
  dart pub global activate flutterfire_cli
  flutterfire configure
```

## Hosting configuration
```
flutter build web
firebase experiments:enable webframeworks
firebase init hosting
firebase deploy
```

## Code Guide

- Majority of code present in the[ main.dart file.](https://github.com/sum20156/App_Account_Deletion_Request/blob/b4e9d0ba8ce5af2ab7c805291e055504c79cf3a5/lib/main.dart). If you want to change any text you can search for those in this file and replace it.
- [deleteUserData(String userId)](https://github.com/sum20156/App_Account_Deletion_Request/blob/e1c72cdb8652273e3ef75c79223c636a7acaba5e/lib/main.dart#L48) contains logics related to the data deletion, you have to modify the code according to your need. In my case user data is stored in **USERS** collection. Don't worry the syntax is very similar to java/kotlin.
- Replace[ app_icon.png](https://github.com/sum20156/App_Account_Deletion_Request/blob/master/assets/app_icon.png) and [favicon.png](https://github.com/sum20156/App_Account_Deletion_Request/blob/master/web/favicon.png) with your app logo.
    
    
