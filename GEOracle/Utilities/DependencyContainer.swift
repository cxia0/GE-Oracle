//
//  Dependencies.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 11/05/2025.
//

import Foundation

typealias DC = DependencyContainer

final class DependencyContainer: @unchecked Sendable {

	static let shared = DependencyContainer()

	private init() {}

	private var dependencies = [String: Any]()

	private var queue = DispatchQueue(
		label: "georacle.dependencies",
		attributes: .concurrent
	)

	func register<Dependency: Sendable>(
		_ dependency: Dependency,
		forType type: Dependency.Type
	) {
		self.queue.async(flags: .barrier) {
			self.dependencies["\(type)"] = dependency
		}
	}

	func register<Dependency: Sendable>(
		_ factory: @escaping @Sendable () -> Dependency,
		forType type: Dependency.Type,
	) {
		self.queue.async(flags: .barrier) {
			self.dependencies["\(type)"] = factory
		}
	}

	func resolve<Dependency: Sendable>(forType type: Dependency.Type) -> Dependency? {
		var result: Dependency?
		self.queue.sync {
			guard let value = self.dependencies["\(type)"] else { return }
			switch value {
			case let dependency as Dependency:
				result = dependency
			case let factory as () -> Dependency:
				result = factory()
			default:
				break
			}
		}
		return result
	}
}
