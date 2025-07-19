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

### 3. پیاده‌سازی Firestore Signaling (Firestore Signaling Data Source)
**هدف:** تکمیل data source برای تبادل signaling messages
- [ ] پیاده‌سازی کامل RoomRemoteDataSourceFirestore
- [ ] ایجاد methods برای offer/answer exchange
- [ ] پیاده‌سازی ICE candidates collection
- [ ] تست real-time listeners برای signaling events
- [ ] error handling برای شبکه و Firestore

### 4. سرویس WebRTC واقعی (Real WebRTC Service)
**هدف:** پیاده‌سازی کامل WebRTC با offer/answer و ICE handling
- [ ] تکمیل createOffer و createAnswer workflows
- [ ] پیاده‌سازی کامل ICE candidate exchange
- [ ] تنظیم TURN servers برای NAT traversal
- [ ] ایجاد robust data channel management
- [ ] پیاده‌سازی reconnection logic

### 5. بازسازی Chat Bloc (Chat Bloc Refactor)
**هدف:** بهبود state management با Freezed و تفکیک نقش‌ها
- [ ] تبدیل ChatState به Freezed classes
- [ ] تفکیک caller/callee logic در events
- [ ] پیاده‌سازی proper error states
- [ ] افزودن loading states برای UI
- [ ] بهبود message ordering و timestamp handling

### 6. بهبودهای UI/UX (UI/UX Enhancements)
**هدف:** ایجاد رابط کاربری پیشرفته و user-friendly
- [ ] طراحی chat bubbles با animation
- [ ] نمایش connection status به کاربر
- [ ] پیاده‌سازی typing indicators
- [ ] بهبود error handling و user feedback
- [ ] افزودن sound effects و haptic feedback

### 7. فعال‌سازی چندزبانه (Localization Activation)
**هدف:** راه‌اندازی کامل سیستم چندزبانه
- [ ] افزودن ترجمه فارسی کامل
- [ ] تنظیم RTL layout برای فارسی
- [ ] تست locale switching در runtime
- [ ] بهینه‌سازی asset loading برای translations
- [ ] افزودن locale detection خودکار

### 8. پایداری و مهاجرت (Persistence & Migration)
**هدف:** مدیریت حرفه‌ای data persistence و version migration
- [ ] پیاده‌سازی HydratedBloc migration strategies
- [ ] ایجاد data backup و restore mechanisms
- [ ] تست upgrade/downgrade scenarios
- [ ] بهینه‌سازی storage performance
- [ ] پیاده‌سازی data cleanup policies

### 9. امنیت و پاکسازی (Security & Cleanup)
**هدف:** تضمین امنیت و پاک‌سازی Firestore documents
- [ ] پیاده‌سازی automatic signaling document cleanup
- [ ] افزودن security rules پیشرفته
- [ ] تنظیم data retention policies
- [ ] encryption برای sensitive data
- [ ] rate limiting و abuse prevention

### 10. توسعه‌های آینده (Future Extensions)
**هدف:** آماده‌سازی برای ویژگی‌های صوتی/تصویری
- [ ] ایجاد architecture برای video/audio streams
- [ ] پیاده‌سازی camera/microphone permissions
- [ ] تنظیم media constraints و quality settings
- [ ] ایجاد UI برای video calling
- [ ] تست performance در حالت video call

---

**نکته:** هر فاز باید کاملاً تست شده و پایدار باشد قبل از شروع فاز بعدی.
