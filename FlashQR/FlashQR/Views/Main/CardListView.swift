import SwiftUI
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \QRCard.createdAt, order: .reverse) private var cards: [QRCard]
    @State private var settings = AppSettings()
    @State private var purchaseManager = PurchaseManager()
    @State private var showingAddCard = false
    @State private var selectedCard: QRCard?
    @State private var showingSettings = false

    private var freeCardLimit: Int { 3 }

    var body: some View {
        NavigationStack {
            Group {
                if cards.isEmpty {
                    emptyStateView
                } else {
                    cardList
                }
            }
            .navigationTitle("FlashQR")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddCard = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingAddCard) {
                AddCardView(purchaseManager: purchaseManager, cardCount: cards.count)
            }
            .sheet(item: $selectedCard) { card in
                QRDisplayView(card: card)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(purchaseManager: purchaseManager, settings: settings)
            }
        }
        .overlay {
            if !settings.hasCompletedOnboarding {
                OnboardingView(settings: settings)
            }
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Cards Yet", systemImage: "qrcode")
        } description: {
            Text("Add your first QR code to get started")
        } actions: {
            Button("Add Card") { showingAddCard = true }
                .buttonStyle(.borderedProminent)
        }
    }

    private var cardList: some View {
        List {
            if !cards.filter(\.isFavorite).isEmpty {
                Section("Favorites") {
                    ForEach(cards.filter(\.isFavorite)) { card in
                        CardRowView(card: card)
                            .onTapGesture { selectedCard = card }
                            .swipeActions(edge: .trailing) { deleteButton(for: card) }
                            .swipeActions(edge: .leading) { favoriteButton(for: card) }
                    }
                }
            }

            Section(cards.filter(\.isFavorite).isEmpty ? "All Cards" : "Other Cards") {
                ForEach(cards.filter { !$0.isFavorite }) { card in
                    CardRowView(card: card)
                        .onTapGesture { selectedCard = card }
                        .swipeActions(edge: .trailing) { deleteButton(for: card) }
                        .swipeActions(edge: .leading) { favoriteButton(for: card) }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func deleteButton(for card: QRCard) -> some View {
        Button(role: .destructive) {
            withAnimation { modelContext.delete(card) }
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }

    private func favoriteButton(for card: QRCard) -> some View {
        Button {
            card.isFavorite.toggle()
        } label: {
            Label(card.isFavorite ? "Unfavorite" : "Favorite",
                  systemImage: card.isFavorite ? "star.slash" : "star")
        }
        .tint(.yellow)
    }
}
