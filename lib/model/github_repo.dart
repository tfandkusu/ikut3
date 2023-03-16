import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_repo.freezed.dart';

@freezed
class GithubRepo with _$GithubRepo {
  /// GitHubのリポジトリと、いいねを付けたフラグ。freezedの動作確認用。後で消す。
  ///
  /// [id] GitHubのリポジトリのID
  /// [name] リポジトリ名
  /// [description] 説明文
  /// [updatedAt] 更新日時
  /// [language] プログラミング言語
  /// [fork] フォークされたリポジトリであるフラグ
  /// [defaultBranch] デフォルトブランチ(mainまたはmaster)
  /// [favorite] いいねを付けたフラグ
  const factory GithubRepo(
      {required int id,
      required String name,
      required String description,
      required DateTime updatedAt,
      required String language,
      required bool fork,
      required String defaultBranch,
      required bool favorite}) = _GithubRepo;
}
