# Build the Android APK (User App)

This project contains a web app that can be packaged with Capacitor. You need a computer for the usual Android Studio workflow.

1. Install Node.js 20+ and Android Studio.
2. Configure `apps/user-app/.env.local`.
3. In a terminal:
   ```bash
   cd apps/user-app
   npm install
   npm run build
   npx cap add android
   npx cap sync android
   npx cap open android
   ```
4. In Android Studio, wait for Gradle sync.
5. Use **Build → Build Bundle(s) / APK(s) → Build APK(s)** for a test APK.
6. Test login, posting, image URLs, and navigation on a real device.
7. For public distribution, create a signed release build and review privacy/security requirements.

If `android/` already exists, skip `npx cap add android` and run `npx cap sync android`.

The Admin Panel is a separate web app. It is not bundled into the user APK.
