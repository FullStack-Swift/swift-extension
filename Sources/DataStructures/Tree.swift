import Foundation
import CloudKit

public class TreeNode<T> {
  public var value: T
  public var id: UUID
  public var isHiddenChildren: Bool
  public weak var parent: TreeNode?
  public var children: [TreeNode<T>]
  
  public init(value: T, id: UUID = UUID(), isHiddenChildren: Bool = false, parent: TreeNode? = nil, children: [TreeNode<T>] = []) {
    self.value = value
    self.id = id
    self.isHiddenChildren = isHiddenChildren
    self.children = children
  }
  
}

//MARK: Update
public extension TreeNode {
  func updated(id: UUID) {
    self.id = id
  }
  
  func updated(value: T) {
    self.value = value
  }
  
  func updated(children: [TreeNode<T>]) {
    self.children = children
  }
  
  func updated(parent: TreeNode<T>?) {
    self.parent = parent
  }
  
  func addChild(_ node: TreeNode<T>) {
    children.append(node)
    node.parent = self
  }
  
  func addChildren(_ children: [TreeNode<T>]) {
    for child in children {
      addChild(child)
    }
  }
}

//MARK: Remove
public extension TreeNode {
  
}

// MARK: Extension
public extension TreeNode {
  func arrayTreeNode() -> [TreeNode<T>] {
    var arrayTreeNode = [TreeNode<T>]()
    arrayTreeNode.append(self)
    for child in children {
      arrayTreeNode.append(contentsOf: child.arrayTreeNode())
    }
    return arrayTreeNode
  }
  
  func arrayTreeNodeWithRemoveHiddenChildren() -> [TreeNode<T>] {
    var allTreeNode = [TreeNode<T>]()
    allTreeNode.append(self)
    if !isHiddenChildren {
      for child in children {
        allTreeNode.append(contentsOf: child.arrayTreeNodeWithRemoveHiddenChildren())
      }
    }
    return allTreeNode
  }
  
  var level: Int {
    var index: Int = 0
    if let parent = parent {
      index += 1
      return index + parent.level
    } else {
      return index
    }
  }
  
  func children(with level: Int) -> [TreeNode<T>] {
    arrayTreeNode().filter{$0.level == level}
  }
  
}

public extension TreeNode where T: Equatable {
  func search(value: T) -> TreeNode? {
    if value == self.value {
      return self
    }
    for child in children {
      if let found = child.search(value: value) {
        return found
      }
    }
    return nil
  }
}

public extension TreeNode {
  func search(id: UUID) -> TreeNode? {
    if self.id == id {
      return self
    }
    for child in children {
      if let found = child.search(id: id) {
        return found
      }
    }
    return nil
  }
}

extension TreeNode: CustomStringConvertible {
  public var description: String {
    var s = "\(value)"
    if !children.isEmpty {
      s += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
    }
    return s
  }
}
