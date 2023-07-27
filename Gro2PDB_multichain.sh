#!/bin/bash

INGRO=$1
CHAINS=$2


echo $INGRO
if [ "${INGRO##*.}" = "pdb" ]; then
    INGRO=${1%%.*}_.gro
    gmx editconf -f $1 -o $INGRO  &> /dev/null
    echo converting to $INGRO
fi



if [ "$3" ]; then
      OUTPDB=$3
else
    OUTPDB=${INGRO%%.*}.pdb
fi

if [ -f "$OUTPDB" ]
then
    echo "$OUTPDB exists chainging output to ..."
    OUTPDB=${1%%.*}_.pdb
    fi

TOT=$(sed -n '2p' < $INGRO)
echo $TOT
PROT=$(grep -c "ALA\|CYS\|ASP\|GLU\|PHE\|GLY\|HIS\|ILE\|LYS\|LEU\|MET\|ASN\|PRO\|GLN\|ARG\|SER\|THR\|VAL\|TRP\|TYR\|NME\|ACE" $INGRO)
ATOMS=`expr $PROT / $CHAINS`
echo $ATOMS per chain


i=0
j=0
END=0


while test  $i -lt  $CHAINS
do
START=$[$END+1]
END=$[$START+$ATOMS-1]

echo "[ $i ]" >> temp.ndx

for j in $(seq $START $END)
do
    echo "$j" >> temp.ndx
done
i=$[$i+1]

done

if [[ "$END" -lt "$TOT" ]]
then
    END=$[$END+1]
    echo "[ $i ]" >> temp.ndx
    for j in $(seq $END $TOT)
    do
    echo "$j" >> temp.ndx
    done

fi

## this determines how many chains you have in the .ndx file
LIMIT=`grep '\[' temp.ndx| wc -l`

i=0
CHID=A


echo COMMENT This pdb was generated from gro file $INGRO > $OUTPDB

while test  $i -lt  $LIMIT
do
    echo $i | gmx editconf -f $INGRO -o $i.pdb -n temp.ndx -resnr 1 -label $CHID &> /dev/null
    grep ATOM $i.pdb >> $OUTPDB
    echo TER >> $OUTPDB
    rm $i.pdb
    i=$[$i+1]
    CHID=`echo $CHID | tr "[A-Z]" "[B-ZA]"`
done
rm temp.ndx
echo $OUTPDB
