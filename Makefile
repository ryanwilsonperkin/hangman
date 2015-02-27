all: fortran

fortran: hangman.f95
	gfortran --std=f95 -fall-intrinsics hangman.f95 -o hangman
