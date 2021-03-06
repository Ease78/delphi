      PROGRAM MAIN     
      IMPLICIT NONE

      INTEGER DAY
      DOUBLE PRECISION RAIN, YIELD_EST, TOTAL_RAIN, NEWS
      DOUBLE PRECISION MAX_RAIN, CONSISTENCY, ABSORBTION

      MAX_RAIN = 4.0
      CONSISTENCY = 64.0
      ABSORBTION = 0.6
      
      YIELD_EST = 0
      TOTAL_RAIN = 0
 
      DAY = 1
      DO WHILE (DAY <= 31)
        PRINT *, "(", DAY, CONSISTENCY, MAX_RAIN, ABSORBTION, ")"
*       Compute rainfall for the current day
        RAIN = (-(DAY - 16) ** 2 / CONSISTENCY + MAX_RAIN) * ABSORBTION
        PRINT *, RAIN

*       Update rainfall estimate
        YIELD_EST = UPDATE_EST(RAIN, TOTAL_RAIN, YIELD_EST)
        NEWS = TEST_FUNC(TOTAL_RAIN, YIELD_EST)

        PRINT *, "Day ", DAY, " Estimate: ", YIELD_EST
        DAY = DAY + 1
      ENDDO

            PRINT *, "Crop Yield(%): ", YIELD_EST
      PRINT *, "News: ", NEWS

      CONTAINS
       DOUBLE PRECISION FUNCTION UPDATE_EST(RAIN, TOTAL_RAIN, YIELD_EST)
          IMPLICIT NONE
          DOUBLE PRECISION RAIN, YIELD_EST, TOTAL_RAIN
          TOTAL_RAIN = TOTAL_RAIN + RAIN

*         Yield increases up to a point
          IF(TOTAL_RAIN .le. 40) THEN
            YIELD_EST = -(TOTAL_RAIN - 40) ** 2 / 16 + 100

*         Then sharply declines
          ELSE
              YIELD_EST = -TOTAL_RAIN + 140
          ENDIF
          UPDATE_EST = YIELD_EST

        END FUNCTION UPDATE_EST
       
       DOUBLE PRECISION FUNCTION TEST_FUNC(TOTAL_RAIN, YIELD_EST)
          IMPLICIT NONE
          DOUBLE PRECISION TOTAL_RAIN, YIELD_EST, NEW_VAR
          NEW_VAR = 5.0
          IF (NEW_VAR .le. 4.0) THEN
            TEST_FUNC = 17.0
          ELSE
            TEST_FUNC = YIELD_EST
          ENDIF

       END FUNCTION TEST_FUNC

      END PROGRAM MAIN
