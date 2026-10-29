# ApnaTube — User App + Admin Panel

ApnaTube is a dark-mode, creator-focused video sharing starter project with a red accent UI inspired by the supplied reference design.

## Project structure
- `apps/user-app`: ApnaTube user interface, demo feed/Shorts, sign-in/sign-up, create-post form, Discover, Videos and Profile navigation.
- `apps/admin-app`: separate admin sign-in and content moderation dashboard.
- `supabase/schema.sql`: database tables, Row Level Security policies, and admin helpers.

## Important
This is a starter project, not a deployed service or a ready-made APK. Demo cards use public sample image URLs. Real authentication and saved posts require your own Supabase project. Video upload currently accepts a public video URL; it does not upload a local video file yet. Never share your Supabase database password or service-role key.

## Requirements
- Node.js 20+ and npm
- A Supabase account/project for real accounts and posts
- Android Studio + Android SDK for a native Android build

## 1. Set up Supabase
1. Create a project at https://supabase.com
2. Open SQL Editor and run `supabase/schema.sql`.
3. In Project Settings → API, copy the Project URL and publishable/anon key.
4. Configure allowed redirect URLs in Supabase Authentication settings.

## 2. Configure both apps
In each app folder, copy `.env.example` to `.env.local` and set:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

Use only the public client/anon key in the frontend. Never place a service-role key in frontend code or commit `.env.local` to GitHub.

## 3. Run the User App
```bash
cd apps/user-app
npm install
npm run dev
```

## 4. Run the Admin Panel
```bash
cd apps/admin-app
npm install
npm run dev
```

Admin login requires an authorized row in `admin_profiles`; regular users do not automatically have admin access.

## 5. Build for Android
Read `BUILD-APK.md`. Building an APK requires the Android SDK/Android Studio and signing setup. The ZIP itself is not an APK.
# ApnaTube
