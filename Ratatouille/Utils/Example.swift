//
//  Example.swift
//  Ratatouille
//
//  Created by Jack Xia on 22/11/2023.
//

import SwiftUI

struct Example: View {
    let numbers = [0, 0, 0, 0]
    
    func closureExample (_ n1: Int, _ n2: Int,  operand: (Int, Int) -> Int) -> Int {
        // params passed into closure
        return operand(n1, n2)
    }
    func add(n1:Int,n2:Int) -> Int {  // Boiling down it's type into anonymous func (Int, Int) -> Int
        return n1 + n2
    }
    func multiply(_ n1:Int,_ n2:Int) -> Int {
        return n1 * n2
    }
    
    var body: some View {
        VStack {
            let exe1 = closureExample(2, 2, operand: add)
            let exe2 = closureExample(3, 3, operand: {$0 / $1})
            let exe3 = closureExample(5, 5) { Int, Int in
                multiply(Int, Int)
            }
            let lol = closureExample(4, 4) {$0 + $1}
            
            let lol2 = numbers.map({$0 + 1})
            
            Text("\(exe1)")
            Text("\(exe2)")
            Text("\(exe3)")
            Text("\(lol)")
            HStack {
                ForEach(lol2.indices, id:\.self) { i in
                    Text("\(lol2[i])")
                }
            }
        }
        .font(.system(size: 100))
    }
}

struct Example_Previews: PreviewProvider {
    static var previews: some View {
        Example()
    }
}
