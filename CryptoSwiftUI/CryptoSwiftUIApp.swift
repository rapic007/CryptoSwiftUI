import SwiftUI

@main
struct CryptoSwiftUIApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(vm)
        }
    }
}
