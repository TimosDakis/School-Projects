#Name: Timothy Dakis
#Last Modified Date: 12/02/2019
#Program name: DakisT_h1.s
#
#The program takes a number in the range [100,250] then another number greater than -30. It then computes the sum of 4 times the first number and 7 times the (second number-9). This happens indefinitely, until the value 999 is input
#Java Code:
#import java.util.Scanner;
#class Main {
#  public static void main(String[] args) {
#    int num1, num2;
#
#    Scanner input = new Scanner(System.in);
#while (num1 != 999 || num2 != 999){
#    do{
#      System.out.println("Input a number in the range [100,250]");
#      num1 = input.nextInt();
#    } while(num1 < 100 || num1 > 250);
#
#  	 do{
#     System.out.println("Input a number greater than -30");
#     num2 = input.nextInt();
#   } while(num2 <= -30);
#   
#   input.close();
#   int ans = 4*num1+7*(num2-9);
#  }
# }
#}
#
#Registers:
#num1 = $s0, num2 = $s1, ans = $s2
.data
	askNum1: .asciiz "Enter a number in the range [100,250]\n"
	askNum2: .asciiz "Enter a number greater than -30\n"
	Result: .asciiz "The result is "
	NewLine: .asciiz "\n"
.text
.globl main
main:
#registers to do comparisons
li $t0, 100
li $t1, 250
li $t2, -29

#sentinel value
li $s3, 999

while1:
	li $v0, 4
	la $a0, askNum1
	syscall
	
	li $v0, 5
	syscall
	
	#moves value to num1 ($s0)
	addi $s0, $v0, 0
	
	beq $s0, $s3, exit
	
	#makes sure num1 is greater than 100
	slt $t3, $s0, $t0
	bne $t3, $zero, while1
	
	#makes sure num2 is less than 250
	slt $t3, $t1, $s0
	bne $t3, $zero, while1
	
while2:
	li $v0, 4
	la $a0, askNum2
	syscall
	
	li $v0, 5
	syscall
	
	#moves value to num2 ($s1)
	addi $s1, $v0, 0
	
	beq $s1, $s3, exit
	
	#makes sure num1 is greater than -30
	slt $t3, $s1, $t2
	bne $t3, $zero, while2
	
	#setting $t3 to some constant 7 for multiplication
	li $t3, 7

	#4*num1
	sll $t4, $s0, 2

	#num2-9
	addi $t5, $s1, -9

	#7*(num2-9)
	mult $t5, $t3
	mflo $t6

	add $s2, $t4, $t6
	
	li $v0, 4
	la $a0, Result
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	#creates a new line between loops finding answer
	li $v0, 4
	la $a0, NewLine
	syscall
	
	j while1
	
exit:
	li $v0, 10
	syscall


