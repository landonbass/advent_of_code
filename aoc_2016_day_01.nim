import parseUtils, strutils, tables

type Direction = enum
  north, east, west, south
type DirectionKind = enum
  left, right
type Location = object
  x, y          : int 
  facing        : Direction 
  distFromStart : int

var visited  = initTable[string, bool]()
var location = Location(x: 0, y: 0, facing: north, distFromStart: 0)
var found    = false
proc applyStep (step: string) =
    
    let dir  : string = toLowerAscii step[0 .. 0]
    let dist : int    = parseInt(step[1 .. step.len])
    if dir != "r" and dir != "l" : raise newException(IOError, "invalid direction")
    let direction = if dir == "r": right else: left
    let previousLocation = location
    var xD, yD : int
    case direction:
        of left:
            case location.facing:
                of north : location.facing = west  ; location.x -= dist ; xD = -1; yD = 1
                of east  : location.facing = north ; location.y += dist ; xD = 1;  yD = 1 
                of west  : location.facing = south ; location.y -= dist ; xD = 1;  yD = -1 
                of south : location.facing = east  ; location.x += dist ; xD = 1;  yD = 1 
        of right:
            case location.facing:
                of north : location.facing = east  ; location.x += dist ; xD = 1;   yD = 1 
                of east  : location.facing = south ; location.y -= dist ; xD = 1;   yD = -1
                of west  : location.facing = north ; location.y += dist ; xD = 1;   yD = 1
                of south : location.facing = west  ; location.x -= dist ; xD = -1;  yD = 1

    location.distFromStart = abs(location.x) + abs(location.y)
    if not found :
        block visitLoop:
            var pnx = -9999
            var pny = -9999
            for x in 0 .. abs(location.x - previousLocation.x):
                for y in 0 .. abs(location.y - previousLocation.y):
                    let nx = previousLocation.x + x*xD
                    let ny = previousLocation.y + y*yD
                    if (nx != pnx or ny != pny) and pnx != -9999 and pny != -9999:
                        let key = intToStr(nx) & "_" & intToStr(ny)
                        if not contains(visited, key): visited[key] = true 
                        else: 
                            found = true
                            echo "distance part 2: " & $(abs(nx) + abs(ny))
                            break visitLoop
                    pnx = nx
                    pny = ny


#const input = "R8, R4, R4, R8"
const input = "R4, R1, L2, R1, L1, L1, R1, L5, R1, R5, L2, R3, L3, L4, R4, R4, R3, L5, L1, R5, R3, L4, R1, R5, L1, R3, L2, R3, R1, L4, L1, R1, L1, L5, R1, L2, R2, L3, L5, R1, R5, L1, R188, L3, R2, R52, R5, L3, R79, L1, R5, R186, R2, R1, L3, L5, L2, R2, R4, R5, R5, L5, L4, R5, R3, L4, R4, L4, L4, R5, L4, L3, L1, L4, R1, R2, L5, R3, L4, R3, L3, L5, R1, R1, L3, R2, R1, R2, R2, L4, R5, R1, R3, R2, L2, L2, L1, R2, L1, L3, R5, R1, R4, R5, R2, R2, R4, R4, R1, L3, R4, L2, R2, R1, R3, L5, R5, R2, R5, L1, R2, R4, L1, R5, L3, L3, R1, L4, R2, L2, R1, L1, R4, R3, L2, L3, R3, L2, R1, L4, R5, L1, R5, L2, L1, L5, L2, L5, L2, L4, L2, R3"
for step in split(input, ","):
  applyStep strip(step)

echo "distance part 1: " & $(abs(location.x) + abs(location.y))