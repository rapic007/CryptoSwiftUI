import SwiftUI

struct InfoView: View {
    
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                List {
                    coinGeckoSection
                        .listRowBackground(Color.theme.background)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Info")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

extension InfoView {
    private var coinGeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data is used in this app comes from a free API from CoinGecko! Price may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko", destination: coingeckoURL)
        }
    }
}
