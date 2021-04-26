# SET/NEXT/PREVIOUS for queues

    SET(myQ)
    LOOP UNTIL NEXT(myQ)
      !Some code
    .

    SET(myQ)
    LOOP UNTIL PREVIOUS(myQ)
      DELETE(myQ)
    .
