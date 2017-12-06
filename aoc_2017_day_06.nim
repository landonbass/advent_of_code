import sequtils, strutils

const maxRuns  = high int

#var init : seq[int] = @[0,2,7,0]
var init : seq[int] = @[10,3,15,10,5,15,5,15,9,2,5,8,5,2,3,6]
var pastSeqs        = newSeq[string]()

proc toString(str: seq[int]): string =
    result = newStringOfCap(len(str))
    for ch in str:
        add(result, $ch)

var n     = 1
var z     = 0
var found = false
block mainLoop:
    while n < maxRuns:
        pastSeqs.add toString(init)
        var max = low int 
        var i   = 0
        for iD in 0..init.len - 1:
            if init[iD] > max:
                max = init[iD]
                i   = iD
        let iMax = max
        init[i] = 0
        for xD in 0..iMax:
            if i == init.len - 1: i = -1
            inc i
            init[i] += 1
            dec max
            if max == 0: break
        let s = toString(init)
        var count = 0
        for pastSeq in pastSeqs:
            
            if count > 0: inc z
            if s == pastSeq: 
                inc count
                if count > 2: break mainLoop
        pastSeqs.add s
        inc n
        

echo "part 2: $#" % $(n - 14029)