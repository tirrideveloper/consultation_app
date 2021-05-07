class Errors{
  static String showError(String errorCode){
    switch(errorCode){
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "Bu email adresi kullanılmaktadır, farklı bir email kullanınız";
      default:
        return "Bir hata oluştu";
    }
  }
}