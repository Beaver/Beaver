import PromiseKit

// MARK: - SafePromise

public struct SafePromise<T> {
    fileprivate let promise: Promise<T>

    public init(resolver: (_ fulfill: @escaping (T) -> Void) throws -> Void) {
        self.promise = Promise { fulfill, _ in
            try resolver(fulfill)
        }
    }

    public init(value: T) {
        self.promise = Promise(value: value)
    }

    fileprivate init(_ promise: Promise<T>) {
        self.promise = promise
    }

    @discardableResult
    public func then<U>(on q: DispatchQueue = .default, execute body: @escaping (T) throws -> U) -> SafePromise<U> {
        return then(on: q, execute: { (arg: T) -> SafePromise<U> in
            return SafePromise<U>(value: try body(arg))
        })
    }

    @discardableResult
    public func then<U>(on q: DispatchQueue = .default, execute body: @escaping (T) throws -> SafePromise<U>) -> SafePromise<U> {
        return SafePromise<U>(promise.then(on: q, execute: { (arg: T) -> Promise<U> in
            return try body(arg).promise
        }))
    }

    public func unsafeThen<U, E>(on q: DispatchQueue = .default, execute body: @escaping (T) throws -> U) -> UnsafePromise<U, E> {
        return UnsafePromise(then(on: q, execute: body).promise)
    }

    public func unsafeThen<U, E>(on q: DispatchQueue = .default, execute body: @escaping (T) throws -> UnsafePromise<U, E>) -> UnsafePromise<U, E> {
        return UnsafePromise(then(on: q, execute: { (arg: T) -> SafePromise<U> in
            return SafePromise<U>(try body(arg).promise)
        }).promise)
    }

    @discardableResult
    public func always(on q: DispatchQueue = .default, execute body: @escaping () -> Void) -> SafePromise {
        return SafePromise(promise.always(on: q, execute: body))
    }

    public func asVoid() -> SafePromise<Void> {
        return SafePromise<Void>(promise.asVoid())
    }

    public typealias PendingTuple = (promise: SafePromise, fulfill: (T) -> Void)

    public static func pending() -> PendingTuple {
        var fulfill: ((T) -> Void)!
        let promise = self.init { fulfill = $0 }
        return (promise, fulfill)
    }
}

public func safeAfter(interval: TimeInterval) -> SafePromise<Void> {
    return SafePromise { fulfill in
        let when = DispatchTime.now() + interval
        DispatchQueue.global().asyncAfter(deadline: when, execute: fulfill)
    }
}

public func safely<T>(execute body: () -> SafePromise<T>) -> SafePromise<T> {
    return body()
}

// MARK: - UnsafePromise

public struct UnsafePromise<T, E: Error> {
    fileprivate let promise: Promise<T>

    public init(resolvers: (_ fulfill: @escaping (T) -> Void, _ reject: @escaping (E) -> Void) throws -> Void) {
        self.promise = Promise(resolvers: resolvers)
    }

    public init(value: T) {
        self.promise = Promise(value: value)
    }

    public init(error: E) {
        self.promise = Promise(error: error)
    }

    fileprivate init(_ promise: Promise<T>) {
        self.promise = promise
    }

    public typealias PendingTuple = (promise: UnsafePromise, fulfill: (T) -> Void, reject: (E) -> Void)

    public static func pending() -> PendingTuple {
        var fulfill: ((T) -> Void)!
        var reject: ((E) -> Void)!
        let promise = self.init { fulfill = $0
            reject = $1 }
        return (promise, fulfill, reject)
    }

    public func then<U>(on q: DispatchQueue = .default, execute body: @escaping (T) throws -> U) -> UnsafePromise<U, E> {
        return then(on: q, execute: { (arg: T) -> UnsafePromise<U, E> in
            return UnsafePromise<U, E>(value: try body(arg))
        })
    }

    public func then<U>(on q: DispatchQueue = .default, execute body: @escaping (T) throws -> UnsafePromise<U, E>) -> UnsafePromise<U, E> {
        return UnsafePromise<U, E>(promise.then(on: q, execute: { (arg: T) -> Promise<U> in
            return try body(arg).promise
        }))
    }

    @discardableResult
    public func always(on q: DispatchQueue = .default, execute body: @escaping () -> Void) -> UnsafePromise {
        return UnsafePromise(promise.always(on: q, execute: body))
    }

    public func asVoid() -> UnsafePromise<Void, E> {
        return UnsafePromise<Void, E>(promise.asVoid())
    }

    @discardableResult
    public func `catch`(on q: DispatchQueue = .default,
                        policy: CatchPolicy = .allErrorsExceptCancellation,
                        execute body: @escaping (E) -> Void = { _ in
                        }) -> SafePromise<T> {
        return SafePromise(self.promise.catch(on: q, policy: policy, execute: { error in
            guard let handledError = error as? E else {
                fatalError("Unhandled error \(error)")
            }

            body(handledError)
        }))
    }

    @discardableResult
    public func recover(on q: DispatchQueue = .default,
                        policy: CatchPolicy = .allErrorsExceptCancellation,
                        execute body: @escaping (E) -> SafePromise<T>) -> SafePromise<T> {
        return SafePromise(mapError(on: q, policy: policy) { error in
            return UnsafePromise(body(error).promise)
        }.promise)
    }

    public func mapError<EE: Error>(on q: DispatchQueue = .default,
                                    policy: CatchPolicy = .allErrorsExceptCancellation,
                                    execute body: @escaping (E) -> UnsafePromise<T, EE>) -> UnsafePromise<T, EE> {
        return UnsafePromise<T, EE> { fulfill, reject in
            _ = self.promise.then { result -> () in
                fulfill(result)
            }.recover(on: q, policy: policy) { error -> () in
                guard let handledError = error as? E else {
                    fatalError("Unhandled error \(error)")
                }

                _ = body(handledError).then { result in
                    fulfill(result)
                }.catch(on: q, policy: policy) { error in
                    reject(error)
                }
            }
        }
    }
}

public func unsafely<T, E: Error>(execute body: () -> UnsafePromise<T, E>) -> UnsafePromise<T, E> {
    return body()
}