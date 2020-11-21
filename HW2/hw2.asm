.data 
#input array
my_arr: .space 1024 #allocate 256 word size for array
#int result_arr[MAX_SIZE];
result_arr: .space 1024 #allocate 256 word size for result array
#int result_size=0;
result_size: .word 0 # size variable for result_arr

str1: .asciiz "Possible!\n"
str2: .asciiz "Not possible!!\n"
str3: .asciiz "Result Array:"
str4: .asciiz " "
str5: .asciiz "Provide size of array:"
str6: .asciiz "Provide target number:"
str7: .asciiz "Provide your array values:\n"

.text
.globl main
main:	
	li $v0,4 #set print_string
	la $a0,str5
	syscall
	
	#cin >> arraySize;
	li $v0,5 #assign read_int for size of array
	syscall
	add $s0,$zero,$v0
	
	li $v0,4 #set print_string
	la $a0,str6
	syscall
	
	#cin >> num;
	li $v0,5 #assign read_int for target number
	syscall
	add $s1,$zero,$v0 #store target number to in s1 register
	
	li $v0,4 #set print_string
	la $a0,str7
	syscall
	
	li $t0,0 #assign t0=0 for iterating array.
	li $t1,0 #control size statement
read_array: #reads the user input
	li $v0,5 #assign read_int for target number
	syscall
	sw $v0,my_arr($t0) #store target number to in s1 register
	addi $t0,$t0,4
	addi $t1,$t1,1
	beq $t1,$s0,leave_read
	j read_array
	
leave_read:
	#SET THE ARGUMENTS
	add $a0,$zero,$s1 #store num value for argument
	la $a1,my_arr #store array for argument
	add $a2,$zero,$s0 #store size of array

	jal CheckSumPossibility
	
	beq $v0,1,print_success
	j print_fail

		
print_success:
	li $v0,4 #print string
	la $a0,str1
	syscall #print possible

	la $a0,str3
	syscall #print Result Array:
	
	addi $t0,$zero,0 #set t0=0 for iterating loop.
	lw $t1,result_size #size of result_arr	
	addi $t1,$t1,-1 #size=size-1
	la $t3,result_arr #load &result_arr[0]
	li $v0,1 #set print int
	
loop:
	li $v0,4 #set print string
	la $a0,str4 #print space
	syscall
	
	li $v0,1 #set v0 to print int
	
	sll $t2,$t1,2 # size=size*4
	add $t4,$t3,$t2 # iterate array
	lw $a0,0($t4) # set print value
	syscall # print value
	addi $t1,$t1,-1 # size=size-1
	beq $t1,-1,leave_loop #if size==-1 exit loop.
	j loop

#leave loop label.
leave_loop:
	li $v0, 10 # System call code for exit
	syscall 

	
#fail label.	
print_fail:
	li $v0,4 #set print_string
	la $a0,str2 # print Not possible!!
	syscall
	
	li $v0, 10 # System call code for exit
	syscall 
	


#CheckSumPossibility procedure.
.text
.globl CheckSumPossibility
CheckSumPossibility:
	addi $sp, $sp, -12	#adjust stack for 3 given argument.
	sw $ra, 8($sp) #store the $ra
	sw $a0, 4($sp) #store the num
	sw $a2 ,0($sp) #store the size
	
	#if(num == 0) return 1;
	beq $a0,0,return_success
	
	#if(num < 0) return 0;
	slti $t2,$a0,0
	beq $t2,1,return_fail
	
	#if(size == -1) return 0;
	beq $a2,-1,return_fail
	
	#size--
	addi $a2,$a2,-1
	
	## RECURS?VE CALLS ##
	
	sll $t3,$a2,2 #size*4 for reaching last element
	add $t4,$a1,$t3 #array[size] 
	lw $t5,0($t4) # t5=aray[size]
	#num=num-array[size]
	sub $a0,$a0,$t5
	
	#if(CheckSumPossibility(num-arr[size],arr,size) != 1)
	jal CheckSumPossibility #first recursive call
	#else{
	#return 1;
	beq $v0,1,return_success_add

	sll $t3,$a2,2 #size*4 for reaching last element
	add $t4,$a1,$t3 #array[size] 
	lw $t5,0($t4) # t4=aray[size]
	#for obtaining old num value.
	add $a0,$a0,$t5
	
	#CheckSumPossibility(num,arr,size);
	jal CheckSumPossibility
	
	#return 1;
	beq $v0,1,return_success
	
	j return_fail
	
#retun_fail label
return_fail:
	addi $v0,$zero,0
	lw $ra, 8($sp) #store the $ra
	lw $a0,4($sp) #store the num
	lw $a2 ,0($sp) #store the size
	addi $sp, $sp, 12	#adjust stack for 3 given argument.
	jr $ra


#retun_success label
return_success:
	addi $v0,$zero,1
	lw $ra, 8($sp) #store the $ra
	lw $a0, 4($sp) #store the num
	lw $a2 ,0($sp) #store the size
	addi $sp, $sp, 12	#adjust stack for 3 given argument.
	jr $ra

#retun_success label
#this label adds last elemtent to result_list and does same thing as result_success.
return_success_add:
	
	#t0=result_size
	lw $t0,result_size
	sll $t0,$t0,2 # t0=t0*4
	
	#iterate the result_arr and find 
	#proper position for adding new value.
	la $t1,result_arr
	add $t6,$t1,$t0 # t6=mem[$t1+t0] ==> t6=mem[t1+size*4]
	
	#store the curren arr[size] value for adding result_arr.
	sll $t3,$a2,2 #size*4 for reaching last element
	add $t4,$a1,$t3 #array[size] 
	lw $t5,0($t4) # t4=array[size]
	
	#result_arr[result_size]=arr[size];
	#put array[size] to result array.
	sw $t5,0($t6)
	
	#result_size++;
	#increse result_size
	lw $t0,result_size
	addi $t0,$t0,1
	sw $t0,result_size
	
	# Restore stack pointer.
	addi $v0,$zero,1
	lw $ra, 8($sp) #store the $ra
	lw $a0, 4($sp) #store the num
	lw $a2 ,0($sp) #store the size
	addi $sp, $sp, 12	#adjust stack for 3 given argument.
	
	#return back.
	jr $ra

	

	
