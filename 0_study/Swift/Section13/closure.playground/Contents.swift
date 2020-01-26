import UIKit

func calculator(n1: Int, n2: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(n1, n2)
}

func multifly(no1: Int, no2: Int) -> Int {
    return no1 * no2
}

let result = calculator(n1: 2, n2: 3) { $0 * $1 }
print(result)

///

let arr = [6,2,3,9,4,1]



print(arr.map{$0 + 1})

let newArray = arr.map{"\($0)"}
print(newArray)
