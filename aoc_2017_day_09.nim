import memfiles

var source = newSeq[string]()
for line in lines(memfiles.open("aoc_2017_day_09.dat")):
    source.add line

for line in source:
    var scores    = newSeq[int]()
    var current   = 1
    var inGarbage = false
    var skipNext  = false
    var canceled  = 0
    for i in 0..line.len - 1:
        if skipNext:
            skipNext = false
            continue
        let ch = line[i]
        if not inGarbage:
            if ch == '{':
                scores.add current
                inc current
                continue
            if ch == '}':
                dec current
                continue
            if ch == '<':
                inGarbage = true
                continue
        else:
            if ch == '<':
                inc canceled
                continue
            elif ch == '>':
                inGarbage = false
                continue
            elif ch == '!':
                skipNext = true 
                continue
            else:
                inc canceled  

    var sum : int = 0
    for score in scores: sum += score
    echo $sum & " canceled:" & $canceled