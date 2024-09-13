selectByColIndex: {[tableSym; colIndex]
    $[
        1 < count colIndex;
        ?[tableSym;();0b;((cols tableSym) @ colIndex)!(cols tableSym) @ colIndex];
        ?[tableSym;();0b;(enlist (cols tableSym) @ colIndex)!enlist (cols tableSym) @ colIndex]    
    ]
 }

getData:{[tableSym; isDistinct;dictionary]
    ?[tableSym;();isDistinct;dictionary]
 }

getColsDict: {[colsWanted]
    (`$ ' ssr[;" ";"_"] each colsWanted) ! (`$ ' colsWanted)
 }