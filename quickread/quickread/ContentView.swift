import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    SearchBarView()
                    FeaturedContentView()
//                    CategoriesView()
//                    RecentlyAddedView()
//                    ReadingProgressView()
//                    DailyPickView()
                }
                .padding()
            }
            .navigationTitle("Blinkist Home")
        }
    }
}

