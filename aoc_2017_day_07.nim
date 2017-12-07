import memfiles, sequtils,strutils

type Root = object 
    value: string
    found: bool

var data  = newSeq[string]()
var roots = newSeq[Root]()
var rest  = newSeq[string]()
for line in lines(memfiles.open("aoc_2017_day_07.dat")):
    if find(line, "->") == -1: continue #no child nodes
    roots.add Root(value: split(line, " ")[0], found: false)
    rest.add  split(line, "-> ")[1]
    


for i in 0..roots.len-1:
    for r in rest: 
        let nodes = split(r, ", ")
        for node in nodes:
            if node == roots[i].value: roots[i].found = true


echo filter(roots, proc (x: Root): bool = not x.found)[0].value