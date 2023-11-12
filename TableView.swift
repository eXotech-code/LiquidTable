//
//  TableView.swift
//  LiquidTable
//
//  Created by Jakub Piskiewicz on 12/11/2023.
//

import SwiftUI

struct TableView: View {
    var csvFile: CSVFile
    let columns: [GridItem]
    
    init(_ content: CSVFile) {
        csvFile = content
        columns = content.columns!.map { _ in GridItem(.flexible()) }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(csvFile.contentView!) { row in
                    ForEach(row.content) { cell in
                        Text(cell.content)
                    }
                }
            }
        }
    }
}
