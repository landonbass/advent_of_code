import math, sequtils, strutils

const input = "wenycdww"

const keys   = "0123456789abcdef"
const suffix = [17,31,73,47,23]

#based on day 10 from wzkx
proc hashData(input: string ): string =
    var fill    = toSeq(0..255)
    var data    = newSeq[int]()
    var current = 0
    var skip    = 0
    for ch   in input : data.add ord ch
    for atom in suffix: data.add atom
    for i in 0..<64: 
        for datum in data:
            for i in 0..< datum div 2:
                let t = fill[(current + i) mod fill.len]
                fill[(current + i) mod fill.len] = fill[(current + datum - i - 1) mod fill.len]
                fill[(current + datum - i - 1) mod fill.len] = t
            current = (current + datum + skip) mod fill.len
            skip = (skip + 1) mod 256
    result = ""
    for i in 0..<16:              
        var n = 0
        for j in 0..<16:
            n = n xor fill[16*i+j]  
        let s1 = keys[n div 16]
        let s2 = keys[n mod 16]
        result &= s1 & s2

var grid = newSeq[string]()
for x in 0..127:
    var r = ""
    let i = input & "-" & $x
    let hash = hashData i
    for ch in hash:
        var z = if ch < 'a': ord(ch) - ord('0') else: ord(ch) - ord('a') + 10
        r &= toBin(ord z, 4)
    grid.add r 


var squares = 0
for line in grid:
    for sq in line:
        if sq == '1': inc squares
echo squares
