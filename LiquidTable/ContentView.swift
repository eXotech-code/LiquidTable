//
//  ContentView.swift
//  LiquidTable
//
//  Created by Jakub Piskiewicz on 11/11/2023.
//

import SwiftUI

enum TableType: String, CaseIterable, Identifiable {
    case bordered, plain
    var id: Self { self }
    
    var content: (name: String, systemImage: String, image: String) {
        switch self {
        case .bordered:
            return ("Bordered", "", "custom.tablecells")
        case .plain:
            return ("Plain", "rectangle.dashed", "")
        }
    }
    
    var label: some View {
        if content.systemImage.isEmpty {
            return Label(content.name, image: content.image)
        }
        return Label(content.name, systemImage: content.systemImage)
    }
}

extension SeparatorType {    
    var content: String {
        switch self {
        case .comma:
            return "Comma"
        case .semicolon:
            return "Semicolon"
        case .tab:
            return "Tab"
        case .space:
            return "Space"
        }
    }
    
    var text: some View {
        return Text(content)
    }
}

struct ContentView: View {
    @State private var windowTitle = "LiquidTable"
    @State private var presentFileImporter = true
    @State private var selectedTableType: TableType = .bordered
    @State private var selectedSeparator: SeparatorType = .comma
    @State private var csvFile: CSVFile?
    @State private var presentAlert = false
    @State private var importError: CSVImporterError? = nil
    
    func setWindowTitle(_ selectedCSVFile: URL) {
        windowTitle = selectedCSVFile.lastPathComponent
    }
    
    var body: some View {
        HStack {
            if csvFile?.contentView != nil {
                TableView(csvFile!)
            } else {
                Spacer()
            }
            VStack {
                Text("Columns")
                    .font(.headline)
            }
        }
            .navigationTitle(windowTitle)
            .toolbar {
                ControlGroup {
                    HStack {
                        Button(action: {}) {
                            Label("Embed Text In Math Equation", systemImage: "function")
                        }.disabled(true)
                        Divider()
                        Button(action: {}) {
                            Label("Extract Text From Math Equation", systemImage: "textformat.abc")
                        }.disabled(true)
                    }
                    Spacer()
                    Picker("Table Type", selection: $selectedTableType) {
                        ForEach(TableType.allCases) { type in
                            type.label
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Picker("Separator", selection: $selectedSeparator) {
                        ForEach(SeparatorType.allCases) { type in
                            type.text
                        }
                    }
                }
                
            }
            .fileImporter(isPresented: $presentFileImporter, allowedContentTypes: [.plainText]) { result in
                defer { presentFileImporter = false }
                switch result {
                case .success(let url):
                    if url.startAccessingSecurityScopedResource() {
                        defer { url.stopAccessingSecurityScopedResource() }
                        setWindowTitle(url)
                        csvFile = CSVFile(url)
                        if csvFile!.importError != nil {
                            presentAlert = true
                            importError = csvFile!.importError
                            return
                        }
                        if let inferredSep = try? csvFile!.detectSeparator() {
                            selectedSeparator = inferredSep
                        }
                        csvFile!.parseCSV(separator: selectedSeparator)
                    }
                case .failure(let err):
                    print(err)
                }
            }
            .alert(isPresented: $presentAlert, error: importError) {
                Button("Choose Another File") {
                    presentFileImporter = true
                }
                Button("Quit LiquidTable") {
                    NSApplication.shared.terminate(nil)
                }
            }
    }
}

#Preview {
    ContentView()
        .frame(width: 900.0, height: 480.0)
}
