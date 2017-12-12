import math, memfiles, sequtils, strutils

var source = newSeq[string]()
for line in lines(memfiles.open("aoc_2017_day_11.dat")):
    source.add line
for line in source:
    var distanceX = 0
    var distanceY = 0
    var distanceZ = 0
    let path = split(line, ",").map toLowerAscii
    for step in path:
        case step:
            of "n" : distanceY += 1; distanceZ -= 1
            of "ne": distanceX += 1; distanceZ -= 1
            of "nw": distanceY += 1; distanceZ -= 1
            of "w" : distanceX -= 1; distanceY += 1
            of "e" : distanceX += 1; distanceY -= 1
            of "s" : distanceY -= 1; distanceZ += 1
            of "se": distanceY -= 1; distanceZ += 1
            of "sw": distanceX -= 1; distanceZ += 1
    var distance = (abs(0 - distanceX) + abs(0 - distanceY) + abs(0 - distanceZ)) / 2
    echo $distance