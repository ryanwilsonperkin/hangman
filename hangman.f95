!      game of hangman by dave ahl, digital
!      based on a basic program written by ken aupperle
!            half hallow hills h.s. dix hills ny
!      converted to fortran 77 by m.wirth, april 2012
!       
program hangman 
implicit none
character :: image(12,12)
character :: guesses(26)
character :: dashes(20), a*20, guess, b*20, ans 
integer :: used(50)
integer :: length
integer :: counter
integer :: flag
integer :: n_guesses
integer :: q, mistakes, i, j, r

character (len=20), dimension(50) :: dict

data dict/'gum','sin','for','cry','lug','bye','fly','ugly', &
   'each','from','work','talk','with','self', &
   'pizza','thing','feign','fiend','elbow','fault', &
   'dirty','budget','spirit','quaint','maiden', &
   'escort','pickax','example','tension','quinine', &
   'kidney','replica','sleeper','triangle', &
   'kangaroo','mahogany','sergeant','sequence', &
   'moustache','dangerous','scientist','different', &
   'quiescent','magistrate','erroneously', &
   'loudspeaker','phytotoxic','matrimonial', &
   'parasympathomimetic','thigmotropism'/
write (*,*) "the game of hangman"

! initialize counter
counter = 1
! initialize "used" words tracker
used = 0

do counter=1,50
    ! assign ascii gallows 
    image = " "
    do i = 1,12
        image(i,1) = "x"
    end do
    do j = 1,7
        image(1,j) = "x"
    end do
    image(2,7) = "x"
 
    ! initialize other values
    dashes = "-"
    guesses = " "
    mistakes = 0 
    n_guesses = 0
    flag = 0
 
    ! get random remaining word from dictionary
    do
        q=ceiling(rand()*50)
        if (used(q) .eq. 0) exit
    end do
    used(q) = 1
    a = dict(q)
    length = len_trim(a) 
    
    ! write number of dashes for current word
    write (*,*) dashes(1:length)
 
    do while (mistakes .lt. 10)
 
        ! write current guesses
        write (*,*) "here are the letters you used: "
        do i = 1,26
            if (guesses(i) .eq. ' ') exit
            write (*,"(2a)",advance='no') guesses(i), ","
        end do
 
        ! prompt for next guess
        write (*,*) " "
        write (*,*) "what is your guess? "
        read (*,*) guess 
 
        ! check if guess is a repeat
        do i = 1,26
            if (ichar(guesses(i)) .eq. ichar(guess)) flag = 1
        end do
        if (flag .eq. 1) then
            write (*,*) "you guessed that letter before"
            cycle
        end if
 
        ! add current guess to list
        n_guesses = n_guesses + 1
        guesses(n_guesses) = guess
        r=0
        do i = 1,length
            if (a(i:i) .eq. guess) then
                dashes(i) = guess
                r=r+1
            end if
        end do
 
        if (r .ne. 0) then
            flag = 0
            do i = 1,length
                if (ichar(dashes(i)) .eq. ichar("-")) flag = 1
            end do
            if (flag .eq. 1) then
                write (*,*) dashes(1:length)
                write (*,*) "what is your guess for the word? "
                read (*,*) b
                if (a .eq. b) then
                    exit
                else
                    write (*,*) "wrong. try another letter"
                    cycle
                end if
            else
                write (*,*) "you found the word."
                exit
            end if
        end if
 
        mistakes = mistakes+1
        write (*,*) "sorry, that letter isn't in the word."
        select case (mistakes)
            case (1)
                write (*,*) "first we draw a head."
                image(3,6) = "-"
                image(3,7) = "-"
                image(3,8) = "-"
                image(4,5) = "(" 
                image(4,6) = "."
                image(4,8) = "."
                image(4,9) = ")"
                image(5,6) = "-"
                image(5,7) = "-" 
                image(5,8) = "-"
            case (2)
                write (*,*) "now we draw a body."
                do i = 6,9
                    image(i,7) = "x" 
                end do
            case (3)
                write (*,*) "next we draw an arm."
                do i = 4,7
                    image(i,i-1) = "\" 
                end do
            case (4)
                write (*,*) "this time it's the other arm."
                image(4,11) = "/"
                image(5,10) = "/"
                image(6,9) = "/"
                image(7,8) = "/" 
            case (5)
                write (*,*) "now, let's draw the right leg."
                image(10,6) = "/"
                image(11,5) = "/"
            case (6)
                write (*,*) "this time we draw the left leg."
                image(10,8) = "\"
                image(11,9) = "\"
            case (7)
                write (*,*) "now we put up a hand."
                image(3,11) = "\"
            case (8)
                write (*,*) "next the other hand."
                image(3,3) = "/"
            case (9)
                write (*,*) "now we draw one foot."
                image(12,10) = "\"
                image(12,11) = "-"
            case (10)
                write (*,*) "here's the other foot"
                write (*,*) "you're hung!!."
                image(12,3) = "-"
                image(12,4) = "/" 
        end select
 
        do i = 1,12
            write (*,*) (image(i,j),j=1,12)
        end do
    end do
    if (mistakes .eq. 10) then
        write (*,*) "sorry, you loose. the word was ", a
        write (*,*) "you missed that one."
    else if (a .eq. b) then
        write (*,*) "right! it took you ",n_guesses," guesses"
    end if
 
    write (*,*) "do you want another word? (Y/N) "
    read (*,*) ans
    if (ichar(ans) .eq. ichar("Y")) then
        cycle
    else
        write (*,*) "it's been fun! bye for now."
        exit
    end if
end do
if (counter .eq. 50) then
   write (*,*) "you did all the words"
end if
write (*,*) "ending..." 
end
