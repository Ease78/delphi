      SUBROUTINE ADDREF (STRING,SIGLEN,R,FORM)
      IMPLICIT NONE

*     FORMAL_PARAMETERS:
      CHARACTER*(*) STRING,FORM
      INTEGER SIGLEN
      REAL R

**    local variables
      CHARACTER*30 TMPR
      CHARACTER*30 TMPFORM
      INTEGER IL
      SAVE

      TMPFORM = '('//FORM//',A)'
      WRITE (TMPR,TMPFORM) R,'|'
      IL = INDEX (TMPR,'|')-1

      IF (SIGLEN+IL.GT.LEN (STRING)) CALL FATALERR
     &   ('ADDREF','internal error')

      STRING(SIGLEN+1:SIGLEN+IL) = TMPR(1:IL)
      SIGLEN = SIGLEN+IL

      RETURN
      END
