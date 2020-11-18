# Android App Distribution

## For Internal Testing

-   Create an appbundle version:

```
flutter build appbundle --flavor dev --release
```

-   Once the bundle is ready, create a sharing link using [Google Internal App Sharing](https://play.google.com/console/internal-app-sharing/)

-   You get a new link for each version. Send it to set of testers of testing

## On Play Store

-   Create an **[obfuscated](https://flutter.dev/docs/deployment/obfuscate)** appbundle version for sharing with command:

```
flutter build appbundle --obfuscate --split-debug-info=/Users/varunmehta/Projects/botiga/symbols/botigaBizApp_1.0.0 --flavor prod --release
```

The reason to use appbundle has been detailed in [article](https://developer.android.com/guide/app-bundle?authuser=1).
