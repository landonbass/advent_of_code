import memfiles, sequtils, strutils

type 
    StepKind = enum 
        spin,
        exchange,
        partner
    Step = object 
        case kind: StepKind
        of spin:
            X : int
        of exchange:
            eA, eB : int
        of partner:
            pA, pB : string

var steps = newSeq[Step]()
for line in lines(memfiles.open("aoc_2017_day_16.dat")):
    let atoms = split(line, ",")
    for atom in atoms:
        let stepType = atom[0]
        case stepType:
            of 's':
                steps.add Step(kind: spin, X: parseInt(atom[1..atom.len - 1]))
            of 'x':
                let d = find(atom, "/")
                let a = parseInt(atom[1..d - 1])
                let b = parseInt(atom[d + 1..atom.len - 1])
                steps.add Step(kind: exchange, eA: a, eB: b)
            of 'p':
                let d = find(atom, "/")
                let a = atom[1..d - 1] 
                let b = atom[d + 1..atom.len - 1]
                steps.add Step(kind: partner, pA: a, pB: b)
            else: discard atom

var programMaster = newSeq[string]()
for i in 0..15:
    programMaster.add $(i + 97).char

var programs = programMaster 

proc doSteps() =
    for step in steps:
        case step.kind:
            of spin:
                let a = programs[programs.len - step.X..programs.len - 1]
                let b = programs[0..programs.len - 1 - step.X]
                let newPrograms = concat(a, b)
                for i in 0..newPrograms.len - 1:
                    programs[i] = newPrograms[i]    
            of exchange:
                let a = programs[step.eA]
                let b = programs[step.eB]
                programs[step.eA] = b
                programs[step.eB] = a
            of partner:
                let ia = find(programs, step.pA)
                let ib = find(programs, step.pB)
                let a = programs[ia]
                let b = programs[ib]
                programs[ia] = b
                programs[ib] = a

doSteps()
var answer1 = ""
for program in programs:
    answer1 &= program
echo answer1

var repeat = 0
programs   = programMaster
var first  = programs
for i in 1..<1_000:
    doSteps()
    if first == programs: repeat = i; break
programs = programMaster
for i in 1..(1_000_000_000 mod repeat): doSteps()
var answer2 = ""
for program in programs:
    answer2 &= program
echo answer2