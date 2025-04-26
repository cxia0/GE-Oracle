//
//  Cache.swift
//  GEOracle
//
//  Created by Chunfeng Xia on 25/04/2025.
//

import Foundation

protocol KeyValueCache<Key, Value> {
	associatedtype Key: Hashable
	associatedtype Value

	func value(forKey: Key) -> Value?
	func insert(_ value: Value, forKey: Key)
	func removeValue(forKey: Key)
}

class Cache<Key: Hashable, Value>: KeyValueCache {

	private var cache = NSCache<WrappedKey, WrappedValue>()

	func value(forKey key: Key) -> Value? {
		let wrappedKey = WrappedKey(key)
		return self.cache.object(forKey: wrappedKey)?.value
	}

	func insert(_ value: Value, forKey key: Key) {
		self.cache.setObject(
			WrappedValue(value),
			forKey: WrappedKey(key)
		)
	}

	func removeValue(forKey key: Key) {
		self.cache.removeObject(forKey: WrappedKey(key))
	}
}

extension Cache {

	private class WrappedValue {
		let value: Value
		init(_ value: Value) {
			self.value = value
		}
	}

	private class WrappedKey {
		let key: Key
		init(_ key: Key) {
			self.key = key
		}
	}
}
