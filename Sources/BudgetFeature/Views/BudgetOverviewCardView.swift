import SwiftUI

struct BudgetOverviewCardView: View {
	let data: BudgetOverviewData
	
	var body: some View {
		HStack(alignment: .center, spacing: 24) {
			BudgetRemainingCircleView(
				remaining: data.remaining,
				progress: data.progress,
				isOverBudget: data.isOverBudget
			)
			.frame(maxWidth: .infinity)
			
			VStack(alignment: .leading, spacing: 30) {
				statRow(
					icon: "chart.bar.fill",
					label: "BUDGET",
					value: "€\(data.totalBudget.formatted2Decimals())",
					iconColor: .gray
				)
				
				statRow(
					icon: "flame.fill",
					label: "SPENT",
					value: "€\(data.totalSpent.formatted2Decimals())",
					iconColor: Color(red: 0.5, green: 0.5, blue: 1.0)
				)
			}
		}
		.padding(.horizontal, 24)
		.padding(.vertical, 36)
		.background(
			RoundedRectangle(cornerRadius: 20)
				.fill(AppColors.cardBackground)
		)
	}
	
	private func statRow(
		icon: String,
		label: String,
		value: String,
		iconColor: Color
	) -> some View {
		HStack(spacing: 12) {
			Image(systemName: icon)
				.font(.system(size: 24))
				.foregroundColor(iconColor)
				.frame(width: 36)
			
			VStack(alignment: .trailing, spacing: 2) {
				Text(label)
					.font(.system(size: 10, weight: .semibold))
					.foregroundColor(.gray)
					.tracking(0.5)
					.lineLimit(1)
					.allowsTightening(true)
					.frame(width: 85, alignment: .leading)
					.fixedSize(horizontal: true, vertical: false)
				
				Text(value)
					.font(.system(size: 16, weight: .semibold))
					.monospacedDigit()
					.foregroundColor(.white)
					.contentTransition(.numericText())
					.lineLimit(1)
					.allowsTightening(true)
					.frame(width: 85, alignment: .leading)
					.fixedSize(horizontal: true, vertical: false)
			}
			
		}
	}
}
