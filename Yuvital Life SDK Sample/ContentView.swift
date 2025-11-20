//
//  ContentView.swift
//  Yuvital Life SDK Sample
//
//  Created by Naum Asafov on 20/11/2025.
//

import SwiftUI

private struct YuvitalCardConfig: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let isPrimary: Bool
    let isClickable: Bool
}

extension Color {
    static let yuvitalPrimaryCard = Color(red: 0.40, green: 0.45, blue: 0.88)
    static let yuvitalSecondaryCard = Color(red: 0.09, green: 0.09, blue: 0.12)
}

struct ContentView: View {
    private let cards: [YuvitalCardConfig] = [
        .init(
            title: "Open Yuvital Life",
            imageName: "yuvital_life",
            isPrimary: true,
            isClickable: true
        ),
        .init(title: "Heart rate", imageName: "heart_metric_icon", isPrimary: false, isClickable: false),
        .init(title: "Nutrition", imageName: "nutrition_metric_icon", isPrimary: false, isClickable: false),
        .init(title: "Sleep", imageName: "sleep_metric_icon", isPrimary: false, isClickable: false),
        .init(title: "Mindfulness", imageName: "mindfulness_metric_icon", isPrimary: false, isClickable: false),
        .init(title: "Walking", imageName: "walking_metric_icon", isPrimary: false, isClickable: false)
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(cards) { card in
                        YuvitalLifeCardView(
                            config: card,
                            action: card.isClickable ? { openYuvitalLife() } : nil
                        )
                    }
                }
                .padding(16)
            }
        }
    }

    private func openYuvitalLife() {
        print("Open Yuvital Life tapped")
    }
}

private struct YuvitalLifeCardView: View {
    let config: YuvitalCardConfig
    let action: (() -> Void)?

    var body: some View {
        let cardBackground = config.isPrimary ? Color.yuvitalPrimaryCard : Color.yuvitalSecondaryCard

        Group {
            if let action {
                Button(action: action) {
                    cardContent(background: cardBackground)
                }
                .buttonStyle(.plain)
            } else {
                cardContent(background: cardBackground)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
    }

    @ViewBuilder
    private func cardContent(background: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(background)

            VStack(spacing: 16) {
                Image(config.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)

                Text(config.title)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
        }
    }
}

#Preview {
    ContentView()
}
