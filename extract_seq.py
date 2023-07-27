from modeller import *

env = Environ()
for str in ('XXXX', 'XXXX'):
    mdl = Model(env, file=str)
    aln = Alignment(env)
    aln.append_model(mdl, align_codes=str)

    aln.write(file=str+".ali")
