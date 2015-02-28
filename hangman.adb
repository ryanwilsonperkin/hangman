with ada.Text_IO; use Ada.Text_IO;
with ada.Numerics.Discrete_Random;
procedure Hangman is
    type Word_Range is range 1..50;
    package Rand_Index is new ada.Numerics.Discrete_Random(Word_Range);
    use Rand_Index;
    gen : Rand_Index.Generator;

    image : array(1..12) of string(1..12);
    guesses : string(1..26);
    letter_guess : character;
    answer : character;

    word : string(1..20);
    word_length : integer;
    
    word_guess : string(1..20);
    word_guess_length : integer;

    hidden : string(1..20);
    hidden_length : integer;

    n_guesses : integer;
    n_mistakes : integer;

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
    put_line("The Game of Hangman");
    for counter in 1..50 loop

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
    end loop;
end Hangman;
