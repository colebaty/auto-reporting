BEGIN { 
     FS = ":"
     print "| username | password |"
     print "| --- | --- |" 
 } 

 { 
     print "| " $1 " | " $2 " |" 
 } 
