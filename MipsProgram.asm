.text
	.globl main

main:

la $a1, array  #load address of our array a1
li $a2, 9 #load the size of the array into a2

jal radixSort #call procedure radixSort

la $a1, array  #load address of our array a1
li $a2, 9 #load the size of the array into a2

jal printData #Print sorted array

li $v0, 10 #end of the program
syscall

#############function to get max number in integer array####################
getMax:

	move $t7,$a1
	lw $t1, ($t7) # load i th value of array into t1
	addi $t7, $t7, 4 # increment to the next index
	li $t6, 1 #initialize hhe counter to 1

maxLoop1:
	beq $t6, $a2, getmaxend  #branch to while if counter < size of array
	lw $t0, ($t7)#load i th value of array into t0
	ble $t0, $t1, lessthan  #if array element is <= max goto lessthan
	move $v1, $t0 #put max value into v1

lessthan:
	addi $t6, $t6, 1 #increment Counter of loop
	addi $t7, $t7, 4 # increment to the next index
	j maxLoop1

getmaxend:
	jr $ra #return


#############function to count sort####################  

CountSort :

la $t0, count   # load address of count array into $t0
la $t8, output # load address of output array into $t0
addi $s0,$zero,4 
move $s7,$a1 #$s7 = $a1 
li $t6, 0  #i=0
li $t1, 0
li $s5, 10

loop1:
	beq $t6, $a2, l2branch # if t6 == n we are moving to next loop
	lw $t4, ($s7) # load current array element into t2
	div $t4,$t4, $a3   # Divide input by exp(a3)-----arr[i] / exp
	div $t4, $s5 #divide t2 by 10, arr[i] / exp) % 10
	mfhi $t4      # Save remainder in $t2
	mult $t4, $s0
	mflo $t4
	add $t4, $t0, $t4 #get the pointer location
	lw $s6, ($t4) # load current array element into s6
	addi $s6, $s6, 1 #count[(arr[i] / exp) % 10]++
	sw $s6, ($t4) #store t6 into current array element
	addi $t6, $t6, 1 # increment the counter
	addi $s7, $s7, 4 #increment the index by 1
	j loop1

l2branch:
	li $t6, 1 # t6 is our counter (i)=1
	move $s7,$t0 #$s7 = t0

loop2:
	beq $t6, $s5, l3branch  # if t6 == 10 we are done
	addi $s7, $s7, 4  #increment the index by 1 
	lw $s6, ($s7) # load current array element into s6
	sub $s7, $s7, 4 # decrement current index by 1 
	lw $t4, ($s7) # load current array element into t2
	addi $s7, $s7, 4 #increment the index by 1 
	lw $s6, ($s7) # load current array element into t2
	add $s6, $s6, $t4 #count[i] + count[i - 1]
	sw $s6, ($s7) #store t6 into current array element(count[i])
	addi $t6, $t6, 1 #increment counter
	j loop2# jump back to the top

l3branch:
	li $s1, 1
	move $s7,$a1 #$s7 = a1
	sub $t6, $a2, $s1 #i = n - 1
	sub $s4, $a2, $s1
	mul $s4, $s4, 4
	add $s7, $s7, $s4 #increment the index 

loop3:
	blt $t6, $t1, l4branch 
	lw $t4, ($s7) # load current array element 
	div $t4,$t4, $a3  # Divide input by exp(a3),arr[i] / exp
	div $t4, $s5 #divide t2 by 10, arr[i] / exp) % 10
	mfhi $t4 # Save remainder in $t2,arr[i] / exp) % 10
	mult $t4, $s0
	mflo $t4   
	add $t4, $t4, $t0 #get the pointer location
	lw $s6, ($t4) #loading the value# load current array element into t6
	sub $s6, $s6, 1 #(array[i] / exp) % 10 - 1
	mult $s6, $s0 
	mflo $s6 	#count(array[i] / exp) % 10] - 1
	add $s6, $s6, $t8
	lw $t6, ($s7) 
	sw $t6, ($s6)
	lw $s6, ($t4)
	sub $s6, $s6, 1 
	sw $s6, ($t4)
	sub  $s7, $s7, 4
	sub $t6, $t6, 1 # decrement the counter
	j loop3			#jump back to the top

l4branch:
	li $t6, 0    # initial size counter back to zero
	move $t0, $t8
	la $s7, array #load address of our array s7

loop4:
	bge $t6, $a2, endc # if t8 == n we are moving to next loop
	lw $t4, ($t0) # load current array element of output into t2
	sw $t4, ($s7) #array[i] = output[i]
	addi $t0, $t0, 4 #increment the output array index by 1 
	addi $s7, $s7, 4 #increment the array index by 1 
	addi $t6, $t6, 1  #increment the counter
	j loop4	# jump back to the top
endc:
	jr $ra 

############funtion to radix sort in an array#########################
radixSort:
    move $s0, $a1
    li $s1, 4
	li $t6,10
    sub $sp, $sp, $s1
    sw $ra, ($sp)

    jal getMax
    move $t3,$v1 #m=t3
    move $a0,$v1
    

    li $t2, 0    
    li  $t4, 1  
    
loopr:
    div $t5,$t3,$t4      #exp
    ble $t5,$t2,end1
    move $a3,$t4
    jal CountSort
    mult $t4, $t6
	mflo $t4
    j loopr
   
end1:
    lw $ra, ($sp)
    addi $sp, $sp, 4
    jr $ra

#############function to print elements in an array####################

printData:
  
	li $a1, 0               # initilize array index value back to 0
    li $t2, 0                # initial size counter back to zero
    la $a1, array        # load address of array back into $a2

sprint:
    lw $t6,($a1)            #load word into temp $t6
    move $a0, $t6           #store it to a safer place
    li $v0, 1               #print it out
    syscall

    la $a0,space            # Display " "
    li $v0,4            
    syscall

    add $a1, $a1, 4         #increment the array to the next index
    add $t2, $t2, 1         #increment the counter by 1

    blt $t2, $a2,sprint     #branch to while if counter < size of array

    li $t2, 0                # initial size counter back to zero
    la $a1, array           # load address of array back into $a0
    add $a1, $a1, 4         #increment the array to the next index
    add $t2, $t2, 1         #increment the counter by 1
    jr $ra 

####################################################################################
#data memory
.data
#array
array: .word  7 ,9 ,4 ,3 ,8 ,1 ,6 ,2 ,5 # declare and initialize an array of words
count: .word 0:10 
output: .word 0:9 
nextline:.asciiz "\n"
space: .asciiz " "
