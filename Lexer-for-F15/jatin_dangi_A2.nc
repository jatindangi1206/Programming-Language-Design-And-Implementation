PROGRAM absdiff

INTEGER a
INTEGER b
INTEGER c

READ *, a, b

IF (a .GT. b) THEN
    c=a-b
ELSE
    IF (a .LT. b) THEN
        c=b-a
    ELSE
        c=0
    END IF
END IF

PRINT *, "Absolute Difference of", a, "and", b, "is", c

END PROGRAM absdiff





PROGRAM sum

INTEGER n
INTEGER i
INTEGER s

READ *, n

s=0
DO i = 1, n
    s=s+i
END DO

PRINT *, "Sum of first n natural numbers is", s

END PROGRAM sum