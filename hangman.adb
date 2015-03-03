-- hangman.adb
-- A simple interactive hangman game
-- Adapted from code by Michael Wirth for CIS3190W15
-- @author Ryan Wilson-Perkin (rwilsonp)
with ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.Numerics.Discrete_Random;
with ada.Strings.Maps; use ada.Strings.Maps;
procedure Hangman is
    type Word_Range is range 1..50;
    package Rand_Index is new ada.Numerics.Discrete_Random(Word_Range);
    use Rand_Index;
    gen : Rand_Index.Generator;

    image : array(1..12) of string(1..12);
    guesses : string(1..26);
    letter_guess : character;
    answer : character;
    counter : integer;

    word : string(1..20);
    word_length : integer;
    
    word_guess : string(1..20);
    word_guess_length : integer;

    hidden : string(1..20);
    hidden_length : integer;

    n_guesses : integer;
    n_mistakes : integer;
    n_replaced : integer;

    used : array(Word_Range) of Boolean := (Word_Range => false);
    dict_index : Word_Range;
    dictionary_lengths : array(Word_Range) of integer := (
        3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5,
        6, 6, 6, 6, 6, 6, 7, 7, 7, 6, 7, 7, 8, 8, 8, 8, 8, 9, 9, 9, 9,
        9, 10, 11, 11, 10, 11, 19, 13);
    dictionary : array(Word_Range) of string(1..20) := (
        "gum                 ", "sin                 ", "for                 ",
        "cry                 ", "lug                 ", "bye                 ",
        "fly                 ", "ugly                ", "each                ",
        "from                ", "work                ", "talk                ",
        "with                ", "self                ", "pizza               ",
        "thing               ", "feign               ", "fiend               ",
        "elbow               ", "fault               ", "dirty               ",
        "budget              ", "spirit              ", "quaint              ",
        "maiden              ", "escort              ", "pickax              ",
        "example             ", "tension             ", "quinine             ",
        "kidney              ", "replica             ", "sleeper             ",
        "triangle            ", "kangaroo            ", "mahogany            ",
        "sergeant            ", "sequence            ", "moustache           ",
        "dangerous           ", "scientist           ", "different           ",
        "quiescent           ", "magistrate          ", "erroneously         ",
        "loudspeaker         ", "phytotoxic          ", "matrimonial         ",
        "parasympathomimetic ", "thigmotropism       ");
begin

    -- Output intro message, before entering program loop
    put_line("The Game of Hangman");

    counter := 1;
    while counter <= 50 loop

        -- Initialize image
        image(1) := (1..7 => 'X') & (1..5 => ' ');
        for i in 2..12 loop
            image(i)(1) := 'X';
            image(i)(2..12) := (2..12 => ' ');
        end loop;
        image(2)(7) := 'X';

        -- Initialize other values
        hidden := (1..20 => '-');
        guesses := (1..26 => ' ');
        n_mistakes := 0;
        n_guesses := 0;

        -- Get random word from dictionary
        loop
            dict_index := Random(gen);
            exit when used(dict_index) = false;
        end loop;
        used(dict_index) := true;
        word := dictionary(dict_index);
        word_length := dictionary_lengths(dict_index);
        hidden_length := word_length;

        -- Print number of dashes for hidden word
        put_line(hidden(1..hidden_length));

        while n_mistakes <= 10 loop

            -- Report letters that have been guessed
            put("The letters you have used so far are: ");
            for i in 1..n_guesses loop
                put(guesses(i));
                put(',');
            end loop;
            put_line(" ");

            -- Get next letter guess
            put("Please guess a letter: ");
            get(letter_guess);
            skip_line;

            -- Check if the letter has been guessed already
            if Is_In(letter_guess, To_Set(guesses)) then
                put_line("You have guessed that letter before.");
            else
                n_guesses := n_guesses + 1;
                guesses(n_guesses) := letter_guess;

                -- Replace dashes in hidden with matching letter
                n_replaced := 0;
                for i in 1..word_length loop
                    if word(i) = letter_guess then
                        hidden(i) := letter_guess;
                        n_replaced := n_replaced + 1;
                    end if;
                end loop;

                -- Print updated image if letter_guess wasn't a match
                if n_replaced = 0 then
                    n_mistakes := n_mistakes + 1;
                    put_line("Sorry, that letter isn't in the word.");

                    -- Update the image
                    case n_mistakes is
                        when 1 =>
                            put_line("First we draw a head.");
                            image(3)(6) := '-';
                            image(3)(7) := '-';
                            image(3)(8) := '-';
                            image(4)(5) := '(';
                            image(4)(6) := '.';
                            image(4)(8) := '.';
                            image(4)(9) := ')';
                            image(5)(6) := '-';
                            image(5)(7) := '-';
                            image(5)(8) := '-';
                        when 2 =>
                            put_line("Now we draw a body.");
                            image(6)(7) := 'X'; 
                            image(7)(7) := 'X'; 
                            image(8)(7) := 'X'; 
                            image(9)(7) := 'X'; 
                        when 3 =>
                            put_line("Next we draw an arm.");
                            image(4)(3) := '\'; 
                            image(5)(4) := '\'; 
                            image(6)(5) := '\'; 
                            image(7)(6) := '\'; 
                        when 4 =>
                            put_line("This time it's the other arm.");
                            image(4)(11) := '/';
                            image(5)(10) := '/';
                            image(6)(9) := '/';
                            image(7)(8) := '/';
                        when 5 =>
                            put_line("Now, Let's draw the right leg.");
                            image(10)(6) := '/';
                            image(11)(5) := '/';
                        when 6 =>
                            put_line("This time we draw the left leg.");
                            image(10)(8) := '\';
                            image(11)(9) := '\';
                        when 7 =>
                            put_line("Now we put up a hand.");
                            image(3)(11) := '\';
                        when 8 =>
                            put_line("Next the other hand.");
                            image(3)(3) := '/';
                        when 9 =>
                            put_line("Now we draw one foot");
                            image(12)(10) := '\';
                            image(12)(11) := '-';
                        when 10 =>
                            put_line("Here's the other foot.");
                            put_line("You're hung!!");
                            image(12)(4) := '-';
                            image(12)(3) := '\';
                        when others =>
                            null;
                    end case;

                    -- Draw the image
                    for i in 1..12 loop
                        put_line(image(i));
                    end loop;
                elsif Is_In('-', To_Set(hidden(1..hidden_length))) then

                    -- Check users guess for the solution
                    put_line(hidden(1..hidden_length));
                    put_line("Please guess the word: ");
                    get_line(word_guess, word_guess_length);
                    if word_length = word_guess_length and
                            word(1..word_length) = word_guess(1..word_guess_length) then
                        put("That's correct! It took you ");
                        put(n_guesses);
                        put_line(" guesses.");
                        exit;
                    else
                        put_line("That's incorrect.");
                    end if;
                else
                    put_line("You found all the letters in the word!");
                end if;
            end if;
        end loop;

        -- Output condolences if user failed to guess the word in 10 turns
        if n_mistakes = 10 then
            put_line("Sorry, you lose. The word was " & word(1..word_length));
        end if;

        -- Prompt user for another round
        put_line("Would you like another word? (Y/N)");
        get(answer);

        -- Exit program loop if user says anything but 'Y'
        if answer /= 'Y' then
            exit;
        end if;
        counter := counter + 1;
    end loop;

    -- Output congratulations message if user completed every word
    if counter = 51 then
        put_line("You did all the words.");
    end if;

    -- Output final message
    put_line("Thanks for playing!");
end Hangman;
