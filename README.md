Hangman
===

Porting Legacy Fortran
---

As discussed in assignment 1, modern Fortran is actually quite nice.
Unfortunately, the legacy Fortran code we were supplied with for this
assignment was littered with bad unideal programming constructs such as
goto/labels, and arithmetic-if-statements. The first step to implementing an
Ada version was to convert the legacy Fortran into its modern counterpart in
order to better understand the control flow of the program.

Thankfully, we already learned how to update Fortran code in assignment 1, so
the conversion process wasn’t terribly painful. The order in which I upgraded
the Fortran was as follows:

- Updating legacy comments (purely aesthetic, I dislike the “C” character as a
comment)
- Update string array declaration
- Clarify assignment of characters to the ASCII drawing of the hung man
- Convert go-tos to iteration and conditional statements
- Replace loops that rely on labels with iterative loops
- Use CYCLE in loops, rather than go-to jumps
- Remove unused labels
- Upgrade variable names to be more meaningful
- Switch to lowercase naming convention (purely aesthetic, looks less like
yelling)
- Update format specifiers
- Switch to free-form indentation
- Fix bugs
- Add documentation

As much as I’d like to claim that my recollection of these steps is due to my
documentation and attention to detail, in truth it is simply from reading the
version control log. Let this serve as lesson that good commit messages are
incredibly important for tracking project progress.

Porting Modern Fortran to Ada
---

Once the legacy Fortran had been updated, I was able to build a (mostly)
isomorphic Ada program. The two programs are not completely similar because
each language has its strengths and weaknesses that must be worked around. For
Ada, the predominant weakness is its use of strings.

Strings in Ada are fundamentally weaker than those in Fortran because they
operate exclusively like a fixed array of characters, and lack many of the
string-based procedures found in other similar languages. Since strings are a
fixed length, the Ada compiler cannot initialize the variable with a string
smaller than the full size. This is a problem for our dictionary array of
strings since it uses various sized strings. (I became aware of the “unbounded”
strings library much too late in the process I’m afraid.)

To get around this problem I used a cheap hack; I build an array of strings and
manually padded them with spaces, and an equivalent array of ints listing the
“true” length of each string. This is not great programming practice, and had I
spent more time on the project I would’ve likely implemented some convenience
functions for working with strings, such as determining the “true” length of
any given string.

Another Ada limitation I had to work around was the lack of vector-based
instructions. Fortran has many useful functions (built-in or otherwise
included) for doing functional programming on lists of elements. One particular
tool is the “any” keyword, which takes an array and a comparator, and returns
true if that comparator returns true for any element in the array. I made use
of this tool in my modernized Fortran code to check if there were any dashes
left in the hidden word, and to see if the letter had been guessed before.
Since this tool is missing in Ada, I had to determine the equivalent code which
consisted of iterating over the array with a loop and optionally setting a
truthhood flag. This felt contrary to the way that Ada usually works, and
thankful I was able to factor the code out by restructuring the program
slightly.

Ada doesn’t have the built-in support for discrete random numbers that Fortran
has. In fact, Fortran is shifting away from that model as well, but still
maintains the RAND() function for backwards-compatibility. In Ada it is
necessary to take several more steps to generate a random number: “use” the
ada.Numerics.Discrete_Random library, create a new range type of the required
size, and generate a package from a generic using the new range type. That can
easily be setup in the initialization of the Hangman procedure, then a random
number can be produced by a generator class found in the produced package. The
syntax took mental adjustment, but the ability to create generic packages
(similar to templating in C++) is quite interesting from an object oriented
design standpoint.

Ultimately, the actual Hangman logic required very little optimization; once
the code was reduced from the original tangled constructs it was a very
straightforward program. The new version makes heavy use of loops for
controlling program flow between distinct sections, and is well documented to
explain the process to anyone new to Ada.

Additional Questions
--- 

### Would it have been easier to re-write the program from scratch in a language such as C?

Since the program itself is relatively simple, yes. There aren’t many different
routed in the program logic, so a beginner could quite easily identify the flow
of the program through simple black box testing, without requiring the original
source code. I was committed to providing a direct translation between legacy
and modern Fortran, so I forced myself to modernize pieces one-at-a-time; but I
was sorely tempted to just start from scratch. The main reason C would be
easier than Ada is because of the handy string.h library for working with
strings of various lengths. Additionally, the C standard library provides a
cleaner API for working with random numbers, though implementing the same in
Ada was not particularly tiresome.

### Is your program shorter or longer? Why?
The original Fortran program was 145 lines. The updated Fortran is 198 lines.
The Ada program is a healthy 236 lines! The bloat here is largely due to the
need to create looping structures to replace go-tos and labels, but it is also
in no-small-part from the addition of documentation. The original program was
insidiously devoid of explanatory comments, and the addition of them in the Ada
program is very helpful for the reader’s understanding.

### Is there a better way of writing the program?
Absolutely! The program could benefit significantly from being exploded into a
true Ada “package”. Ada uses the concept of packages for grouping together
groups of related content, and in this case we could easily factor out
subsections into their own distinct projects. Fetching a random word from the
dictionary, is a piece of work that can easily be divorced from the rest of the
program structure and thus should be in it’s own project. Similarly, printing
out the ASCII gallows may not constitute a program of it’s own, but could
likely be a separate procedure call, that accepted a single number (for the
number of mistakes so far).

