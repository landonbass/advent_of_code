import strutils, unicode


type Direction = enum
    up, down, left right

type Matrix[W, H: static[int]] =
    array[1..W, array[1..H, int]]

const keypad: Matrix[3, 3] = [[1, 2, 3],
                              [4, 5, 6],
                              [7, 8, 9]]

const keypad2: Matrix[5, 5] = [[0, 0, 1, 0, 0],
                               [0, 2, 3, 4, 0],
                               [5, 6, 7, 8, 9],
                               [0, 10, 11, 12, 0],
                               [0, 0, 13, 0, 0]]

const minX   : int = 1
const maxX   : int = 3
const maxX2  : int = 5
const startX : int = 2
const minY   : int = 1
const maxY   : int = 3
const maxY2  : int = 5
const startY : int = 2

var currentX : int         = startX
var currentY : int         = startY
var codes    : seq[int]    = @[]
var codes2   : seq[string] = @[]

proc applyStep (step: char) =
    let stepStr : char = toLowerAscii step
    if stepStr != 'u' and stepStr != 'd' and stepStr != 'r' and stepStr != 'l': return
    var direction : Direction
    case stepStr:
        of 'u' : direction = up
        of 'd' : direction = down
        of 'l' : direction = left
        of 'r' : direction = right
        else   : discard

    case direction:
        of up    : 
            if currentY > minY and keypad[currentX][currentY - 1] != 0: currentY -= 1
        of down  : 
            if currentY < maxY and keypad[currentX][currentY + 1] != 0: currentY += 1
        of left  : 
            if currentX > minX and keypad[currentX - 1][currentY] != 0: currentX -= 1
        of right : 
            if currentX < maxX and keypad[currentX + 1][currentY] != 0: currentX += 1

proc applyStep2 (step: char) =
    let stepStr : char = toLowerAscii step
    if stepStr != 'u' and stepStr != 'd' and stepStr != 'r' and stepStr != 'l': return
    var direction : Direction
    case stepStr:
        of 'u' : direction = up
        of 'd' : direction = down
        of 'l' : direction = left
        of 'r' : direction = right
        else   : discard  
    case direction:
        of up    : 
            if currentY > minY  and keypad2[currentX][currentY - 1] != 0: currentY -= 1
        of down  : 
            if currentY < maxY2 and keypad2[currentX][currentY + 1] != 0: currentY += 1
        of left  : 
            if currentX > minX  and keypad2[currentX - 1][currentY] != 0: currentX -= 1
        of right : 
            if currentX < maxX2 and keypad2[currentX + 1][currentY] != 0: currentX += 1

proc applySteps(steps: string) =
    for x in 0..steps.len:
        applyStep steps[x]

proc applySteps2(steps: string) =
    for x in 0..steps.len:
        applyStep2 steps[x]

proc applyAllSteps(allSteps: string) =
    for line in splitLines allSteps:
        applySteps line
        codes.add keypad[currentY][currentX]

proc applyAllSteps2(allSteps: string) =
    for line in splitLines allSteps:
        applySteps2 line
        echo currentX, currentY
        let val = keypad2[currentY][currentX]
        var lookup : string
        
        case val:
            of 10: lookup = "A"
            of 11: lookup = "B"
            of 12: lookup = "C"
            of 13: lookup = "D"
            else : lookup = $val

        codes2.add lookup
        
const training = """ULL
                    RRDDD
                    LURDL
                    UUUUD"""
const input = """LLLRLLULLDDLDUDRDDURLDDRDLRDDRUULRULLLDLUURUUUDLUUDLRUDLDUDURRLDRRRUULUURLUDRURULRLRLRRUULRUUUDRRDDRLLLDDLLUDDDLLRLLULULRRURRRLDRLDLLRURDULLDULRUURLRUDRURLRRDLLDDURLDDLUDLRLUURDRDRDDUURDDLDDDRUDULDLRDRDDURDLUDDDRUDLUDLULULRUURLRUUUDDRLDULLLUDLULDUUDLDLRRLLLRLDUDRUULDLDRDLRRDLDLULUUDRRUDDDRDLRLDLRDUDRULDRDURRUULLUDURURUUDRDRLRRDRRDRDDDDLLRURULDURDLUDLUULDDLLLDULUUUULDUDRDURLURDLDDLDDUULRLUUDLDRUDRURURRDDLURURDRLRLUUUURLLRR
UUUUURRRURLLRRDRLLDUUUUDDDRLRRDRUULDUURURDRLLRRRDRLLUDURUDLDURURRLUDLLLDRDUDRDRLDRUDUDDUULLUULLDUDUDDRDUUUDLULUDUULLUUULURRUDUULDUDDRDURRLDDURLRDLULDDRUDUDRDULLRLRLLUUDDURLUUDLRUUDDLLRUURDUDLLDRURLDURDLRDUUDLRLLRLRURRUDRRLRDRURRRUULLUDLDURDLDDDUUDRUUUDULLLRDRRDRLURDDRUUUDRRUUDLUDDDRRRRRLRLDLLDDLRDURRURLLLULURULLULRLLDDLDRLDULLDLDDDRLUDDDUDUDRRLRDLLDULULRLRURDLUDDLRUDRLUURRURDURDRRDRULUDURRLULUURDRLDLRUDLUDRURLUDUUULRRLRRRULRRRLRLRLULULDRUUDLRLLRLLLURUUDLUDLRURUDRRLDLLULUDRUDRLLLRLLDLLDUDRRURRLDLUUUURDDDUURLLRRDRUUURRRDRUDLLULDLLDLUDRRDLLDDLDURLLDLLDLLLDR
LRDULUUUDLRUUUDURUUULLURDRURDRRDDDLRLRUULDLRRUDDLLUURLDRLLRUULLUDLUDUDRDRDLUUDULLLLRDDUDRRRURLRDDLRLDRLULLLRUUULURDDLLLLRURUUDDDLDUDDDDLLLURLUUUURLRUDRRLLLUUULRDUURDLRDDDUDLLRDULURURUULUDLLRRURDLUULUUDULLUDUUDURLRULRLLDLUULLRRUDDULRULDURRLRRLULLLRRDLLDDLDUDDDUDLRUURUDUUUDDLRRDLRUDRLLRDRDLURRLUDUULDRRUDRRUDLLLLRURRRRRUULULLLRDRDUDRDDURDLDDUURRURLDRRUDLRLLRRURULUUDDDLLLRDRLULLDLDDULDLUUDRURULLDLLLLDRLRRLURLRULRDLLULUDRDR
RURRRUDLURRURLURDDRULLDRDRDRRULRRDLDDLDUUURUULLRRDRLDRRDRULLURRRULLLDULDDDDLULRUULRURUDURDUDRLRULLLRDURDDUDDRDLURRURUURDLDDDDDURURRURLLLDDLDRRDUDDLLLDRRLDDUUULDLLDRUURUDDRRLDUULRRDDUDRUULRLDLRLRUURLLDRDLDRLURULDLULDRULURLLRRLLDDDURLRUURUULULRLLLULUDULUUULDRURUDDDUUDDRDUDUDRDLLLRDULRLDLRRDRRLRDLDDULULRLRUUDDUDRRLUDRDUUUDRLLLRRLRUDRRLRUUDDLDURLDRRRUDRRDUDDLRDDLULLDLURLUUDLUDLUDLDRRLRRRULDRLRDUURLUULRDURUDUUDDURDDLRRRLUUUDURULRURLDRURULDDUDDLUDLDLURDDRRDDUDUUURLDLRDDLDULDULDDDLDRDDLUURDULLUDRRRULRLDDLRDRLRURLULLLDULLUUDURLDDULRRDDUULDRLDLULRRDULUDUUURUURDDDRULRLRDLRRURR
UDDDRLDRDULDRLRDUDDLDLLDDLUUURDDDLUDRDUDLDURLUURUDUULUUULDUURLULLRLUDLLURUUUULRLRLLLRRLULLDRUULURRLLUDUDURULLLRRRRLRUULLRDRDRRDDLUDRRUULUDRUULRDLRDRRLRRDRRRLULRULUURRRULLRRRURUDUURRLLDDDUDDULUULRURUDUDUDRLDLUULUDDLLLLDRLLRLDULLLRLLDLUUDURDLLRURUUDDDDLLUDDRLUUDUDRDRLLURURLURRDLDDDULUURURURRLUUDUDLDLDDULLURUDLRLDLRLDLDUDULURDUDRLURRRULLDDDRDRURDDLDLULUDRUULDLULRDUUURLULDRRULLUDLDRLRDDUDURRRURRLRDUULURUUDLULDLRUUULUDRDRRUDUDULLDDRLRDLURDLRLUURDRUDRDRUDLULRUDDRDLLLRLURRURRLDDDUDDLRDRRRULLUUDULURDLDRDDDLDURRLRRDLLDDLULULRRDUDUUDUULRDRRDURDDDDUUDDLUDDUULDRDDULLUUUURRRUUURRULDRRDURRLULLDU"""

applyAllSteps input
currentX = 1
currentY = 3
applyAllSteps2 input
echo "part 1:", codes
echo "part 2:", codes2