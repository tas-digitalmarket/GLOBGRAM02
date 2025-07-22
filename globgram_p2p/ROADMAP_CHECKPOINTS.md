# GlobGram P2P - نقشه راه توسعه

## فازهای توسعه پروژه

### 0. خط مبنا (Baseline)
**هدف:** ارزیابی وضعیت فعلی پروژه و آماده‌سازی برای توسعه
- ✅ ساختار Clean Architecture موجود و کارآمد
- ✅ dependency injection با GetIt پیاده‌سازی شده
- ✅ routing با GoRouter تنظیم شده
- ✅ UI اولیه با Material 3 ایجاد شده
- ✅ BLoC pattern برای state management فعال

### 1. پاکسازی داخلی (Internal Cleanup) ✅ **مکمل**
**هدف:** بهینه‌سازی کد موجود و حذف dependency های غیرضروری
- ✅ حذف fake_cloud_firestore از dependencies
- ✅ بررسی و بهینه‌سازی imports غیرضروری 
- ✅ یکسان‌سازی naming conventions
- ✅ اضافه کردن documentation مناسب برای کلاس‌ها
- ✅ بررسی و اصلاح linting warnings
- ✅ تبدیل تمام imports به absolute package paths
- ✅ مدیریت مرکزی ChatBloc instance در router
- ✅ استخراج UI components (MessageBubble, Dialogs)
- ✅ حذف redundant dependencies و imports
- ✅ اصلاح test files و حذف deprecated references

### 2. راه‌اندازی Firestore (Firestore Initialization)
**هدف:** تنظیم صحیح Firebase و Firestore برای signaling
- [ ] تنظیم Firebase project و کانفیگ‌های مناسب
- [ ] ایجاد Firestore rules برای signaling collections
- [ ] تست اتصال به Firestore در محیط‌های مختلف
- [ ] پیاده‌سازی fallback mechanism برای حالت آفلاین
- [ ] مدیریت authentication اولیه (anonymous)

### 3. پیاده‌سازی Firestore Signaling (Firestore Signaling Data Source) ✅ **مکمل**
**هدف:** تکمیل data source برای تبادل signaling messages
- ✅ پیاده‌سازی کامل FirestoreSignalingDataSource
- ✅ ایجاد methods برای offer/answer exchange
- ✅ پیاده‌سازی ICE candidates collection
- ✅ تست real-time listeners برای signaling events
- ✅ error handling برای شبکه و Firestore

### 4. سرویس WebRTC واقعی (Real WebRTC Service) ✅ **مکمل**
**هدف:** پیاده‌سازی کامل WebRTC با offer/answer و ICE handling
- ✅ تکمیل createOffer و createAnswer workflows
- ✅ پیاده‌سازی کامل ICE candidate exchange
- ✅ تنظیم TURN servers برای NAT traversal
- ✅ ایجاد robust data channel management
- ✅ پیاده‌سازی reconnection logic

### 5. بازسازی Chat Bloc (Chat Bloc Refactor) ✅ **مکمل**
**هدف:** بهبود state management با Freezed و تفکیک نقش‌ها
- ✅ تبدیل ChatState به Freezed classes
- ✅ تفکیک caller/callee logic در events
- ✅ پیاده‌سازی proper error states
- ✅ افزودن loading states برای UI (Loading, SendingMessage)
- ✅ بهبود message ordering و timestamp handling
- ✅ حذف کلاس‌های قدیمی Equatable
- ✅ تنظیم Hydrated serialization با Freezed
- ✅ استفاده از when/maybeWhen در UI components

### 6. بهبودهای UI/UX (UI/UX Enhancements) ✅ **مکمل**
**هدف:** ایجاد رابط کاربری پیشرفته و user-friendly
- ✅ طراحی chat bubbles با animation و responsive design
- ✅ نمایش connection status به کاربر (ConnectionStatusWidget)
- ✅ پیاده‌سازی error handling با ScaffoldMessenger snackbars
- ✅ بهبود user feedback با proper color theming
- ✅ افزودن long-press tooltip برای timestamp نمایش کامل
- ✅ تنظیم automatic theme adaptation (light/dark mode)
- ✅ بهینه‌سازی message bubble colors برای accessibility

### 7. فعال‌سازی چندزبانه (Localization Activation) ✅ **مکمل**
**هدف:** راه‌اندازی کامل سیستم چندزبانه
- ✅ افزودن ترجمه فارسی کامل (fa.json)
- ✅ تنظیم RTL layout برای فارسی
- ✅ پیاده‌سازی locale switching در runtime (Language toggle button)
- ✅ تنظیم supportedLocales: [Locale('en'), Locale('fa')]
- ✅ اصلاح hardcoded strings در UI components
- ✅ تنظیم proper translation keys structure
- ✅ تست موفقیت‌آمیز build با localization

### 8. پایداری و مهاجرت (Persistence & Migration) ✅ **مکمل**
**هدف:** مدیریت حرفه‌ای data persistence و version migration
- ✅ پیاده‌سازی HydratedBloc migration strategies با version checking
- ✅ تنظیم v3 migration strategy با null return برای old data
- ✅ تست موفقیت‌آمیز reset storage mechanism
- ✅ بهینه‌سازی storage performance با smart versioning
- ✅ پیاده‌سازی data cleanup policies

### 9. امنیت و پاکسازی (Security & Cleanup) ✅ **مکمل**
**هدف:** تضمین امنیت و پاک‌سازی Firestore documents  
- ✅ پیاده‌سازی automatic signaling document cleanup
- ✅ تنظیم metadata.connected tracking for secure cleanup
- ✅ افزودن automatic SDP clearing after connection
- ✅ پیاده‌سازی ICE candidate stopping mechanism
- ✅ تست موفقیت‌آمیز cleanup در dispose methods

### 10. پشتیبانی مدیا (Media Support Foundation) ✅ **مکمل**
**هدف:** آماده‌سازی architecture برای ویژگی‌های صوتی/تصویری
- ✅ ایجاد WebRTCService interface با media methods
- ✅ پیاده‌سازی prepareMedia() با getUserMedia() integration
- ✅ افزودن localStream$ و remoteStream$ to service interface
- ✅ تنظیم media stream controllers در implementations
- ✅ پیاده‌سازی toggleAudio()/toggleVideo() methods
- ✅ ایجاد media track management در WebRTCServiceImpl
- ✅ تنظیم onTrack handler برای remote stream reception
- ✅ تکمیل WebRTCServiceMock با media method stubs
- ✅ تست موفقیت‌آمیز build با media foundation

### 11. توسعه‌های آینده (Future Extensions)
**هدف:** UI implementation برای ویژگی‌های صوتی/تصویری
- [ ] ایجاد UI components برای video/audio controls
- [ ] پیاده‌سازی camera/microphone permissions handling
- [ ] تنظیم media constraints و quality settings در UI
- [ ] ایجاد video call interface
- [ ] تست performance در حالت video call

---

**نکته:** هر فاز باید کاملاً تست شده و پایدار باشد قبل از شروع فاز بعدی.
