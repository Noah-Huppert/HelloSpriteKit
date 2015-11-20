//
//  UnOrderedSet.swift
//  HelloSpriteKit
//
//  Created by block7 on 11/20/15.
//  Copyright © 2015 block7. All rights reserved.
//

class UnorderedSet<DataType: Hashable> {
    private var array: [DataType] = [DataType]()
    
    init() {}
    
    init(initialData: [DataType]) {
        array.appendContentsOf(initialData)
    }
    
    func add(item: DataType) {
        array.append(item)
    }
    
    func identity() -> [DataType: Int] {
        var identity: [DataType: Int] = [DataType: Int]()
        
        for item in array {
            if identity[item] == nil {
                identity[item] = 1
            } else {
                identity[item] = identity[item]! + 1
            }
        }
        
        return identity
    }
    
    func equal(other: UnorderedSet<DataType>) -> Bool {
        return self.identity() == other.identity()
    }
}