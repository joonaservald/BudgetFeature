import SwiftUI

struct BudgetErrorView: View {
	let onRetry: () async -> Void

	var body: some View {
		VStack(spacing: 16) {
			Image(systemName: "exclamationmark.triangle")
				.font(.system(size: 40))
				.foregroundStyle(BudgetFeatureColors.secondaryText)

			Text("error.title", bundle: .module)
				.font(.system(size: 18, weight: .semibold))
				.foregroundStyle(BudgetFeatureColors.primaryText)

			Text("error.message", bundle: .module)
				.font(.system(size: 14))
				.foregroundStyle(BudgetFeatureColors.secondaryText)
				.multilineTextAlignment(.center)

			Button {
				Task { await onRetry() }
			} label: {
				Text("error.retry", bundle: .module)
					.font(.system(size: 16, weight: .semibold))
					.foregroundStyle(.white)
					.padding(.horizontal, 32)
					.padding(.vertical, 12)
					.background(
						Capsule()
							.fill(BudgetFeatureColors.accent)
					)
			}
			.padding(.top, 8)
		}
		.padding()
	}
}

#Preview {
	BudgetErrorView(onRetry: {})
		.frame(maxWidth: .infinity, maxHeight: .infinity)
}
