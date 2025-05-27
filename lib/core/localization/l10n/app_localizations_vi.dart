// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Đặt Phòng Khách Sạn';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navPromos => 'Khuyến mãi';

  @override
  String get navBookings => 'Đặt phòng';

  @override
  String get navOffers => 'Ưu đãi';

  @override
  String get navAccount => 'Tài khoản';

  @override
  String homeWelcome(String userName) {
    return 'Chào mừng trở lại, $userName!';
  }

  @override
  String get homeSearchHint => 'Bạn muốn đi đâu?';

  @override
  String get homePopularDestinations => 'Điểm đến phổ biến';

  @override
  String get homeTopRated => 'Đánh giá cao';

  @override
  String get homeRecentlyViewed => 'Đã xem gần đây';

  @override
  String get homeViewAll => 'Xem tất cả';

  @override
  String get bookingsTitle => 'Đặt phòng của tôi';

  @override
  String get bookingsUpcoming => 'Sắp tới';

  @override
  String get bookingsCompleted => 'Đã hoàn thành';

  @override
  String get bookingsCancelled => 'Đã hủy';

  @override
  String get bookingsNoBookings => 'Không tìm thấy đặt phòng';

  @override
  String bookingsTotal(int count) {
    return 'Tổng: $count đặt phòng';
  }

  @override
  String get accountTitle => 'Tài khoản của tôi';

  @override
  String get accountSignIn => 'Đăng nhập hoặc Đăng ký';

  @override
  String get accountSignInMsg => 'Đăng nhập để truy cập các đặt phòng, khách sạn đã lưu và ưu đãi cá nhân.';

  @override
  String get accountPersonalInfo => 'Thông tin cá nhân';

  @override
  String get accountPaymentMethods => 'Phương thức thanh toán';

  @override
  String get accountLoyaltyProgram => 'Chương trình khách hàng thân thiết';

  @override
  String get accountBookingHistory => 'Lịch sử đặt phòng';

  @override
  String get accountPreferences => 'Tùy chọn';

  @override
  String get accountLanguage => 'Ngôn ngữ';

  @override
  String get accountSupport => 'Hỗ trợ';

  @override
  String get accountHelpCenter => 'Trung tâm trợ giúp';

  @override
  String get accountContactUs => 'Liên hệ với chúng tôi';

  @override
  String get accountPrivacyPolicy => 'Chính sách bảo mật';

  @override
  String get accountTerms => 'Điều khoản & Điều kiện';

  @override
  String get accountSignOut => 'Đăng xuất';

  @override
  String accountVersion(String version) {
    return 'Phiên bản $version';
  }

  @override
  String get languageSelect => 'Chọn ngôn ngữ';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageEnglish => 'English';

  @override
  String languageChanged(String language) {
    return 'Đã thay đổi ngôn ngữ thành: $language';
  }

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get save => 'Lưu';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Sửa';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Lỗi';

  @override
  String get success => 'Thành công';

  @override
  String get loading => 'Đang tải...';

  @override
  String get retry => 'Thử lại';

  @override
  String get noData => 'Không có dữ liệu';

  @override
  String get guest => 'Khách';
}
