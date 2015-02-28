with ada.Text_IO; use Ada.Text_IO;
procedure Hangman is
	image : array(1..12) of string(1..12);
	guesses : string(1..26);
	word : string(1..20);
	word_guess : string(1..20);
	dashes : string(1..20);
	letter_guess : character;
	answer : character;
	used : array(1..50) of integer := (1..50 => 0);
	length : integer;
	n_guesses : integer;
	dict_index : integer;
	n_replaced : integer;
	dictionary : array(1..50) of string(1..20) := (
		"gum                 ",
		"sin                 ",
		"for                 ",
		"cry                 ",
		"lug                 ",
		"bye                 ",
		"fly                 ",
		"ugly                ",
		"each                ",
		"from                ",
		"work                ",
		"talk                ",
		"with                ",
		"self                ",
		"pizza               ",
		"thing               ",
		"feign               ",
		"fiend               ",
		"elbow               ",
		"fault               ",
		"dirty               ",
		"budget              ",
		"spirit              ",
		"quaint              ",
		"maiden              ",
		"escort              ",
		"pickax              ",
		"example             ",
		"tension             ",
		"quinine             ",
		"kidney              ",
		"replica             ",
		"sleeper             ",
		"triangle            ",
		"kangaroo            ",
		"mahogany            ",
		"sergeant            ",
		"sequence            ",
		"moustache           ",
		"dangerous           ",
		"scientist           ",
		"different           ",
		"quiescent           ",
		"magistrate          ",
		"erroneously         ",
		"loudspeaker         ",
		"phytotoxic          ",
		"matrimonial         ",
		"parasympathomimetic ",
		"thigmotropism       "
	);
begin
end Hangman;
