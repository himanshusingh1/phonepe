//
//  Paginator.swift
//  PhonePe
//
//  Created by Himanshu Singh on 11/05/24.
//
import Foundation

protocol PaginatorDelegate: AnyObject {
    func paginate(to page: Int,for paginator: Paginator)
}

class Paginator {
    internal var page: Int = -1
    internal var previousItemCount: Int = -1
    open var currentPage: Int {
        return page
    }
    
    init(delegate: PaginatorDelegate) {
        self.pagingDelegate = delegate
    }
    
    weak var pagingDelegate: PaginatorDelegate? {
        didSet {
            pagingDelegate?.paginate(to: page, for: self)
        }
    }
    open func reset() {
        page = 0
        previousItemCount = -1
        pagingDelegate?.paginate(to: page, for: self)
    }
    
    private func paginate(_ totalItems:Int, forIndexAt indexPath: IndexPath) {
        let itemCount = totalItems
        guard indexPath.row == itemCount - 1 else {
            return
        }
        guard previousItemCount != itemCount else {
            return
        }
        page += 1
        previousItemCount = itemCount
        pagingDelegate?.paginate(to: page, for: self)
    }
    
    func viewingItemAt(indexPath: IndexPath, currentItemCount: Int) {
        self.paginate(currentItemCount, forIndexAt: indexPath)
    }
}
