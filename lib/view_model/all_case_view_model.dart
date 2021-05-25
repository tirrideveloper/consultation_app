import 'package:consultation_app/locator.dart';
import 'package:consultation_app/models/case_model.dart';
import 'package:consultation_app/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';

enum AllCaseViewState { Idle, Loaded, Busy }

class AllCaseViewModel with ChangeNotifier {
  AllCaseViewState _state = AllCaseViewState.Idle;

  List<CaseModel> _allCases;
  CaseModel _lastLoadedCase;
  static final valuePerPage = 10;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  UserRepository _userRepository = locator<UserRepository>();

  List<CaseModel> get caseList => _allCases;

  AllCaseViewState get state => _state;

  set state(AllCaseViewState value) {
    _state = value;
    notifyListeners();
  }

  AllCaseViewModel() {
    _allCases = [];
    _lastLoadedCase = null;
    getCasesWithPagination(_lastLoadedCase, false);
  }

  getCasesWithPagination(CaseModel lastLoadedCase, bool newCasesGetting) async {
    if (_allCases.length > 0) {
      _lastLoadedCase = _allCases.last;
    }

    if (newCasesGetting) {
    } else
      state = AllCaseViewState.Busy;

    List<CaseModel> newList = await _userRepository.getCaseWithPagination(
        _lastLoadedCase, valuePerPage);

    if (newList.length < valuePerPage) _hasMore = false;

    _allCases.addAll(newList);

    state = AllCaseViewState.Loaded;
  }

  Future<void> getMoreCase() async {
    if (_hasMore) getCasesWithPagination(_lastLoadedCase, true);
    await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> refresh() async {
    _hasMore = true;
    _lastLoadedCase = null;
    _allCases = [];
    getCasesWithPagination(_lastLoadedCase, true);
    return null;
  }
}
