all: ada

fortran: hangman.f95
	gfortran --std=f95 -fall-intrinsics hangman.f95 -o hangman

ada: hangman.adb
	gcc -c hangman.adb
	gnatmake hangman.adb

clean:
	rm *.o *.ali
