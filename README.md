# Sora-iOS

Sora-iOS is a mobile application that connects to a Node.js backend for authentication, database operations, and AI-powered responses using Google's Gemini API.

## 🚀 Getting Started

### 1️⃣ Backend Setup

#### Prerequisites
- [Node.js](https://nodejs.org/)
- [MongoDB](https://www.mongodb.com/)

#### Installation
```sh
cd backend
npm i
```

#### Environment Variables
Create a `.env.local` file inside the `backend` directory and populate it with the following credentials:

```ini
GEMINI_API_KEY=your_google_gemini_api_key  
# Obtain from [Google AI Studio](https://aistudio.google.com/)

ENCRYPTION_SECRET=your_secret_key  
# Generate using `npx auth secret` or use a random string

MONGODB_URI=your_mongodb_connection_uri  
# Obtain from [MongoDB Atlas](https://www.mongodb.com/atlas) or MongoDB Compass (Local Instance)

MAIL_HOST=smtp.gmail.com  
# SMTP server for sending emails

MAIL_USER=your_email@gmail.com  
# Your email address

MAIL_PASS=your_app_password  
# Generate an app password from [Google Account Security](https://myaccount.google.com/security) if using Gmail

BACKEND_URL=your_backend_url  
# The backend's base URL
```

#### Start Backend Server
```sh
node --env-file=.env.local server.js
```

### 2️⃣ iOS App Setup

#### Updating Backend URL
In the iOS project, navigate to:
```
/Sora/Sora/SoraApp.swift
```
Modify the backend URL to the local IP of your machine:
```swift
let backendURL = "http://YOUR_LOCAL_IP:5000"
```
Replace `YOUR_LOCAL_IP` with your machine's actual local IP address, e.g., `172.20.10.4`.

### 📌 Notes
- Ensure your backend server is running before using the iOS app.
- The `.env.local` file should not be committed to version control.
- The iOS app needs to be configured to match the backend's URL for proper communication.

## 📜 License
This project is licensed under the MIT License.

---

💡 **Contributions are welcome!** Feel free to open issues or submit pull requests.

