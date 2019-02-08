//
//  AppDelegate.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/01/22.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // アプリケーションの起動後にカスタマイズのポイントをオーバーライドする。
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // アプリケーションがアクティブ状態から非アクティブ状態に移行しようとしているときに送信されます。 これは、特定の種類の一時的な中断（電話の着信やSMSメッセージなど）、またはユーザーがアプリケーションを終了してバックグラウンド状態への移行を開始したときに発生する可能性がある。
        // このメソッドを使用して、進行中のタスクを一時停止し、タイマーを無効にし、グラフィックレンダリングコールバックを無効にします。 ゲームはゲームを一時停止するためにこのメソッドを使うべき。
        print("アプリ閉じそうな時に呼ばれる")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // このメソッドを使用して、共有リソースの解放、ユーザーデータの保存、タイマーの無効化、および後で終了した場合にアプリケーションを現在の状態に復元するのに十分なアプリケーション状態情報を格納する。
        // アプリケーションがバックグラウンド実行をサポートしている場合は、ユーザーが終了したときにapplicationWillTerminate：の代わりにこのメソッドが呼び出される。
        print("アプリを閉じた時に呼ばれる")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // バックグラウンドからアクティブ状態への移行の一部として呼び出される。 ここでは、背景入力時に加えられた変更の多くを元に戻すことができる。
        print("アプリを開きそうな時に呼ばれる")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // アプリケーションが非アクティブの間に一時停止された（またはまだ開始されていない）タスクを再開する。 アプリケーションが以前にバックグラウンドで動作していた場合は、必要に応じてユーザーインターフェイスを更新する。
        print("アプリを開いた時に呼ばれる")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // アプリケーションが終了しようとしているときに呼び出さる。 必要に応じてデータを保存する。 applicationDidEnterBackground：も参照しなければならない。
        print("フリックしてアプリを終了させた時に呼ばれる")
    }


}

