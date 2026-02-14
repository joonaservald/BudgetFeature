import Foundation

extension Decimal {

	func rounded(_ scale: Int) -> Decimal {
		var value = self
		var result = Decimal()
		NSDecimalRound(&result, &value, scale, .plain)
		return result
	}
}
