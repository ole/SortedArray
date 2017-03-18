/// An array that keeps its elements sorted at all times.
public struct SortedArray<Element> {
    /// The backing store
    fileprivate var _elements: [Element]

    public typealias Comparator<A> = (A, A) -> Bool

    /// The predicate that determines the array's sort order.
    fileprivate let areInIncreasingOrder: Comparator<Element>

    /// Initializes an empty array.
    ///
    /// - Parameter areInIncreasingOrder: The comparison predicate the array should use to sort its elements.
    public init(areInIncreasingOrder: @escaping Comparator<Element>) {
        self._elements = []
        self.areInIncreasingOrder = areInIncreasingOrder
    }

    /// Initializes the array with a sequence of unsorted elements and a comparison predicate.
    public init<S: Sequence>(unsorted: S, areInIncreasingOrder: @escaping Comparator<Element>) where S.Iterator.Element == Element {
        let sorted = unsorted.sorted(by: areInIncreasingOrder)
        self._elements = sorted
        self.areInIncreasingOrder = areInIncreasingOrder
    }

    /// Initializes the array with a sequence that is already sorted according to the given comparison predicate.
    ///
    /// This is faster than `init(unsorted:areInIncreasingOrder:)` because the elements don't have to sorted again.
    ///
    /// - Precondition: `sorted` is sorted according to the given comparison predicate. If you violate this condition, the behavior is undefined.
    public init<S: Sequence>(sorted: S, areInIncreasingOrder: @escaping Comparator<Element>) where S.Iterator.Element == Element {
        self._elements = Array(sorted)
        self.areInIncreasingOrder = areInIncreasingOrder
    }

    /// Inserts a new element into the array, preserving the sort order.
    ///
    /// - Returns: the index where the new element was inserted.
    /// - Complexity: O(_n_) where _n_ is the size of the array. O(_log n_) if the new
    /// element can be appended, i.e. if it is ordered last in the resulting array.
    @discardableResult
    public mutating func insert(_ newElement: Element) -> Index {
        let index = insertionIndex(for: newElement)
        // This should be O(1) if the element is to be inserted at the end,
        // O(_n) in the worst case (inserted at the front).
        _elements.insert(newElement, at: index)
        return index
    }

    /// Inserts all elements from `elements` into `self`, preserving the sort order.
    ///
    /// This can be faster than inserting the individual elements one after another because
    /// we only need to re-sort once.
    ///
    /// - Complexity: O(_n * log(n)_) where _n_ is the size of the resulting array.
    public mutating func insert<S: Sequence>(contentsOf newElements: S) where S.Iterator.Element == Element {
        _elements.append(contentsOf: newElements)
        _elements.sort(by: areInIncreasingOrder)
    }
}

extension SortedArray where Element: Comparable {
    /// Initializes an empty sorted array. Uses `<` as the comparison predicate.
    public init() {
        self.init(areInIncreasingOrder: <)
    }

    /// Initializes the array with a sequence of unsorted elements. Uses `<` as the comparison predicate.
    public init<S: Sequence>(unsorted: S) where S.Iterator.Element == Element {
        self.init(unsorted: unsorted, areInIncreasingOrder: <)
    }

    /// Initializes the array with a sequence that is already sorted according to the `<` comparison predicate. Uses `<` as the comparison predicate.
    ///
    /// This is faster than `init(unsorted:)` because the elements don't have to sorted again.
    ///
    /// - Precondition: `sorted` is sorted according to the `<` predicate. If you violate this condition, the behavior is undefined.
    public init<S: Sequence>(sorted: S) where S.Iterator.Element == Element {
        self.init(sorted: sorted, areInIncreasingOrder: <)
    }
}

extension SortedArray: RandomAccessCollection {
    public typealias Index = Int

    public var startIndex: Index { return _elements.startIndex }
    public var endIndex: Index { return _elements.endIndex }

    public func index(after i: Index) -> Index {
        return _elements.index(after: i)
    }

    public func index(before i: Index) -> Index {
        return _elements.index(before: i)
    }

    public subscript(position: Index) -> Element {
        return _elements[position]
    }

    public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> SortedArray<Element> {
        let newElements = try _elements.filter(isIncluded)
        return SortedArray(sorted: newElements, areInIncreasingOrder: areInIncreasingOrder)
    }
}

extension SortedArray: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "\(String(describing: _elements)) (sorted)"
    }

    public var debugDescription: String {
        return "<SortedArray> \(String(reflecting: _elements))"
    }
}

// MARK: - More efficient variants of default implementations or implementations that need fewer constraints than the default implementations.
extension SortedArray {
    /// Returns the first index where the specified value appears in the collection.
    ///
    /// - Complexity: O(_log(n)_), where _n_ is the size of the array.
    public func index(of element: Element) -> Index? {
        switch search(for: element) {
        case let .found(at: index): return index
        case .notFound(insertAt: _): return nil
        }
    }

    /// Returns a Boolean value indicating whether the sequence contains the given element.
    ///
    /// - Complexity: O(_log(n)_), where _n_ is the size of the array.
    public func contains(_ element: Element) -> Bool {
        return index(of: element) != nil
    }

    /// Returns the minimum element in the sequence.
    ///
    /// - Complexity: O(1).
    @warn_unqualified_access
    public func min() -> Element? {
        return first
    }

    /// Returns the maximum element in the sequence.
    ///
    /// - Complexity: O(1).
    @warn_unqualified_access
    public func max() -> Element? {
        return last
    }
}

// MARK: - Binary search
extension SortedArray {
    /// The index where `newElement` should be inserted to preserve the array's sort order.
    fileprivate func insertionIndex(for newElement: Element) -> Index {
        switch search(for: newElement) {
        case let .found(at: index): return index
        case let .notFound(insertAt: index): return index
        }
    }
}

fileprivate enum Match<Index: Comparable> {
    case found(at: Index)
    case notFound(insertAt: Index)
}

extension SortedArray {
    /// Searches the array for `newElement` using binary search.
    ///
    /// - Returns: If `newElement` is in the array, returns `.found(at: index)`
    ///   where `index` is the index of the element in the array.
    ///   If `newElement` is not in the array, returns `.notFound(insertAt: index)`
    ///   where `index` is the index where the element should be inserted to 
    ///   preserve the sort order.
    ///   If the array contains multiple elements that are equal to `newElement`,
    ///   there is no guarantee which of these is found.
    ///
    /// - Complexity: O(_log(n)_), where _n_ is the size of the array.
    fileprivate func search(for newElement: Element) -> Match<Index> {
        guard !isEmpty else { return .notFound(insertAt: endIndex) }
        var left = startIndex
        var right = index(before: endIndex)

        while left <= right {
            let dist = distance(from: left, to: right)
            let mid = index(left, offsetBy: dist/2)
            let candidate = self[mid]

            if areInIncreasingOrder(candidate, newElement) {
                left = index(after: mid)
            } else if areInIncreasingOrder(newElement, candidate) {
                right = index(before: mid)
            } else {
                // If neither element comes before the other, they _must_ be
                // equal, per the strict ordering requirement of `areInIncreasingOrder`.
                return .found(at: mid)
            }
        }
        // Not found. left is the index where this element should be placed if it were inserted.
        return .notFound(insertAt: left)
    }
}
