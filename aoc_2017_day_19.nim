import memfiles, strutils
type Direction = enum up, down, left, right
var letters = ""
var network = newSeq[string]()

for line in lines(memfiles.open("aoc_2017_day_19.dat")):
    network.add line

var direction = down
var currentX  = find(network[0], "|")
var currentY  = 0

var x = -1
while x < 1_000_000:
    inc x
    let ch = $network[currentY][currentX]
    #echo "x: $# y: $# ch: $#, d: $#" % [$currentX, $currentY, ch, $direction]
    if isAlphaAscii ch: 
        letters.add ch;
        case direction:
            of down : inc currentY
            of up   : dec currentY
            of left : dec currentX
            of right: inc currentX
    elif $ch == "|" or $ch == "-": 
        case direction:
            of down:  inc currentY
            of up:    dec currentY
            of left:  dec currentX
            of right: inc currentX
    elif $ch == "+": 
        case direction:
            of left, right:
                if currentY == network.len - 1: direction = up; dec currentY 
                elif isAlphaAscii($network[currentY + 1][currentX]) or $network[currentY + 1][currentX] == "|": 
                    direction = down; inc currentY 
                else:
                    direction = up; dec currentY
            of up, down:
                if isAlphaAscii($network[currentY][currentX + 1]) or $network[currentY][currentX + 1] == "-": 
                    direction = right; inc currentX 
                else:
                    direction = left; dec currentX
    else: break               
echo letters

