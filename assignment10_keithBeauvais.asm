#;	Assignment #10
#; 	Author: Keith Beauvais
#; 	Section: 1001
#; 	Date Last Modified: 11/13/2021
#; 	Program Description: TThe program will use a cocktail sort to sort a list of numbers in ascending order.

.data
unsortedList:   .word 57, 307, 757, 64, 335, 832, 885, 475, 25, 309
                .word 258, 439, 285, 685, 934, 881, 345, 64, 742, 776
                .word 316, 778, 818, 356, 482, 628, 283, 444, 537, 921
                .word 676, 428, 288, 587, 569, 420, 706, 395, 25, 852
                .word 402, 930, 196, 68, 745, 70, 698, 87, 384, 144
                .word 353, 345, 782, 45, 510, 296, 315, 2, 309, 676
                .word 556, 794, 45, 289, 423, 79, 899, 337, 71, 525
                .word 16, 313, 291, 763, 437, 855, 125, 419, 582, 70
                .word 948, 112, 220, 131, 369, 332, 282, 196, 470, 152
                .word 935, 753, 197, 964, 362, 998, 371, 838, 338, 644

swapLeftFlag: .word 0
swapRightFlag: .word 0
medianInt: .word 0

#;	System Services
SYSTEM_EXIT = 10
SYSTEM_PRINT_INTEGER = 1
SYSTEM_PRINT_STRING = 4	

#;	Labels
unsorted: .asciiz "Unsorted List :"
sorted: .asciiz "Sorted List :"
median: .asciiz "Median: "
newLine: .asciiz "\n"
space: .asciiz "  "


ARRAY_SIZE = 100
COUNTER = 0 


.text
.globl main
.ent main
main:
    #; Print out "unsorted"
    li $v0, SYSTEM_PRINT_STRING
    la $a0, unsorted
    syscall
    #; Prints out a new line list
    li $v0, SYSTEM_PRINT_STRING
    la $a0, newLine
    syscall

    #; Prints out the unsorted list
    la $t0, unsortedList #; address to the start of the array 
    li $t1, ARRAY_SIZE #; size of the array
    li $t2, COUNTER #; counter
    li $t3, 5   #; how many columns  

    #; Loop for printing out array 
    printUnsortedArray:
        #; prints the integer to console
        li $v0, SYSTEM_PRINT_INTEGER
        lw $a0, ($t0)
        syscall

        #; Space
        li $v0, SYSTEM_PRINT_STRING
        la $a0, space
        syscall

        addu $t0, $t0, 4 #; increase the index of array by 1 
        subu $t1, $t1, 1 #; subtract the size of the array
        addu $t2, $t2, 1 #; increase counter by 1 

        bne $t2, $t3, printUnsortedArray #; if the counter is not equal to the column size then loop otherwise new line

    endLine:
        #; New line
        li $v0, SYSTEM_PRINT_STRING
        la $a0, newLine
        syscall

        #; resets counter
        li $t2, 0 
        bnez $t1, printUnsortedArray #; if the array size is not 0 then loop other wise end of array 

        #; New line 
        li $v0, SYSTEM_PRINT_STRING
        la $a0, newLine
        syscall
    #; prints out "sorted"
    li $v0, SYSTEM_PRINT_STRING
    la $a0, sorted
    syscall

    #; New line 
    li $v0, SYSTEM_PRINT_STRING
    la $a0, newLine
    syscall
    
    #; function call cocktailSort passes in:
    #; a0, address to array 
    #; a1, the size of the array 
    la $a0, unsortedList
    li $a1, ARRAY_SIZE
    jal cocktailSort

    #; Prints out the sorted list
    la $t0, unsortedList
    li $t1, ARRAY_SIZE
    li $t2, COUNTER
    li $t3, 5
    
    #; Loop for printing out array 
    printSortedArray:

        li $v0, SYSTEM_PRINT_INTEGER
        lw $a0, ($t0)
        syscall

        li $v0, SYSTEM_PRINT_STRING
        la $a0, space
        syscall

        addu $t0, $t0, 4 #; increase the index of array by 1 
        subu $t1, $t1, 1 #; subtract the size of the array
        addu $t2, $t2, 1 #; increase counter by 1 

        bne $t2, $t3, printSortedArray #; if the counter is not equal to the column size then loop otherwise new line

    endNewLine:

        li $v0, SYSTEM_PRINT_STRING
        la $a0, newLine
        syscall

        li $t2, 0 
        bnez $t1, printSortedArray

        li $v0, SYSTEM_PRINT_STRING
        la $a0, newLine
        syscall
    
    #; Prints out median
    li $v0, SYSTEM_PRINT_STRING
    la $a0, median
    syscall

    li $t0, ARRAY_SIZE #; takes in array size
    div $t0, $t0, 2 #; divides array size by 2 
    la $t1, unsortedList #; takes the address of the sorted array 
    mul $t3, $t0, 4 #; multiplies the half of array size and multiplies by 4 for offset 
    add $t4, $t1, $t3 #; adds offset to address

    lw $t5, ($t4)  #; takes the value at the offset address and loads it to t5  
    sub $t4, $t4, 4 #; moves bakc one index

    lw $t6, ($t4)   #; takes the value at the offset address and loads it to t6 
    add $t7, $t5, $t6 #; adds the two middle values
    div $t8, $t7, 2 #; divides them by 2

    sw $t8, medianInt #; stores the median into medianInt variable 

    #; Prints out the median value 
    li $v0, SYSTEM_PRINT_INTEGER
    lw $a0, medianInt
    syscall


li $v0, SYSTEM_EXIT
syscall
.end main

#; cocktailSort Function calls both shakeLeft and shakeRight
#; a0, address to array 
#; a1, the size of the array 
.globl cocktailSort
.ent cocktailSort
cocktailSort:
    subu $sp, $sp, 4
    sw $ra, 0($sp)

    addu $fp, $sp, 4 #; set frame pointer

    move $t7, $a0 #; saves address for array 

    sortLoop:
        #; passes in the address of the array and array size into shakeLeft
        move $a0, $t7
        li $a1, ARRAY_SIZE
        jal shakeLeft
        sw $v0, swapLeftFlag #; saves the flag the swapLeftFlag 1= swap 0= no swap 

        #; address is already at the end of the index so its good 
        li $a1, ARRAY_SIZE
        jal shakeRight
        sw $v0, swapRightFlag 

        lw $t2, swapLeftFlag
        lw $t3, swapRightFlag

        #; resets the swapLeftFlag with 0 
        li $t4, 0 
        sw $t4, swapLeftFlag

        #; resets the swapRightFlag with 0 
        li $t4, 0 
        sw $t4, swapRightFlag

        #; adds the flag totals anything larger than 0 means at least 1 swap occured and to reloop
        addu $t2, $t2, $t3
        bnez $t2, sortLoop

    lw $ra, 0($sp)
    addu $sp, $sp, 4

    jr $ra

.end cocktailSort

#; shakeLeft function call
#; a0, address to array 
#; a1, the size of the array 
.globl shakeLeft
.ent shakeLeft
shakeLeft:

    subu $a1, $a1, 1
    li $v0, 0 #; return and flag for later

    arrayLeftLoop:
        beqz $a1, endLeftFuction
        lw $t0, ($a0) #; loads in value from address 
        lw $t1, 4($a0) #; loads in value from the next address 
        bgt $t0, $t1, swapValue #; if the first index is larger than the next index then swap needs to happen 
        move $t0, $t1 
        addu $a0, $a0, 4 #; move to next index
        lw $t1, 4($a0) #; load in value from the next index
        subu $a1, $a1, 1 #; subtract one from the array size 
        j arrayLeftLoop

    swapValue:
        lw $t5, ($a0) #; takes value from address location and stores in 
        lw $t6, 4($a0) #; takes value from next address location and stores in  
        sw $t5, 4($a0) #; saves the next index and saves it in one less index
        sw $t6, ($a0) #; saves the current index and saves it in one more index
        li $v0, 1 #; returns a 1 meaning a swap occured

        beqz $a1, endLeftFuction
        subu $a1, $a1, 1
        addu $a0, $a0, 4
        j arrayLeftLoop

    endLeftFuction:

    jr $ra
.end shakeLeft

.globl shakeRight
.ent shakeRight
shakeRight:

    subu $a1, $a1, 1
    li $v0, 0 #; return and flag for later

    arrayRightLoop:
        beqz $a1, endRightFuction
        lw $t0, ($a0) #; loads in value from address 
        lw $t1, -4($a0) #; loads in value from the next address going backwards
        blt $t0, $t1, swapRightValue #; if the first index is less than the next index then swap needs to happen 
        move $t0, $t1 
        subu $a0, $a0, 4 #; move to next index
        lw $t1, -4($a0) #; load in value from the next index
        subu $a1, $a1, 1 #; subtract one from the array size 
        j arrayRightLoop

    swapRightValue:
        lw $t5, ($a0) #; takes value from address location and stores in 
        lw $t6, -4($a0) #; takes value from next address location and stores in  
        sw $t5, -4($a0) #; saves the next index and saves it in one less index
        sw $t6, ($a0) #; saves the current index and saves it in one more index
        li $v0, 1 #; returns a 1 meaning a swap occured


        beqz $a1, endRightFuction
        subu $a1, $a1, 1
        subu $a0, $a0, 4
        j arrayRightLoop

        endRightFuction:

    jr $ra
.end shakeRight