import SwiftUI

struct ProgressBarView: View {
	let progress: Double
	let tint: Color

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Capsule()
					.fill(BudgetFeatureColors.circleTrack)
					.frame(height: 6)

				Capsule()
					.fill(tint)
					.frame(width: geometry.size.width * min(progress, 1.0), height: 6)
					.animation(.easeInOut, value: progress)
			}
		}
		.frame(height: 6)
	}
}

#Preview {
	ProgressBarView(progress: 0.6, tint: BudgetFeatureColors.categoryFood)
		.padding()
}
