//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
  
  public func convert(_ to: String) -> Money {
    switch (self.currency, to) {
    case ("USD", "GBP"):
        return Money(amount: Int(Double(self.amount) * 0.5), currency: to)
    case ("USD", "EUR"):
        return Money(amount: Int(Double(self.amount) * 1.5), currency: to)
    case ("USD", "CAN"):
        return Money(amount: Int(Double(self.amount) * 1.25), currency: to)
    case ("GBP", "USD"):
        return Money(amount: self.amount * 2, currency: to)
    case ("EUR", "USD"):
        return Money(amount: Int(Double(self.amount) / 1.5), currency: to)
    case ("CAN", "USD"):
        return Money(amount: Int(Double(self.amount) / 1.25), currency: to)
    default:
        return self
    }
  }
  
  public func add(_ to: Money) -> Money {
    var newAmount = self.amount + self.amount
    if self.currency != to.currency {
        newAmount = to.amount + self.convert(to.currency).amount
    }
    return Money(amount: newAmount, currency: to.currency)
  }

  public func subtract(_ from: Money) -> Money {
    var newAmount = self.amount
    if self.currency != from.currency {
        newAmount = from.amount - self.convert(from.currency).amount
    }
    return Money(amount: newAmount, currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }

  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }

  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let pay):
        return Int(pay * Double(hours))
    case .Salary(let pay):
        return pay
    }
  }

  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let pay):
        self.type = JobType.Hourly(pay + amt)
    case .Salary(let pay):
        self.type = JobType.Salary(Int(Double(pay) + amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
        if self.age >= 21 {
            _job = value
        }
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
        if self.age >= 21 {
            _spouse = value
        }
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(_job) spouse:\(_spouse)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members.append(spouse1)
        self.members.append(spouse2)
    }
  }

  open func haveChild(_ child: Person) -> Bool {
    if members[0].age > 21 || members[1].age > 21 {
        self.members.append(child)
        return true
    }
    return false
  }

  open func householdIncome() -> Int {
    var totalIncome = 0
    for member in members {
        if member.job != nil {
            totalIncome = totalIncome + member.job!.calculateIncome(2000)
        }
    }
    return totalIncome
  }
}


