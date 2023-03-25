import SwiftUI

struct SearchBarView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        TextField("Search", text: $searchText)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}
