TITLE Program Template     (Assignment2.asm)

; Author: Parker Howell
; Course / Project ID      CS271 Assignment 2            
; Date: 7-9-16
; Description: The program will ask the user for an amout of fibonacci terms to be 
;              displayed. The results will be displayed 5 terms per line with at least 5 
;              spaces between terms. The program will end after displaying a departing 
;              message.

INCLUDE Irvine32.inc

MINFIB = 1     ; smallest user entered amount of fibonacci numbers to display
MAXFIB = 46    ; largest user entered amount of fibonacci numbers to display
               ; Note: values larger than 46 are too big for DWORDs
PERLINE = 5    ; number of fibonacci terms to print per line


.data

userName     BYTE      33 DUP(0) ; string entered by user of their name     
userFibs     DWORD     ?         ; user entered integer amount of fibonacci numbers to display
outerCount   DWORD     ?         ; saves outer loop counter when printing fib numbers
fib1         DWORD     1         ; first fibonacci number
fib2         DWORD     1         ; second fibonacci number
fibSum       DWORD     1         ; sum of fib1 and fib2, starts at 1
fibCount     DWORD     0         ; counts how many fib numbers have been printed per line

intro      BYTE     "Hello, and welcome to Parker Howell's assignment 2, fibonacci program!", 0
askName    BYTE     "Will you please tell me your name?: ", 0
greet      BYTE     "Nice to meet you, ", 0
instruct   BYTE     "OK, so this works by you giving me a number between 1 and 46, and then "
           BYTE     "I will display that many sequential fibonacci numbers to the console.",0dh,0ah
           BYTE     "Please enter a number between 1 and 46: ", 0
bigNum     BYTE     "You entered a number that is too large.", 0
smallNum   BYTE     "You entered a number that is too small.", 0
reEnter    BYTE     "Please enter a number between 1 and 46: ", 0
spaces     BYTE     "     ", 0
bye        BYTE     "Hey, look at those numbers! Bye, ", 0


.code
main PROC

     call Clrscr    ; clears the screen

; a) introduction - display the program title and my name
     mov       edx, OFFSET intro
     call      WriteString
     call      CrLf


; get the users name and greet the user
     mov       edx, OFFSET askName      ; ask for name
     call      WriteString
     mov       edx, OFFSET userName     ; set up userName variable for input
     mov       ecx, 32                  ; limit userName size
     call      Readstring               ; read users name from keyboard
     call      CrLf

     mov       edx, OFFSET greet        ; greet the user now that we know their name
     call      WriteString
     mov       edx, OFFSET userName     ; append the user name to greeting
     call      WriteString
     call      CrLf                     ; formatting...
     call      CrLf


; b) userInstructions - Prompt the user to enter a number between 1-46
;                       to display that many fibonacci numbers
     mov       edx, OFFSET instruct     ; tell user what will happen and to enter a value
     call      WriteString


; c) getUserData - get and validate the input (n) with a post test loop
     Validate:      call      ReadDec                  ; read user input
                    mov       userFibs, eax            ; save the input

                    cmp       userFibs, MINFIB         ; if user value is less than MINFIB
                    jl        TooSmall                 ; jump to TooSmall

                    cmp       userFibs, MAXFIB         ; if user value is larger than MAXFIB
                    jg        TooBig                   ; jump to TooBig

                    jmp       GoodNum                  ; otherwise the value is within range
                                                       ; continue with program

     ; if the user value was too small
     TooSmall:      call      CrLf
                    mov       edx, OFFSET smallNum     ; tell the user the number was too small
                    call      WriteString
                    call      CrLf
                    jmp       RePrompt                 ; jump to RePrompt to ask user to enter another num

     ; if the user value was too big
     TooBig:        call      CrLf
                    mov       edx, OFFSET bigNum       ; tell the user the number was too big
                    call      WriteString
                    call      CrLf                     ; falls through to RePrompt

     ; ask user to enter another number
     RePrompt:      mov       edx, OFFSET reEnter      ; ask the user to re-enter an new number
                    call      WriteString
                    jmp       Validate                 ; jump to top to have user reenter another number

     ; if the user value was within range
     GoodNum:            ; carry on with the program
     call      CrLf      ; formatting



; d) displayFibs - calculate (with loop) and display all of the Fibonacci 
;                  numbers up to and including the (n)th term.
;                  5 per line with 5 spaces between each

     mov         ecx, userFibs                  ; set the loop counter
     FibLoop:  
                 mov     eax, fib1              ; write the current fibonacci number
                 call    WriteDec
                 mov     edx, OFFSET spaces     ; write the spaces that seperate the fib numbers
                 call    WriteString
                 inc     fibCount               ; track how many fibs have been printed
                 
                 cmp     fibCount, PERLINE      ; if num of fib numbers is less than PERLINE then dont CrLF
                 jl      SameLine               

                 call    CrLf                   ; otherwise print a newline 
                 mov     fibCount, 0            ; and reset fibCount

     SameLine:   
                 ; set fib1 and fib2 to the next to fib numbers
                 mov     eax, fib1              ; calculate next fib number
                 add     fibSum, eax              

                 mov     eax, fib2              ; set fib1 to value in fib2
                 mov     fib1, eax   

                 mov     eax, fibSum            ; set fib2 to value of fibSum
                 mov     fib2, eax

                 Loop    FibLoop                ; repeat userFibs times

                 call CrLf                      ; formatting                 
                 call CrLf

; e) farewell - display parting message with users name
     mov       edx, OFFSET bye
     call      WriteString
     mov       edx, OFFSET userName
     call      WriteString
     call      CrLf
     call      CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
