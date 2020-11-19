# Botiga

Botiga eCommerce Platform hosts 2 mobile apps:

-   A Customer app (this one)
-   A Merchant app

These apps essentially covers the 2 aspects of marketplace - `supply` & `demand`

## Command to generate models using json_serializable

```
flutter pub run build_runner build --delete-conflicting-outputs
```

## Custom Icons

-   Custom icons added using [Flutter Icon Generator](https://www.fluttericon.com/).

-   [How to do it?](https://medium.com/deviniti-technology-driven-blog/the-best-way-to-add-custom-icons-to-your-flutter-project-6381ab697813)

## Android App Distribution

### For Testing

-   Create an apk version:

```
flutter build apk --flavor dev --release
```

-   Once ready, upload it to `botiga-dev` project, `BotigaDev` android app in`firebase console`

-   Select testers group & send a new email for testing

### On Play Store

-   Create an **[obfuscated](https://flutter.dev/docs/deployment/obfuscate)** appbundle version for sharing with command:

```
flutter build appbundle --obfuscate --split-debug-info=/Users/varunmehta/Projects/botiga/symbols/botigaApp_0.1.0 --flavor prod --release
```

The reason to use appbundle has been detailed in [article](https://developer.android.com/guide/app-bundle?authuser=1).
