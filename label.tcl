proc labelAtoms { molid seltext } { 
    label delete Atoms $seltext 
    set sel [atomselect $molid $seltext] 
    set i 0 
    set atomlist [$sel list] 
    foreach {atom} $atomlist { 
    set atomlabel [format "%d/%d" $molid $atom] 
    label add Atoms $atomlabel 
    label textformat Atoms $i {%1i} 
    incr i 
  } 
  $sel delete 
} 
