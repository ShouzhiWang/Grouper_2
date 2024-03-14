//
//  LargeGroupsView.swift
//
//
//  Created by 王首之 on 2/24/24.
//

import SwiftUI
/// This file is reserved for future features
struct LargeGroupsView: View {
    @ObservedObject var parser: LargeGroupsParser
    var body: some View {
        List {
            ForEach(parser.parseCSV(), id: \.self) { content in
                Text(content)
            }
        }
    }
}

#Preview {
    LargeGroupsView(parser: LargeGroupsParser())
}
