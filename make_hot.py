import re

with open("zz.top") as f:
    with open("zz_hot.top","w") as ff:
        in_molecules=False
        in_atoms=False
        ala_done=False
        for l in f:
            #ala_done=False # also modify water
            if(in_atoms) and not re.match(" *;.*",l) and not re.match(r"\[.*",l) and len(l.split())>2:
                ll=l.split()
                ll[1]=ll[1]+"_"
                ll=" ".join(ll)
                print(ll,file=ff)
            else:
                print(l,end="",file=ff)
            if not ala_done and re.match(r"\[ *moleculetype *\]",l):
                in_molecules=True
                ala_done=True
            elif in_molecules and re.match(r"\[ *atoms *\]",l):
                in_atoms=True
            elif ala_done and re.match(r"\[ *bonds *\]",l):
                in_atoms=False
            elif re.match(r"\[.*",l):
                in_molecules=False
                in_atoms=False