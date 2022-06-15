#Name: Timothy Dakis
#Last Modified Date: 12/02/2019
#Program name: DakisT_h2.s
#
#The program gets the user to input 10 integers, it then gets the sum and min of them, and then prints the array in reverse order
#
#PseudoCode:
#
#	int arr[10] = {}, min, sum;
#	for (int i = 0; i < 10; i++) { arr[i] = user input;}
#	min = arr[0];
#	for (int i = 0; i < 10; i++) { compares min to arr[i], if arr[i] < min then min = arr[i]; }
#   for (int i = 0; i < 10; i++) { sum += arr[i];}
#   for (int i = 9; i >= 0; i--) { print arr[i] then print a new line;}
#
# $s0: Array Adress
# $s1: Array Value
# $s2: Sum Value
# $s3: Min Value

.data
ARRAY: .space 40
Sum: .asciiz "The Sum is: "
Min: .asciiz "The Smallest number is: "
Reverse: .asciiz "The Reverse order is: \n"
NewLine: .asciiz "\n"
Prompt: .asciiz "Input 10 integers\n"

.text
.globl main
main:

#a counter variable
li $t0, 10
#initialize Sum Value register so it is not empty
li $s2, 0

#loads address of array into register
la $s0, ARRAY

#prompts user
la $a0, Prompt
li $v0, 4
syscall

InputLoop:
	beq $t0, $zero, InputLoopEnd
	
	#gets user input to store into Array Value register
	li $v0, 5
	syscall
	move $s1, $v0
	
	#stores value into Array
	sw $s1, 0($s0)
	#moves to next element in array so it can store there after
	addi $s0, $s0, 4
	
	addi $t0, $t0, -1
	j InputLoop

InputLoopEnd:

	#refresh address of array in register and create another counter
	la $s0, ARRAY
	li $t2, 10
	
	#gets value from array
	lw $s1, 0($s0)
	addi $s3, $s1, 0
MinLoop:
	beq $t2, $zero, MinLoopEnd
	
	add $s2, $s2, $s1 #adds array value to sum
	slt $t0, $s1, $s3 #checks if current value is less than current min number
	bne $t0, $zero, SetMin
MinCont:
	addi $s0, $s0, 4 #go to next element of array
	lw $s1, 0($s0) #get next array value
	addi $t2, $t2, -1 #decrease counter
	j MinLoop

SetMin:
	move $s3, $s1	
	j MinCont

MinLoopEnd:
	
	#prints min value
	la $a0, Min
	li $v0, 4
	syscall

	li $v0, 1
	move $a0, $s3
	syscall
	
	la $a0, NewLine
	li $v0, 4
	syscall
	
	#prints sum value
	la $a0, Sum
	li $v0, 4
	syscall

	li $v0, 1
	move $a0, $s2
	syscall
	
	la $a0, NewLine
	li $v0, 4
	syscall
	
	#creates new counter
	li $t3, 10
	
	la $a0, Reverse
	li $v0, 4
	syscall
	
	addi $s0, $s0, -4 #sets it to end of array, as previous loop left it 1 element after the array ends
ReversePrint:
	beq $t3, $zero, End
	lw $s1, 0($s0)
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	la $a0, NewLine
	li $v0, 4
	syscall
	
	addi $t3, $t3, -1
	addi $s0, $s0, -4 #goes to the element before in the address
	
	j ReversePrint
	
End:
	li $v0, 10
	syscall
