import SwiftUI

struct BudgetRemainingCircleView: View {
	let remaining: Decimal
	let progress: Double
	let isOverBudget: Bool
	
	private let circleSize: CGFloat = 140
	private let lineWidth: CGFloat = 16
	
	var body: some View {
		ZStack {
			Circle()
				.stroke(Color.white.opacity(0.1), lineWidth: lineWidth)
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
				Color(red: 0.4, green: 0.4, blue: 1.0),
				Color(red: 0.7, green: 0.5, blue: 1.0)
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
			Text("\(abs(remaining).formatted2Decimals())")
				.font(.system(size: 24, weight: .bold, design: .rounded))
				.foregroundColor(isOverBudget ? Color(red: 0.8, green: 0.3, blue: 0.3) : .white)
				.contentTransition(.numericText())
			
			Text(isOverBudget ? "OVER BUDGET" : "REMAINING")
				.font(.system(size: 11, weight: .bold))
				.foregroundColor(.gray)
				.tracking(1)
		}
	}
}
