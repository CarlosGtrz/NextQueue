  PROGRAM

  MAP
    MODULE('TestNextQueue.clw')
      TestNextQueue
    END
    SET(QUEUE q)
    NEXT(QUEUE q),LONG,PROC
    PREVIOUS(QUEUE q),LONG,PROC
  END

  CODE
  
  TestNextQueue
    
SET                 PROCEDURE(QUEUE q)
  CODE
  GET(q,0)

NEXT                PROCEDURE(QUEUE q)!,LONG
  CODE
  GET(q,POINTER(q)+1)
  RETURN ERRORCODE()

PREVIOUS            PROCEDURE(QUEUE q)!,LONG
ptr                   LONG
  CODE
  ptr = POINTER(q)
  IF ptr
    GET(q,POINTER(q)-1)
  ELSE
    GET(q,RECORDS(q))
  .
  RETURN ERRORCODE()
