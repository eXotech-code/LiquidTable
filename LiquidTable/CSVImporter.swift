//
//  CSVImporter.swift
//  LiquidTable
//
//  Created by Jakub Piskiewicz on 11/11/2023.
//

import SwiftUI

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

enum CSVImporterError: LocalizedError {
    case separatorNotFound, fileImportError(_ underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .separatorNotFound:
            return "Couldn't infer the separator from the given file."
        case .fileImportError(let underlyingError):
            return underlyingError.localizedDescription
        }
    }
}

struct CSVColumn: Identifiable {
    var name: String
    var id: Int
}

struct CSVCell: Identifiable {
    var content: String.SubSequence
    var id: Int
}

struct CSVRow: Identifiable {
    var content: [CSVCell]
    var id: Int
    
    init(content: [String.SubSequence], id: Int) {
        self.id = id
        self.content = content.enumerated().map { (i, cellContent) in CSVCell(content: cellContent, id: i) }
    }
}

class CSVFile: ObservableObject {
    private var lines: [String.SubSequence]?
    @Published var contentView: [CSVRow]?
    var importError: CSVImporterError?
    @Published var columns: [CSVColumn]?
    
    init(_ contentURL: URL) {
        do {
            let contents = try String(contentsOf: contentURL)
            lines = contents.split(whereSeparator: \.isNewline)
        } catch {
            importError = CSVImporterError.fileImportError(error)
        }
            
    }
    
    func detectSeparator() throws -> SeparatorType {
        for s in SeparatorType.allCases {
            let firstTwo = lines![..<2].map({ line in return line.split(separator: s.sepString).count })
            if (firstTwo[0] != 1 && firstTwo[0] == firstTwo[1]) {
                return s
            }
        }
        
        throw CSVImporterError.separatorNotFound
    }
    
    func parseCSV(separator: SeparatorType) {
        contentView = lines!.enumerated().map { (i, line) in CSVRow(content: line.split(separator: separator.sepString), id: i) }
        columns = contentView![0].content.enumerated().map { (i, cell) in CSVColumn(name: String(cell.content), id: i) }
    }
}
