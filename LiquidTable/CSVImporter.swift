//
//  CSVImporter.swift
//  LiquidTable
//
//  Created by Jakub Piskiewicz on 11/11/2023.
//

import Foundation

enum SeparatorType: String, CaseIterable, Identifiable {
    case comma, semicolon, tab, space
    var id: Self { self }
    
    var sepString: String {
        switch self {
        case .comma:
            return ","
        case .semicolon:
            return ";"
        case .tab:
            return "\t"
        case .space:
            return " "
        }
    }
}

enum SeparatorDetectionError: Error {
    case separatorNotFound
    case readingFileFailed(underlyingError: Error)
}

struct CSVFile {
    private var fileContents: String?
    private var contentView: Array<Array<Substring>>?
    
    mutating func load(_ contentURL: URL) throws -> SeparatorType? {
        do {
            let contents = try String(contentsOf: contentURL)
            return try? detectSeparator(contents)
        } catch {
            print(error)
            throw SeparatorDetectionError.readingFileFailed(underlyingError: error)
        }
        
    }
    
    func detectSeparator(_ content: String) throws -> SeparatorType {
        let lines = content.split(whereSeparator: \.isNewline)
        for s in SeparatorType.allCases {
            let firstTwo = lines[..<2].map({ line in return line.split(separator: s.sepString).count })
            if (firstTwo[0] != 1 && firstTwo[0] == firstTwo[1]) {
                return s
            }
        }
        
        throw SeparatorDetectionError.separatorNotFound
    }
    
    mutating func parseCSV(providedSeparator: SeparatorType) {
    }
}
