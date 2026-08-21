# SimpleChat

SimpleChatはSwiftUIとFirebaseを用いたシンプルなチャットアプリです。
主にFirebase学習のために作成しました。

https://github.com/user-attachments/assets/6eb2daed-f76e-4661-b36a-bad3437d65f1

## 主な機能

- ユーザー認証（サインイン・サインアップ・パスワードリセット）
- グループチャット
- メッセージ送信・履歴表示
- ユーザー情報管理
- モダンなUI（カスタムテーマカラー）

## 技術スタック

- SwiftUI
- Firebase（Auth, Firestore）
- Combine

## セットアップ方法

1. このリポジトリをクローン
2. `SimpleChat/SimpleChat/Configration/GoogleService-Info.plist` をFirebaseコンソールから取得し、配置
3. Xcodeでプロジェクトを開く
4. 必要に応じて `pod install` または Swift Package Manager で依存関係を解決
5. 実機またはシミュレータでビルド・実行

## ディレクトリ構成

- `Model/` ... データモデル
- `View/` ... 画面UI
- `ViewModel/` ... ビジネスロジック
- `Extension/` ... Swift拡張
- `Util/` ... ユーティリティ
- `Configration/` ... Firebase設定

## ライセンス

MIT
