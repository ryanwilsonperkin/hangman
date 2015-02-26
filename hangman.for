!      GAME OF HANGMAN BY DAVE AHL, DIGITAL
!      BASED ON A BASIC PROGRAM WRITTEN BY KEN AUPPERLE
!            HALF HALLOW HILLS H.S. DIX HILLS NY
!      CONVERTED TO FORTRAN 77 BY M.WIRTH, APRIL 2012
!       
       PROGRAM HANGMAN 
       IMPLICIT NONE
       CHARACTER P(12,12)
       CHARACTER GUESSES(26)
       CHARACTER DASHES(20), A*20, GUESS, B*20, ANS 
       INTEGER USED(50)
       INTEGER LENGTH
       INTEGER COUNTER
       INTEGER Q, MISTAKES, I, J, T1, R

       CHARACTER (LEN=20), DIMENSION(50) :: DICT

       DATA DICT/'gum','sin','for','cry','lug','bye','fly','ugly', 
     M           'each','from','work','talk','with','self',
     M           'pizza','thing','feign','fiend','elbow','fault',
     M           'dirty','budget','spirit','quaint','maiden',
     M           'escort','pickax','example','tension','quinine',
     M           'kidney','replica','sleeper','triangle',
     M           'kangaroo','mahogany','sergeant','sequence',
     M           'moustache','dangerous','scientist','different',
     M           'quiescent','magistrate','erroneously',
     M           'loudspeaker','phytotoxic','matrimonial',
     M           'parasympathomimetic','thigmotropism'/
       WRITE (*,*) "THE GAME OF HANGMAN"

! Initialize counter
       COUNTER = 1
! Initialize "used" words tracker
       USED = 0

       DO COUNTER=1,50
! Assign ascii gallows 
           P = " "
           DO I = 1,12
               P(I,1) = "X"
           END DO
           DO J = 1,7
               P(1,J) = "X"
           END DO
           P(2,7) = "X"

! Initialize other values
           DASHES = "-"
           GUESSES = " "
           MISTAKES = 0 
           T1=0

! Get random remaining word from dictionary
           DO WHILE (USED(Q) .EQ. 1)
               Q=CEILING(RAND()*50)
           END DO
           USED(Q) = 1
           A = DICT(Q)
           LENGTH = LEN_TRIM(A) 
           
! Write number of dashes for current word
           WRITE (*,*) DASHES(1:LENGTH)

170        WRITE (*,*) "Here are the letters you used: "
           DO I = 1,26
               IF (GUESSES(I) .EQ. ' ') GO TO 200
               WRITE (*,'(AA$)') GUESSES(I),","
           END DO

200        WRITE (*,*) " "
           WRITE (*,*) "What is your guess? "
           R=0
           READ (*,*) GUESS 
           DO 210 I = 1,26
               IF (GUESSES(I) .EQ. " ") GO TO 250 
               IF (ICHAR(GUESSES(I)) - ICHAR(GUESS)) 210,205,210
205            WRITE (*,*) "You guessed that letter before"
               GO TO 170
210        CONTINUE
           WRITE (*,*) "Invalid character"
           GO TO 170
250        GUESSES(I)=GUESS
           T1=T1+1
           DO I = 1,LENGTH
               IF (A(I:I) .EQ. GUESS) THEN
                   DASHES(I) = GUESS
                   R=R+1
               END IF
           END DO
           IF (R .EQ. 0) THEN
               GO TO 290
           ELSE 
               GO TO 300
           END IF
290        MISTAKES = MISTAKES+1
           GO TO 400       
300        DO I = 1,LENGTH
               IF (ICHAR(DASHES(I)) .EQ. ICHAR("-")) GO TO 320
           END DO
           GO TO 390
320        WRITE (*,*) DASHES(1:LENGTH)
           WRITE (*,*) "What is your guess for the word? "
           READ (*,*) B
           IF (A .EQ. B) GO TO 360
           WRITE (*,*) "Wrong. Try another letter"
           GO TO 170
360        WRITE (*,*) "Right! It took you ",T1," guesses"
370        WRITE (*,*) "Do you want another word? (Y/N) "
           READ (*,*) ANS
           IF (ICHAR(ANS) .EQ. ICHAR("Y")) CYCLE
           WRITE (*,*) "It's been fun! Bye for now."
           EXIT
390        WRITE (*,*) "You found the word."
           GO TO 370
400        WRITE (*,*) "Sorry, that letter isn't in the word."
           SELECT CASE (MISTAKES)
               CASE (1)
                   WRITE (*,*) "First we draw a head."
                   P(3,6) = "-"
                   P(3,7) = "-"
                   P(3,8) = "-"
                   P(4,5) = "(" 
                   P(4,6) = "."
                   P(4,8) = "."
                   P(4,9) = ")"
                   P(5,6) = "-"
                   P(5,7) = "-" 
                   P(5,8) = "-"
               CASE (2)
                   WRITE (*,*) "Now we draw a body."
                   DO I = 6,9
                       P(I,7) = "X" 
                   END DO
               CASE (3)
                   WRITE (*,*) "Next we draw an arm."
                   DO I = 4,7
                       P(I,I-1) = "\" 
                   END DO
               CASE (4)
                   WRITE (*,*) "This time it's the other arm."
                   P(4,11) = "/"
                   P(5,10) = "/"
                   P(6,9) = "/"
                   P(7,8) = "/" 
               CASE (5)
                   WRITE (*,*) "Now, let's draw the right leg."
                   P(10,6) = "/"
                   P(11,5) = "/"
               CASE (6)
                   WRITE (*,*) "This time we draw the left leg."
                   P(10,8) = "\"
                   P(11,9) = "\"
               CASE (7)
                   WRITE (*,*) "Now we put up a hand."
                   P(3,11) = "\"
               CASE (8)
                   WRITE (*,*) "Next the other hand."
                   P(3,3) = "/"
               CASE (9)
                   WRITE (*,*) "Now we draw one foot."
                   P(12,10) = "\"
                   P(12,11) = "-"
               CASE (10)
                   WRITE (*,*) "Here's the other foot -- You're hung!!." 
                   P(12,3) = "-"
                   P(12,4) = "/" 
           END SELECT

           DO I = 1,12
               WRITE (*,*) (P(I,J),J=1,12)
           END DO
           IF (MISTAKES .EQ. 10) THEN
               WRITE (*,*) "Sorry, you loose. The word was ", A
               WRITE (*,*) "You missed that one."
               GO TO 370 
           ELSE
               GO TO 170
           END IF
       END DO
       IF (COUNTER .EQ. 50) THEN
           WRITE (*,*) "You did all the words"
       END IF
999    WRITE (*,*) "Ending..." 
       END
