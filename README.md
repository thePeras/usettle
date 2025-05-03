<div align="center">
    <img src="assets/imgs/icon.png" height="100" />
    <h1>uSettle</h1>
</div>

## Overview

**uSettle** is a app designed to put an end to the “you pay now, send me my share later” hassle. By simply scanning a receipt, the app identifies all items, lets users assign who ordered what, and helps settle debts quickly—either via MB Way or by tracking balances between friends. With support for fair splits and ongoing accounts, uSettle makes shared expenses simple, transparent, and hassle-free.

<div align="center">
    <img src="assets/uSettle.gif" height="600" />
</div>

## Technologies

Our project started with designing prototypes in **Figma**, followed by an implementation using the **Flutter** framework. For the receipt recognition functionality, we integrated **Google Gemini** to process and extract data from images.

## How to run the project

To run this project, ensure you have Flutter installed. If not, follow the official installation guide [here](https://flutter.dev/docs/get-started/install).

Once Flutter is installed, clone the repository and run the following commands in the root directory:

```bash
flutter pub get
flutter run
```

## Sctruture of the code

All the app code lives in `/lib` folder.
- `api/` - Code related to apis, in this case, MBWay
- `models/` - All the Dart models used in the app
- `view/` - All the app pages, where inside, each folder represents a page except `common/` where there is common widgets shared across the app

## Evolution

###  Napkins Wireframes
<img width="400" src="[https://github.com/user-attachments/assets/179d5197-5e3a-49b7-bc21-7d60fb09b01d](https://github.com/user-attachments/assets/714fa921-0cee-4273-b423-a1b9be6ea1d0)" />

### Figma Mockups
<img width="400" src="https://github.com/user-attachments/assets/179d5197-5e3a-49b7-bc21-7d60fb09b01d" />

### Prototype Screenshoots
<>

## Team

- [Adriano Machado](https://github.com/Adriano-7) 
- [Diogo Goiana](https://github.com/DGoiana)
- [João Torre Pereira](https://github.com/thePeras) 
- [Rubem Neto](https://github.com/rubuy-74)
