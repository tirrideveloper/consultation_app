class Errors {
  static String showError(String errorCode) {
    switch (errorCode) {
      case 'emaıl-already-ın-use':
        return "Bu email adresi kullanılmaktadır, farklı bir email kullanınız";

      case 'user-not-found':
        return "Bu kullanıcı bulunumadı. Lütfen bilgilerinizi kontrol ediniz.";

      case 'wrong-password':
        return "Şifreniz yanlış. Lütfen bilgilerinizi kontrol edip tekrar deneyiniz.";

      default:
        return "Bir hata oluştu";
    }
  }
}
