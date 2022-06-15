#Name: Timothy Dakis
#Last Modified Date: 12/15/2019
#Program name: Dakis_T_h2.s
#
#The program gets the user to input a value k between 1 to 10. If 1<=k<5 then it will go to a Case1 which gets the user to input a value n that is >=0. 
#After n is obtained it will call a recursive function that computes 5*function(n-2)+n, it then asks for a new n after it computes the value. 
#If 5<=k<=10 the program outputs a joke. For any other k the program terminates
#
#PseudoCode:
#int main(){
#	k = user input;
#	if(k >= 1 && k < 5) go to Case1;
#	if(k >= 5 && k < 10) go to Case2;
#	else terminate program;
#	
#Case1:
#	n = user input;
#	if (n < 0) terminate program to break infinite loop;
#	calls Function(n);
#	goto Case1 (to loop);
#
#Case2:
#	outputs a joke;
#	terminate program;
#}
#
#Function(n){
# if(n == 0 || n == 1) return 20;
# else return 5*Function(n-2)+n;
#
#Registers:
#$s0: user input k
#$s1: user input n
#$s2: result

.data
kPrompt: .asciiz "Please input some integer value between 1 and 10 for k: "
Result: .asciiz "The Result is: "
nPrompt: .asciiz "Please input some integer value greater or equal to 0 for n: "
NewLine: .asciiz "\n"
Joke: .asciiz "I don't know whats funnier. You putting the wrong value, or me putting this in because you put the wrong value. Safe to say we've both lost friend.\n"
Terminating: .asciiz "The program is terminating\n"

.text
main:
#comparison variables
li $t0, 11
li $t1, 5
li $t2, 1

#prompts user for k
la $a0, kPrompt
li $v0, 4
syscall

#gets user input for k
li $v0, 5
syscall
move $s0, $v0

#checks if input value is less than 0, if less than it terminates program
slt $t2, $zero, $s0
beq $t2, $zero, End 

#checks if input is less than 5, ie, its in the range 1 <= k < 5. If less than goes to Case1
slt $t2, $s0, $t1
bne $t2, $zero, Case1

#checks if input is less than 11, ie, it is in the range 5 <= k <= 10. If less than goes to Case2
slt $t2, $s0, $t0
bne $t2, $zero, Case2

#if it does not satisfy any prior checks, jumps to end and terminates program as k > 10
j End


Case1:
	
	#Prompts the user for a value k
	la $a0, nPrompt
	li $v0, 4
	syscall
	
	#Gets a value of n, stores it in $s1, then $a0
	li $v0, 5
	syscall
	move $s1, $v0
	move $a0, $s1
	
	
	slt $t0, $a0, $zero #checks if n is less than zero
	beq $t0, $t2, End #if n<0 just terminate program to end infinite loop , as n<0 does not satisfy the condition
	
	#Jumps and links to the function to do the recursive stuff
	jal Function
	
	#Prints the string to notify that the value after is the result
	la $a0, Result
	li $v0, 4
	syscall
	
	#Prints the result
	li $v0, 1
	move $a0, $s2
	syscall
	
	#Outputs a new line
	la $a0, NewLine
	li $v0, 4
	syscall
	
	#Jumps to Case1, causing the infinite loop for getting a value of n to compute
	j Case1

Case2:
	
	#Outputs the joke
	la $a0, Joke
	li $v0, 4
	syscall

End:

	#Message to let you know program is exiting
	la $a0, Terminating
	li, $v0, 4
	syscall

	#Syscall to terminate/exit program
	li $v0, 10
	syscall

Function:

	#Prologue
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)


	#Base Case (when n == 1 or n == 0)
	li $v0, 20 #returns 20
	beq $a0, $t2, Done #checks if n == 1
	beq $a0, $zero, Done #checks if n == 0

	#Recursive
	addi $a0, $a0, -2 #decreases n by 2
	jal Function #Function(n-2)
	lw $t0, 4($sp) #stores n in $t0
	mul $v0, $t1, $v0 #5*Function(n-2)
	add $v0, $v0, $t0 #5*Function(n-2) + n
	#move $s2, $v0 #moves value into $s2 so it is not lose and can be printed

	#Epilogue
Done:
	lw $a0, 4($sp) #restores argument n
	lw $ra, 0($sp) #restores return address
	addi $sp, $sp, 8 #deallocates space in stack
	move $s2, $v0 #moves the value in $v0 to $s2 (most for when n is base case, it cannot otherwise store the value)
	jr $ra
