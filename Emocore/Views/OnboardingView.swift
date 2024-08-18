import SwiftUI

struct OnboardingRow: View {
    var imageName: String
    var title: String
    var subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: imageName)
                .font(.system(size: 36))
                .foregroundStyle(.accent)
                .accessibilityHidden(true)
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

struct OnboardingView: View {
    var onButtonPress: () -> Void

    var body: some View {
        VStack(spacing: 64) {
            VStack {
                Text(Bundle.main.displayName)
                    .font(.largeTitle)
                    .bold()
                    .accessibilityHeading(.h1)
                Text("The missing State of Mind Shortcuts")
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            VStack(spacing: 32) {
                OnboardingRow(
                    imageName: "brain.head.profile",
                    title: "State of Mind Shortcuts",
                    subtitle: """
                    Use Siri Shortcuts to log, find, and filter State of Mind entries from Apple Health and other apps.
                    """
                )
                OnboardingRow(
                    imageName: "hand.raised.fill",
                    title: "Everything On Device",
                    subtitle: """
                    All your data remains on your device. \(Bundle.main.displayName) is open source and auditable.
                    """
                )
            }
            Button {
                onButtonPress()
            } label: {
                Spacer()
                Text("Allow Health Access")
                Spacer()
            }
            .bold()
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(.horizontal, 36)
    }
}

#Preview {
    OnboardingView {}
}
