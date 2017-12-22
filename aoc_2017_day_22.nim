import memfiles, sequtils, strutils

type Direction = enum down, up, left, right

var map = newSeq[string]()
for line in lines(memfiles.open("aoc_2017_day_22.dat")):
    map.add line

var currentDirection = up
var currentX         = (map[0].len/2).int
var currentY         = (map.len/2).int
var infected         = 0
for x in 0..<10_000:
    #echo "x:$# y:$# d:$#" % [$currentX, $currentY, $currentDirection]
    if map[currentY][currentX] == '#':
        case currentDirection:
            of down : currentDirection = left
            of up   : currentDirection = right
            of left : currentDirection = up
            of right: currentDirection = down
        map[currentY][currentX] = '.'
    elif map[currentY][currentX] == '.':
        case currentDirection:
            of down : currentDirection = right
            of up   : currentDirection = left
            of left : currentDirection = down
            of right: currentDirection = up
        map[currentY][currentX] = '#'
        inc infected
    
    case currentDirection:
        of down : inc currentY
        of up   : dec currentY
        of left : dec currentX
        of right: inc currentX
    
    if currentX < 0:
        for i in 0..map.len - 1:
            map[i] = '.' & map[i]
        inc currentX
    if currentX > map[0].len - 1:
        for i in 0..map.len - 1:
            map[i] = map[i] & '.'
    if currentY < 0:
        let newRow = repeat(".", map[0].len)
        map = concat(@[newRow], map)
        inc currentY
    if currentY > map.len - 1:
        let newRow = repeat(".", map[map.len - 1].len)
        map = concat(map, @[newRow])

echo "x: $# y:$# i:$# d:$#" % [$currentX, $currentY, $infected, $currentDirection]
