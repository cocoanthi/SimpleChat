//
//  Logger.swift
//  SimpleChat
//
//  Created by 矢口諒 on 2024/06/08.
//

import Foundation

/// Loggerクラス
class Logger {
    static func info(
        _ message: String = "",
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        let logMessage = "Info : \(message)(\(file) \(function) Line:\(line))"
        print(logMessage)
    }
    
    static func error(
        _ message: String = "",
        error: Error? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        let logMessage = "Trace: \(message)(\(file) \(function) Line:\(line)) \(error?.localizedDescription ?? "")"
        print(logMessage)
    }
}
