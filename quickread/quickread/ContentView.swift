import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            ForYouTabView()
                .tabItem {
                    Label("For You", systemImage: "heart")
                }
            
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }

//
//            LibraryView()
//                .tabItem {
//                    Label("Library", systemImage: "book")
//                }
        }
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    SearchBarView()
//                    FeaturedContentView(viewModel: FeaturedContentViewModel())
////                    CategoriesView()
////                    RecentlyAddedView()
////                    ReadingProgressView()
////                    DailyPickView()
//                }
//                .padding()
//            }
//            .navigationTitle("Blinkist Home")
//        }
    }
}

