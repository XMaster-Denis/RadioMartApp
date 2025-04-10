# 📱 Radiomart Electronic Components Catalog App

An advanced iOS/iPadOS application designed to seamlessly interface with the **[radiomart.kz](https://radiomart.kz)** online store, offering a comprehensive catalog of electronic components. This project showcases my expertise in mobile application development, API integration, machine learning, multilingual support, and PDF document generation.

## 🚀 Key Features

- **Comprehensive Catalog**: Access and navigate through categories of electronic components, view detailed product information including descriptions, prices, and images.
- **Multilingual Support**: Interface available in 🇩🇪 German, 🇺🇸 English, and 🇷🇺 Russian.
- **Dynamic Translation**: Leverages a custom server with GPT integration to provide real-time translations of product names and descriptions.
- **Project Management**: Create and manage personal projects by adding components from the catalog, with options to edit details and quantities.
- **PDF Generation**: Generate and share detailed PDF documents of your projects.
- **AI Component Recognition**: Utilize the device camera to identify electronic components using a custom-trained machine learning model.
- **User Authentication**: Secure authentication and project synchronization across devices via Firebase.
- **SVG Animation Support**: Enhanced visual experience with SVG animations during application launch.

## 🧠 Multilingual Support and GPT Integration

- **Language Options**: Users can select their preferred language (German, English, or Russian) within the app, independent of the device's system language.
- **Translation Mechanism**: The app fetches product data in Russian from the [radiomart.kz](https://radiomart.kz) API. A custom server built with **Swift Vapor** communicates with **OpenAI's GPT** to translate product names and descriptions into the selected language. Translations are cached for future use, ensuring efficiency and consistency.

## 🛠 Technologies and Frameworks Used

### Languages and UI:
- `Swift`
- `SwiftUI`

### Data Management:
- `SwiftData`
- `Firebase` (Auth, Firestore, Storage)
- `Combine`

### Networking:
- `Alamofire`
- `Kingfisher`
- `SWXMLHash`

### PDF Generation:
- `PDFKit`
- [`FlowPDF`](https://github.com/XMaster-Denis/FlowPDF): A custom library I developed for streamlined PDF creation in Swift.

### Machine Learning:
- `CreateML`
- [`XAnnotation`](https://github.com/XMaster-Denis/XAnnotation): A native image annotation tool I developed to facilitate the training of machine learning models.
- Custom `.mlmodelc` trained to recognize electronic components.

### Others:
- `WebKit`: Utilized for rendering SVG animations and web content.
- `UIKit`: Integrated for specific functionalities, including camera operations.

## 📸 AI-Powered Component Recognition

- **Training Data**: Compiled approximately 2,000 annotated images of various electronic components.
- **Functionality**: Users can point the device camera at a circuit board, and the app will identify components such as transistors, capacitors, and resistors, displaying the component name and confidence level.
- **Customization**: Users can set the confidence threshold for recognition accuracy.

## 📁 Project Management Feature

- **Create Projects**: Users can initiate personal projects (e.g., "Traffic Light Circuit") and add necessary components from the catalog.
- **Edit Details**: Modify project names, adjust component quantities, and update prices as needed.
- **PDF Export**: Generate detailed PDF reports of projects, customizable with user or company names, facilitating sharing and documentation.

## 🔒 User Authentication and Cloud Sync

- **Firebase Integration**: Enables authentication through social media accounts and synchronizes user projects across multiple devices.
- **Personalization**: Users can set their display name and company name, which are reflected in generated PDF reports.

## 🌐 Language and Personalization Settings

Within the app settings, users have the ability to:
- **Change Interface Language**: Choose between German, English, or Russian, regardless of the device's system language.
- **Set User and Company Name**: Personalize reports and project documentation with custom names.

## 📷 Screenshots

![Screenshot 1](https://github.com/XMaster-Denis/RadiomartApp/raw/main/Screenshots/screenshot1.png)
![Screenshot 2](https://github.com/XMaster-Denis/RadiomartApp/raw/main/Screenshots/screenshot2.png)
![Screenshot 3](https://github.com/XMaster-Denis/RadiomartApp/raw/main/Screenshots/screenshot3.png)

---
