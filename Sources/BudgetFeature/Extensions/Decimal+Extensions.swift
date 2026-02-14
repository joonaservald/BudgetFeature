import Foundation

extension Decimal {

	func formatted2Decimals() -> String {
		String(format: "%.2f", NSDecimalNumber(decimal: self).doubleValue)
	}

	func rounded(_ scale: Int) -> Decimal {
		var value = self
		var result = Decimal()
		NSDecimalRound(&result, &value, scale, .plain)
		return result
	}
}
