  MEMBER('NextQueue.clw')

TestNextQueue       PROCEDURE

  MAP
  .

QOne                QUEUE
Id                    LONG
Number                LONG
QTwo                  &QTwoType
                    END
IQOne               LONG

QTwoType            QUEUE,TYPE
Id                    LONG
Number                LONG
                    END
IQTwo                 LONG

QThree                QUEUE
Id                      LONG
Number                  LONG
                      END
IQThree               LONG

SumI                DECIMAL(20)
SumG                DECIMAL(20)
SumN                DECIMAL(20)
TimeI                 LONG
TimeG                 LONG
TimeN                 LONG

TimeDI                LONG
TimeDP                LONG
RecsDI                LONG
RecsDP                LONG

str                   ANY

  CODE
  
  DO FillQOne
  
  !Test LOOP I
  TimeI = CLOCK()
  LOOP 10 TIMES
    LOOP IQOne = 1 TO RECORDS(QOne)
      GET(QOne,IQOne)
      SumI += QOne.Number
      LOOP IQTwo = 1 TO RECORDS(QOne.QTwo)
        GET(QOne.QTwo,IQTwo)
        SumI += QOne.QTwo.Number
      .
    .
  .  
  TimeI = CLOCK() - TimeI
  
  !Test GET/ERRORCODE
  TimeG = CLOCK()
  LOOP 10 TIMES
    GET(QOne,0)
    LOOP 
      GET(QOne,POINTER(QOne)+1)
      IF ERRORCODE() THEN BREAK.      
      SumG += QOne.Number
      GET(QOne.QTwo,0)
      LOOP 
        GET(QOne.QTwo,POINTER(QOne.QTwo)+1)
        IF ERRORCODE() THEN BREAK.
        SumG += QOne.QTwo.Number
      .
    .
  .  
  TimeG = CLOCK() - TimeG

  !Test SET/NEXT(QUEUE)
  TimeN = CLOCK()
  LOOP 10 TIMES
    SET(QOne)
    LOOP UNTIL NEXT(QOne)
      SumN += QOne.Number
      SET(QOne.QTwo)
      LOOP UNTIL NEXT(QOne.QTwo)
        SumN += QOne.QTwo.Number
      .
    .
  .  
  TimeN = CLOCK() - TimeN
  
  !Test LOOP I DELETE
  DO FillQThree
  TimeDI = CLOCK()
  LOOP IQThree = RECORDS(QThree) TO 1 BY -1
    GET(QThree,IQThree)
    DELETE(QThree)
  .
  TimeDI = CLOCK() - TimeDI
  RecsDI = RECORDS(QThree)
   
  
  !Test SET/PREVIOUS(DELETE)
  DO FillQThree
  TimeDP = CLOCK()
  SET(QThree)  
  LOOP UNTIL PREVIOUS(QThree)
    DELETE(QThree)
  .
  TimeDP = CLOCK() - TimeDP
  RecsDP = RECORDS(QThree)  
  
  !Done
  str = | 
    'LOOP I: '&TimeI/100&' '&SumI&'|'& |
    'LOOP GET/ERRORCODE: '&TimeG/100&' '&CLIP(LEFT(FORMAT((TimeG/TimeI-1)*100,@N-8.2~%~)))&' '&SumG&' '&CHOOSE(SumG=SumI,'OK','X') &'|'& |
    'LOOP SET/NEXT: '&TimeN/100&' '&CLIP(LEFT(FORMAT((TimeN/TimeI-1)*100,@N-8.2~%~)))&' '&SumN&' '&CHOOSE(SumN=SumI,'OK','X') &'|'& |
    '|'& |
    'LOOP DELETE I: '&TimeDI/100&' '&RecsDI&'|'& |
    'LOOP DELETE SET/PREVIOUS: '&TimeDP/100&' '&CLIP(LEFT(FORMAT((TimeDP/TimeDI-1)*100,@N-8.2~%~)))&' '&RecsDP&' '&CHOOSE(RecsDP=0,'OK','X') 
      
  SETCLIPBOARD(str)
  MESSAGE(str)

FillQOne            ROUTINE
  
  CLEAR(IQOne)
  CLEAR(IQTwo)
  LOOP 1000 TIMES
    IQOne += 1
    CLEAR(QOne)
    QOne.Id = IQOne
    QOne.Number = RANDOM(1,1000000)
    QOne.QTwo &= NEW QTwoType
    LOOP 1000 TIMES
      IQTwo += 1
      CLEAR(QOne.QTwo)
      QOne.QTwo.Id = IQTwo
      QOne.QTwo.Number = RANDOM(1,1000000)
      ADD(QOne.QTwo)
    .
    ADD(QOne)
  .  
  
FillQThree          ROUTINE
  
  FREE(QThree)
  CLEAR(IQThree)
  LOOP 20000000 TIMES
    IQThree += 1
    CLEAR(QThree)
    QThree.Id = IQThree
    QThree.Number = RANDOM(1,1000000)
    ADD(QThree)
  .  
  
  