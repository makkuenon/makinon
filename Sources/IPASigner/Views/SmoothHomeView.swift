import SwiftUI

struct SmoothHomeView: View {
    @EnvironmentObject var signingService: IPASigningService
    @State private var searchText: String = ""
    @State private var cards = [
        HomeCard(title: "Quick Sign", subtitle: "Sign an IPA quickly with default settings", icon: "bolt.fill"),
        HomeCard(title: "Recent IPAs", subtitle: "Open recent builds and sign them", icon: "clock.fill"),
        HomeCard(title: "Guides", subtitle: "Documentation and signing tips", icon: "book.fill")
    ]
    @State private var animateHeader = false

    var body: some View {
        VStack(spacing: 16) {
            // Subtle background handled by parent

            // Glassy header
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome back")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("IPA Signer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "bell.fill")
                        .font(.title3)
                        .padding(10)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 8)
            .scaleEffect(animateHeader ? 1.02 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                    animateHeader.toggle()
                }
            }

            // Search
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search actions, IPAs, guides...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding()
            .background(Color(.systemBackground).opacity(0.9))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 4)

            // Cards
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredCards, id: \.id) { card in
                        HomeCardView(card: card)
                            .padding(.horizontal, 2)
                    }
                }
                .padding(.top, 8)
            }

            Spacer()
        }
        .padding()
    }

    private var filteredCards: [HomeCard] {
        if searchText.isEmpty { return cards }
        return cards.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.subtitle.localizedCaseInsensitiveContains(searchText) }
    }
}

struct HomeCard: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
}

struct HomeCardView: View {
    let card: HomeCard
    @EnvironmentObject var signingService: IPASigningService
    @State private var pressed = false

    var body: some View {
        Button(action: {
            // Quick Sign action: switch to signing tab and open file picker
            if card.title == "Quick Sign" {
                // Signal ContentView to open Signing tab
                NotificationCenter.default.post(name: Notification.Name("OpenSigningTab"), object: nil)

                // Trigger the signing service to show the file picker
                signingService.openFilePicker = true
            }
        }) {
            HStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 52, height: 52)
                    Image(systemName: card.icon)
                        .foregroundColor(.white)
                        .font(.title2)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(card.title)
                        .font(.headline)
                    Text(card.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground).opacity(0.7))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 6)
            .scaleEffect(pressed ? 0.99 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(DragGesture(minimumDistance: 0).onChanged({ _ in
            withAnimation(.easeInOut(duration: 0.08)) { pressed = true }
        }).onEnded({ _ in
            withAnimation(.easeInOut(duration: 0.12)) { pressed = false }
        }))
    }
}

#Preview {
    SmoothHomeView()
}
