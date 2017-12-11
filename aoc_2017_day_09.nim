import memfiles

var source = newSeq[string]()
for line in lines(memfiles.open("aoc_2017_day_09.dat")):
    source.add line
var scores    = newSeq[int]()
var current   = 1
var inGarbage = false
var skipNext  = false
for i in 0..source[0].len - 1:
    if skipNext:
        skipNext = false
        continue
    let ch = source[0][i]
    if not inGarbage:
        if ch == '{':
            scores.add current
            inc current
        if ch == '}':
            dec current
        if ch == '<':
            inGarbage = true
    else:
        if ch == '<':
            inGarbage = true
        if ch == '>':
            inGarbage = false
        if ch == '!':
            skipNext = true    

var sum : int = 0
for score in scores: sum += score
echo sum