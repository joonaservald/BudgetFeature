import SwiftUI

struct BudgetRemainingCircleView: View {
	let remaining: Decimal
	let progress: Double
	let isOverBudget: Bool
	let currencyCode: String
	
	private let circleSize: CGFloat = 140
	private let lineWidth: CGFloat = 16
	
	var body: some View {
		ZStack {
			Circle()
				.stroke(BudgetFeatureColors.circleTrack, lineWidth: lineWidth)
				.frame(width: circleSize, height: circleSize)
			
			Circle()
				.trim(from: 0, to: progress)
				.stroke(progressGradient, style: strokeStyle)
				.frame(width: circleSize, height: circleSize)
				.rotationEffect(.degrees(135))
			
			centerContentView
		}
	}
	
	private var progressGradient: LinearGradient {
		LinearGradient(
			colors: [
				BudgetFeatureColors.progressGradientStart,
				BudgetFeatureColors.progressGradientEnd
			],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
	}
	
	private var strokeStyle: StrokeStyle {
		StrokeStyle(lineWidth: lineWidth, lineCap: .round)
	}
	
	private var centerContentView: some View {
		VStack(spacing: 2) {
			Text("\(abs(remaining).formatted(.currency(code: currencyCode)))")
				.font(.system(size: 24, weight: .bold, design: .rounded))
				.foregroundColor(isOverBudget ? BudgetFeatureColors.overBudget : BudgetFeatureColors.primaryText)
				.lineLimit(1)
				.allowsTightening(true)
				.minimumScaleFactor(0.7)
				.frame(width: 100)
				.contentTransition(.numericText())
			
			Text(isOverBudget ? "budget.circle.over" : "budget.circle.remaining", bundle: .module)
				.font(.system(size: 11, weight: .bold))
				.foregroundColor(BudgetFeatureColors.secondaryText)
				.lineLimit(1)
				.minimumScaleFactor(0.7)
				.frame(width: 100)
				.tracking(1)
		}
	}
}
