[org 0x0100]

jmp START

snake: dw 1980, 1982, 1984, 1986, 1988, 1990, 1992, 1994, 1996, 1998, 2000, 2002, 2004, 2006, 2008, 2010, 2012, 2014, 2016, 2018
spaceforsnakegrowth: times 220 dw 0
len: dw 20
score: dw 0
life: dw 3
direction: db 2    ; 1 for right, 2 for left, 3 for up, 4 for down
oldisr: dd 0
oldtimer: dd 0
tickcount: dw 0
timerflag: dw 0
food_loc: dw 0
get_time: dw 0
secs: dw 1;18
foodtick: dw 0xB7A9
counter_tickcount: dw 0
message: db 'Game Over :('
length_of_msg: dw 12
m2: db 'Score: '
len_of_m2: dw 7
m3: db 'Remaining Lives: '
len_of_m3: dw 17
m4: db 'Your Score: '
len_of_m4: dw 12
m5: db 'Time is up!!!'
len_of_m5: dw 13
m6: db 'You Loose!'
len_of_m6: dw 10
m7: db 'You Win!'
len_of_m7: dw 8
m8: db 'Total Lives: 3'
len_of_m8: dw 14
m9: db 'Bonus Fruit: '
len_of_m9: dw 13
m10: db 'Snake length: '
len_of_m10: dw 14
m11: db 'You Loose 1 Life!'
len_of_m11: dw 17
m12: db 'Time: '
len_of_m12: dw 6
m13: db ':'
len_of_m13: dw 1
endtime: dw 0
foodcount: dw 0
big_fruit_loc: dw 0
big_fruit_time: dw 0
dangerous_f_loc: dw 0
dan_f_time_appear: dw 0
dan_f_time: dw 0
bonus_food_count: dw 0
life_time: dw 0
life_loc: dw 0
flag_for_space: db 0
print_time_tick: dw 0
print_time_min: dw 0
print_time_sec: dw 0
stage: dw 1
stage_changed: dw 0
resetf: dw 0
buffer: times 2000 db 0
String1: db "         Made By:", 0
String2: db "       Muhammad Saqib Kamran ", 0
String3: db "PRESS ANY KEY TO PLAY!", 0
titleflag: dw 0
titleSnake:
		dw 0342, 0341, 0340, 0339, 0338, 0337, 0336, 0335, 0415, 0495
		dw 0575, 0655, 0656, 0657, 0658, 0659, 0660, 0661, 0662, 0742
		dw 0822, 0902, 0982, 0981, 0980, 0979, 0978, 0977, 0976, 0975
		dw 0985, 0905, 0825, 0745, 0665, 0585, 0505, 0425, 0345, 0426
		dw 0507, 0587, 0668, 0669, 0750, 0830, 0911, 0992, 0912, 0832
		dw 0752, 0672, 0592, 0512, 0432, 0352, 0995, 0915, 0835, 0755
		dw 0675, 0595, 0515, 0435, 0355, 0356, 0357, 0358, 0359, 0360
		dw 0361, 0362, 0442, 0522, 0602, 0682, 0762, 0842, 0922, 1002
		dw 0676, 0677, 0678, 0679, 0680, 0681, 0365, 0445, 0525, 0605
		dw 0685, 0765, 0845, 0925, 1005, 0372, 0451, 0530, 0609, 0608
		dw 0687, 0686, 0768, 0769, 0850, 0931, 1012, 0382, 0381, 0380
		dw 0379, 0378, 0377, 0376, 0375, 0455, 0535, 0615, 0695, 0775
		dw 0855, 0935, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022
		dw 0696, 0697, 0698, 0699, 0700, 0701, 0702
gen_rand_1_10:		;; Get Random Numbers between 1 - 10	(for dangerous fruits)
				push ax
				push cx
				push dx

				mov ax, [food_loc]
				xor dx, dx
				mov cx, 10
				div cx
				mov word[dan_f_time_appear],dx

				pop dx
				pop cx
				pop ax
				RET
BufferSetter:                                ;Sets Before Printing
			mov ax, 0xb800
			mov es, ax
			mov di, buffer
			mov si, 0
		nextAgain:
			mov bl, [di]
			cmp bl, 8
			jz mover
			cmp bl, 4
			jz mover
			cmp bl, 2
			jz mover
			cmp bl, 1
			jz mover
			jmp writer
		mover:
			mov bl, 219
		writer:
			mov byte [es:si], bl
			inc di
			add si, 2
			cmp si, 4000
			jnz nextAgain
			ret
delay3: pusha
				mov cx, 0x4eff
	l19:
				loop l19
				popa 
	ret
BufferPrintString:
		printAgain:
			mov al, [si]
			cmp al, 0
			jz returnB
			mov byte [buffer + di], al
			inc di
			inc si
			jmp printAgain
		returnB:
			ret
DisplayTitlePage: 
			pusha
			push 0x7C01
            call clrscr

            mov ax, 0xb800
			mov es, ax
					
			cld
			mov di, 0	
			mov ah, 07
			mov al, 0x20			
			mov cx, 2000
			rep stosw

			call BufferSetter
			mov si, 18
            call delay3
			mov si, 0
		PrintAgain2:
			mov bx, [titleSnake + si]
			mov byte [buffer + bx], 219
			push si
			call BufferSetter
			mov si, 1
            call delay3
			call delay3 
			pop si
			add si, 2
			cmp si, 274
			jl PrintAgain2
			mov si, String1
			mov di, 1626
			call BufferPrintString
			mov si, String2
			mov di, 1781
			call BufferPrintString
		KeyWait:
            call delay3
			call delay3
			mov ah, 1
			int 16h
			jnz continueNext
			mov si, String3
			mov di, 1388
			call BufferPrintString
			call BufferSetter
			mov si, 10
            call delay3
			call delay3
			mov ah, 1
			int 16h
			jz KeyWait

		continueNext:
		mov word[titleflag], 1
			popa
			ret
; subroutine to print a string
; takes the x position, y position, attribute, address of string and
; its length as parameters
printstr:
		 			push bp
					mov bp, sp
					push es
					push ax
					push cx
					push si
					push di

					mov ax, 0xB800
					mov es, ax
					mov al, 80
					mul byte[bp + 10]
					add ax, [bp + 12]
					shl ax, 1
					mov di, ax
					mov si, [bp + 6]
					mov cx, [bp + 4]
					mov ah, [bp + 8]

					cld
	nextchar1:
					lodsb
					stosw
					loop nextchar1

					pop di
					pop si
					pop cx
					pop ax
					pop es
					pop bp
					RET 10
game_over:		;If the game is over, will print the message
				push 0x7020
				call clrscr
				push 6666
				call sound2

				mov ax, 34
				push ax ; push x position
				mov ax, 10
				push ax ; push y position
				mov ax, 0xB4 ; Red on Blue attribute
				push ax ; push attribute
				mov ax, message
				push ax ; push address of message
				push word[length_of_msg]
				call printstr
				jmp notimeup
				
fortimeup:		;if the time is up, will play the sound
				push 6666
				call sound2
				
notimeup:		;if the time is not up, will play appropriate message
				mov ax, 34
				push ax
				mov ax, 11
				push ax
				mov ax, 0x4A
				push ax
				mov ax, m4
				push ax
				push word[len_of_m4]
				call printstr

				mov di, 0x004A
				push di
				mov di, 1852
				push di
				push word[score]
				call printnum
				mov al, 27
				jmp exitprogram
printnum:
			    push bp
				mov bp, sp
				push es
				push ax
				push bx
				push cx
				push dx
				push si
				push di

				mov bx, [bp + 8]
				mov ax, 0xB800
				mov es, ax
				mov ax, [bp + 4]
				mov si, 10
				mov cx, 0
	nextdigit:	    mov dx, 0
					div si
					add dl, 0x30
					push dx
					inc cx
					cmp ax, 0
					jnz nextdigit
					mov di, [bp + 6]
	nextpos:        pop dx
					mov dh, bl
					mov word[es:di], dx
					add di, 2
					loop nextpos

				pop di
				pop si
				pop dx
				pop cx
				pop bx
				pop ax
				pop es
				pop bp
				RET 6

sound2:			  ; for reset 
				push bp
				mov bp, sp
				push ax
				push bx
				push cx

				mov al, 182
				out 0x43, al
				mov ax, [bp + 4]   ; frequency
				out 0x42, al
				mov al, ah
				out 0x42, al
				in al, 0x61
				or al, 0x03
				out 0x61, al

				mov bx, 20
del1:
				mov cx, 65535
del2:
				dec cx
				jne del2
				dec bx
				jne del1

				in al, 0x61
				and al, 0xFC
				out 0x61, al

				pop cx
				pop bx
				pop ax
				pop bp
			    RET 2
sound:
				push bp
				mov bp, sp
				push ax

				mov al, 182
				out 0x43, al
				mov ax, [bp + 4]   ; frequency
				out 0x42, al
				mov al, ah
				out 0x42, al
				in al, 0x61
				or al, 0x03
				out 0x61, al
				call delay
				call delay
				call delay
				in al, 0x61

				and al, 0xFC
				out 0x61, al

				pop ax
				pop bp
			    RET 2
				
delay:
				push cx
				mov cx, 0xFFFF
	de:
				loop de
				pop cx
				RET
				
check_on_itself:		;if the snake has touched itself
				push bp
				mov bp, sp
				push ax
				push cx
				push si
				push di

				mov bx, 0
				mov di, [bp + 4]    ; old value
				mov cx, [len]
	check_itsef_l:
					mov si, [snake + bx]
					add bx, 2
					cmp si, di
					je cal_reset_itself
					loop check_itsef_l
					jmp return_from_reset
	cal_reset_itself:
					push 1140
					call sound2
					call reset
					mov word[resetf], 1
	return_from_reset:
				pop di
				pop si
				pop cx
				pop ax
				pop bp
				RET 2

reset:			;if the snake dies or goes to another stage
				push ax
				push cx
				push si
				push di
				push es

				dec word[life]
				cmp word[life], 0
				je game_over

				push 0x7C01
				call clrscr
				call print_boundary
				mov si, 0
				mov cx, word[len]
				mov ax, 0
			dozero:
					mov word[snake + si], ax
					add si, 2
					loop dozero
					mov cx, 20
					mov word[len], cx
					mov si, 0
					mov ax, 1980
			agains:
					mov word[snake + si], ax
					add si, 2
					add ax, 2
					loop agains
					mov byte[direction], 2
					mov word[secs], 1;18;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					mov word[tickcount], 0
					mov word[counter_tickcount], 0
					mov word[foodcount],0
					call printsnake
					call generate_food
					mov bx, [snake + 2]
				pop es
				pop di
				pop si
				pop cx
				pop ax
				RET
generate_random_no:		;;generates random number for fruit location
				push bp
				mov bp, sp
				push ax
				push bx
				push cx
				push dx
				push di

				mov ax, 0
	againgenerate:
					add ax, [foodtick]
					add ax, bp
					add ax, ax
					add ax, cx
					add ax, dx
					add ax, si
					add ax, di
					add ax, [es:si]
					add ax, [cs:foodtick]
					add ax, sp

					xor dx, dx
					mov cx, 4000
					div cx
					shr dx, 1
					shl dx, 1
					mov ax, dx
					mov di, ax
					mov bx, [es:di]
					cmp bh, 0x7C;0x70
					jne againgenerate
					mov word[food_loc], ax

				pop di
				pop dx
				pop cx
				pop bx
				pop ax
				pop bp
				RET
generate_food:			;generates the fruit at desired location
				push ax
				push bx
				push cx
				push dx
				push di
				push es
				push si

				push 0xB800
				pop es
				call generate_random_no
				mov di, [food_loc]
				cmp word[bonus_food_count],2
				je print_life
				cmp word[foodcount],5
				je print_big_fruit
				call gen_rand_1_10
				cmp word[dan_f_time_appear],0
				je print_dan_fruit
				jmp normal_food
				
print_life:												;prints the life fruit
				call generate_random_no
				mov si, [food_loc]
				mov word[food_loc],di
				mov word[life_loc],si
				mov ah,0xf1
				mov al,'L'
				mov word[es:si], ax
				mov word[bonus_food_count],0
				mov word[life_time],0
				jmp normal_food
				
print_dan_fruit:										;prints the dangerous fruit
				cmp word[dan_f_time],0
				jne normal_food
				call generate_random_no
				mov si, [food_loc]
				mov word[food_loc],di
				mov word[dangerous_f_loc],si
				mov ah,0xF4
				mov al,'X'
				mov word[es:si], ax
				mov word[dan_f_time], 0
				jmp normal_food

print_big_fruit:										;prints the big fruit
				call generate_random_no
				mov si, [food_loc]
				mov word[food_loc],di
				mov word[big_fruit_loc],si
				mov ah,0x24
				mov al,'$'
				mov word[es:si], ax
				mov word[foodcount],0
				
normal_food:											;prints normal fruit
				mov ax,[food_loc]
				xor dx,dx
				mov bx,16
				div bx
				inc dx
				mov al,dl	; for different fruit shapes						; 5
				mov ah, 0x8f
				mov word[es:di], ax
return_from_food:
				pop si
				pop es
				pop di
				pop dx
				pop cx
				pop bx
				pop ax
				RET
print_boundary:				;prints the stage boundary
				push bp
				mov bp, sp
				push es
				push ax
				push cx
				push si
				push di
				
				cmp word[stage],2			;if the stage is set to 2nd stage
				je stage2_boundary
				
				mov ax, 0xB800
				mov es, ax
				mov bx, 0
				mov ah, 0x44
				mov al, ' '

				mov cx, 24
				mov di, 0       ; left
				
;;;;;;;;;;;;;;;;for 1st stage;;;;;;;;;;;;;;;;;;;				
	l3:
					mov word[es:di], ax
					add di, 160
					loop l3

					mov cx, 24        ; right
					mov di, 158
	l4:
					mov word[es:di], ax
					add di, 160
					loop l4

					mov cx, 80        ;  up
					mov di, 0
	l5:				mov word[es:di], ax
					add di, 2
					add bx, 2
					loop l5

					mov cx, 80         ; down
					mov di, 3840
	l6:				mov word[es:di], ax
					add di, 2
					add bx, 2
					loop l6
					jmp print_info
					
;;;;;;;;;;;;;;;for 2nd stage;;;;;;;;;;;;;;;;;;;;;;
	stage2_boundary:			
					mov ax, 0xB800
					mov es, ax
					mov bx, 0
					mov ah, 0x21
					mov al, ':'

					mov cx, 50
					mov di, 1308       ;new up
	l3_1:
					mov word[es:di], ax
					add di, 2
					loop l3_1

					mov cx, 50        ; new down
					mov di, 2588
	l4_1:
					mov word[es:di], ax
					add di, 2
					loop l4_1

					mov cx, 80        ;  up
					mov di, 0
	l5_1:				mov word[es:di], ax
					add di, 2
					add bx, 2
					loop l5_1

					mov cx, 80         ; down
					mov di, 3840
	l6_1:			mov word[es:di], ax
					add di, 2
					add bx, 2
					loop l6_1
					
;;;;;;;;;;;;;;;;;;prints all the messages on the boundary;;;;;;;;;;;;;;;;;;;;;

	print_info:				
				mov ax, 5
				push ax ; push x position
				mov ax, 0
				push ax ; push y position
				mov ax, 0x4A ; Light Green on Red attribute
				push ax ; push attribute
				mov ax, m2
				push ax ; push address of message
				push word[len_of_m2]
				call printstr

				mov di, 0x004A
				push di
				mov di, 24
				push di
				push word[score]
				call printnum

				mov ax, 28
				push ax ; push x position
				mov ax, 0
				push ax ; push y position
				mov ax, 0x4A ; Light Green on Red attribute
				push ax ; push attribute
				mov ax, m3
				push ax ; push address of message
				push word[len_of_m3]
				call printstr

				mov di, 0x004A
				push di
				mov di, 90
				push di
				push word[life]
				call printnum

				mov di, 92
				push 0xb800
				pop es
				mov word[es:di], 0xC703

				mov ax, 60
				push ax ; push x position
				mov ax, 0
				push ax ; push y position
				mov ax, 0x4A ; Light Green on Red attribute
				push ax ; push attribute
				mov ax, m8
				push ax ; push address of message
				push word[len_of_m8]
				call printstr

				mov di, 148
				push 0xb800
				pop es
				mov word[es:di], 0x4A03

				mov ax, 5
				push ax ; push x position
				mov ax, 24
				push ax ; push y position
				mov ax, 0x4A ; Light Green on Red attribute
				push ax ; push attribute
				mov ax,m9
				push ax ; push address of message
				push word[len_of_m9]
				call printstr

				mov di, 0x004A
				push di
				mov di, 3876
				push di
				push word[foodcount]
				call printnum

				mov ax, 28
				push ax ; push x position
				mov ax, 24
				push ax ; push y position
				mov ax, 0x4A ; Light Green on Red attribute
				push ax ; push attribute
				mov ax,m10
				push ax ; push address of message
				push word[len_of_m10]
				call printstr

				mov di, 0x004A
				push di
				mov di, 3924
				push di
				push word[len]
				call printnum

				mov ax, 64
				push ax ; push x position
				mov ax, 24
				push ax ; push y position
				mov ax, 0x4A ; Light Green on Red attribute
				push ax ; push attribute
				mov ax,m12
				push ax ; push address of message
				push word[len_of_m12]
				call printstr

				mov di, 0x004A
				push di
				mov di, 3980
				push di
				push word[print_time_min]
				call printnum

				mov ax, 71
				push ax ; push x position
				mov ax, 24
				push ax ; push y position
				mov ax, 0x4A ; Light Green on Red attribute
				push ax ; push attribute
				mov ax,m13
				push ax ; push address of message
				push word[len_of_m13]
				call printstr

				mov di, 0x004A
				push di
				mov di, 3984
				push di
				push word[print_time_sec]
				call printnum

				pop di
				pop si
				pop cx
				pop ax
				pop es
				pop bp
				RET
printsnake:
				push bp
				mov bp,sp
				push es
				push ax
				push cx
				push si
				push di

				mov ax, 0xB800
				mov es, ax
				mov bx, 0
				mov ah, 0x5A
				mov al, '*'
				mov di, [snake]
				mov word[es:di], ax
				mov ah, 0x13
				mov al, '.'
				mov cx, [len]
				dec cx
				add bx, 2
				
;;;;;;;;;;;;;;;;for changing colours;;;;;;;;;;;;;;;;;;
	l2:
				cmp word[stage],2
				je change_color
				mov ah,0x13
				jmp c3
		change_color:
				mov ah,1					;0x13         ;1           ;0x13       ; mov ah,1  
		c3:		mov dx,cx
				shr dx,1
				jc odd_col
				
			
		pr:		mov di, [snake + bx]
				cmp di, 0
				je ll
				mov word[es:di], ax
				
	ll:
				add bx, 2
				loop l2
	odd_col:
				cmp word[stage],2
				je change_color_o
				mov ah,0x23
				jmp c4
	change_color_o:
				mov ah,	2				;0x23         ; 0x13      ;0x23      ; mov ah,2
		c4:		cmp cx,0
				jne pr
				
				pop di
				pop si
				pop cx
				pop ax
				pop es
				pop bp
				RET
				
;;;;;;;;;;;;;;;;;for the movement of snake;;;;;;;;;;;;;;;;;;
mov_body:
				push ax
				push dx
				push es
				push bx
		ca:		mov dx, [snake + si]
				mov word[snake + si], bx
				mov bx, dx
				add si, 2
				loop ca
				mov ah, 0x7C;0
				mov al, 1;' '
				push 0xB800
				pop es
				mov word[es:bx], ax
				call print_boundary
				call printsnake
				pop bx
				pop es
				pop dx
				pop ax
				RET
				
;;;;;;;;;;;;;;;;;;if 5 seconds are remaining for big fruit, it will start to blink;;;;;;;;;;;;;;;;
five_sec_letf:  
				push 0xB800
				pop es
				push ax
				push di
				mov di,[big_fruit_loc]
				mov ah,0xa4
				mov al,'$'
				mov word[es:di],ax
				pop di
				pop ax
				jmp come_back_af_food_disapper
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Timer starts ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mytimer:
				push ax
				push bx
				push cx
				push dx
				push si
				push di
				cmp word[titleflag], 0
				je timerend_inter
				cmp byte[flag_for_space], 0
				je No_Pause
				jmp timerend
No_Pause:
				mov dx, word[secs]
				cmp word[score], 80
				jge win_2
gohere:
				cmp word[dan_f_time], 180   ; 10 seconds
				je dangerous_food
goback:
				cmp word[life_time], 270   ; 15 seconds
				je new_life
goback1:		cmp word[big_fruit_time], 90
				je five_sec_letf
				cmp word[big_fruit_time], 180   ; 10 seconds
				je Big_Food
				; for generating food
come_back_af_food_disapper:
				inc word[foodtick]
				add word[foodtick], sp
				cmp word[len], 240
				je win_2
againcheck:		cmp word[endtime], 4320			;4320 for 4 minutes
				je passed4minutes
				cmp word[cs:counter_tickcount], 360
				je dec_speed_by_2_inter
				jmp continue
timerend_inter:
		jmp timerend
new_life:
				jmp remove_new_life
Big_Food:
				jmp remove_big_food
				
dangerous_food:
				jmp remove_dan_food
win_2:
				add word[score], 5
				push 0x7C01
				call clrscr
				mov ax, 34
				push ax ; push x position
				mov ax, 10
				push ax ; push y position
				mov ax, 0x70 ; Black on White attribute
				push ax ; push attribute
				mov ax, m7
				push ax ; push address of message
				push word[len_of_m7]
				call printstr
				jmp notimeup
	passed4minutes:
				mov word[print_time_min], 0
				mov word[print_time_sec], 0
				mov word[print_time_tick], 0
				push 0x7C01
				call clrscr
				mov ax, 34
				push ax ; push x position
				mov ax, 9
				push ax ; push y position
				mov ax, 0x84 ; Red on Black attribute
				push ax ; push attribute
				mov ax, m5
				push ax ; push address of message
				push word[len_of_m5]
				call printstr
				cmp word[len], 240
				jl loose
				jmp win
	dec_speed_by_2_inter:
					jmp dec_speed_by_2
	remove_new_life:
					push es
					push di
					push ax

					mov di, [life_loc]
					mov ax, 0x7C01;0x7020
					mov word[es:di], ax
					mov word[life_loc], 0
					mov word[life_time], 0
					pop ax
					pop di
					pop es
					jmp goback1
	remove_big_food:
					push es
					push di
					push ax

					mov di, [big_fruit_loc]
					mov ax, 0x7C01;0x7020
					mov word[es:di], ax
					mov word[big_fruit_loc], 0
					mov word[big_fruit_time], 0

					pop ax
					pop di
					pop es
					jmp come_back_af_food_disapper
	remove_dan_food:
					push es
					push di
					push ax
					mov di, [dangerous_f_loc]
					mov ax, 0x7C01;0x7020
					mov word[es:di], ax
					mov word[dangerous_f_loc], 0
					mov word[dan_f_time], 0
					pop ax
					pop di
					pop es
					jmp goback
	loose:
				mov ax, 34
				push ax ; push x position
				mov ax, 10
				push ax ; push y position
				mov ax, 0x70 ; Black on White attribute
				push ax ; push attribute
				mov ax, m11
				push ax ; push address of message
				push word[len_of_m11]
				call printstr
				mov word[endtime], 0
				mov cx, 40
	delayforlong:
				call delay
				call delay
				loop delayforlong
				call reset
				jmp gohere
	win:
				mov ax, 34
				push ax ; push x position
				mov ax, 10
				push ax ; push y position
				mov ax, 0x70 ; Black on White attribute
				push ax ; push attribute
				mov ax, m7
				push ax ; push address of message
				push word[len_of_m7]
				call printstr
				jmp fortimeup
	dec_speed_by_2:
					push si
					mov si, [secs]
					shr si, 1
					cmp si, 0
					je movone
					jmp noone
	movone:
					mov si, 1
	noone:
					mov word[secs], si
					mov word[counter_tickcount], 0
					pop si
	continue:
					cmp word[tickcount], dx
					je flag
					jmp skip
					
;;;;;;;;;;;;;;;;;;checks the movement direction;;;;;;;;;;;;;
	flag:			mov	word[tickcount], 0
					cmp byte[direction], 1
					je rightcase
					cmp byte[direction], 2
					je jump_leftcase_1
					cmp byte[direction], 3
					je jump_upcase_1
					cmp byte[direction], 4
					je downcases_1
		rightcase:
					mov bx, [snake]
					add word[snake], 2
					mov di, [snake]
					push bx
					call check_on_itself
					cmp word[resetf], 1
					je donot
					mov bx, [snake]
					sub bx, 2
			donot:
					mov word[resetf], 0
					cmp word[stage],2
					je l_stage_2_inter
					mov ax, di       ; boundary check
					add ax, 2
					xor dx, dx
					mov cx, 160
					div cx
					cmp dx, 0
					je cal_reset_inter
					cmp di,[dangerous_f_loc]
					je decrease_for_dan_inter2
					cmp di,[big_fruit_loc]
					je increse_for_bonus_inter2
					cmp di, [food_loc]
					je increse_size1
					cmp di, [life_loc]
					je inc_life_inter2
					jmp normal2
		jump_leftcase_1:
			jmp jump_leftcase
		jump_upcase_1:
			jmp jump_upcase
		downcases_1:
			jmp downcases
		increse_size1:
					add word[len], 4
					cmp word[len], 240
					jge win_2
					inc word[foodcount]
					jmp cin          ;;; intermediate jump
		cal_reset_inter:
						jmp cal_reset
		l_stage_2_inter:
						jmp l_stage_2
		jump_leftcase:
					jmp leftcase
		jump_upcase:
				    jmp upcase
		downcases:
					jmp downcase
		decrease_for_dan_inter2:
					jmp decrease_for_dan_inter
		increse_for_bonus_inter2:
					jmp increse_for_bonus_inter
		inc_life_inter2:
					jmp inc_life_inter
		
		cin:
					inc word[score]
					push 6818
					call sound
					call generate_food
					cmp word[score],11
					jge change_stage
					jmp normal2
			change_stage:
					cmp word[stage_changed],1
					je normal2
					mov word[stage_changed],1
					mov word[stage],2
					inc word[life]
					call delay
					call delay
					call delay
					push 1200
					call sound
					push 1300
					call sound
					push 1400
					call sound
					mov word[print_time_min], 0
					mov word[print_time_sec], 0
					mov word[print_time_tick], 0
					call reset	
		normal2:
					mov cx, [len]
					dec cx
					mov si, 2
					call mov_body
					jmp skip
		cal_reset:
					push 1140
					call sound2
				    call reset
					jmp after_reset
		
		increse_for_bonus_inter:
					jmp increse_for_bonus
		decrease_for_dan_inter:
					jmp decrese_for_dangerous
		inc_life_inter:
					jmp inc_life
		leftcase:
					mov bx, [snake]
					sub word[snake], 2
					mov di, [snake]
					push bx
					call check_on_itself
					cmp word[resetf], 1
					je donot1
					mov bx, [snake]
					add bx, 2
			donot1:
					mov word[resetf], 0
					cmp word[stage],2
					je l_stage_2
					mov ax, di      ; boundary check
					xor dx, dx
					mov cx, 160
					div cx
					cmp dx, 0
					je cal_reset
					jmp after_reset
		l_stage_2:
					cmp di,1406
					je cal_reset
					cmp di,2686
					je cal_reset
					cmp di,1308
					je cal_reset
					cmp di,2588
					je cal_reset
		after_reset:
					cmp di, [life_loc]
					je inc_life
					cmp di, [dangerous_f_loc]
					je decrease_for_dan_inter
					cmp di, [big_fruit_loc]
					je increse_for_bonus
					cmp di, [food_loc]
					je increse_size2
					cmp di, [life_loc]
					je inc_life
					jmp normal3
		increse_size2:
					inc word[foodcount]
				    add word[len], 4
					inc word[score]
					push 6818
					call sound
					call generate_food
					cmp word[score],11
					jge change_stage
		normal3:
					mov cx, [len]
					dec cx
					mov si, 2
					call mov_body
					jmp skip
	
		inc_life:
					push 2121
					call sound
					inc word[life]
					mov word[bonus_food_count],0
					mov word[life_loc],0
					mov word[life_time],0
					jmp normal3
		increse_for_bonus:
					inc word[bonus_food_count]
					add word[len], 8
					add word[score], 5
					push 1111
					call sound
					cmp word[score],11
					jge change_stage
					mov word[big_fruit_time], 0
					mov word[big_fruit_loc], 0
					jmp normal3
		decrese_for_dangerous:
					mov word[len], 20
					push 3333
					call sound
					call reset
					mov word[dan_f_time], 0
					mov word[dangerous_f_loc], 0
					jmp normal3
		upcase:
					mov bx, [snake]
					sub word[snake], 160
					mov di, [snake]
					push bx
					call check_on_itself
					cmp word[resetf], 1
					je donot2
					mov bx, [snake]
					add bx, 160
			donot2:
					mov word[resetf], 0
					cmp word[stage],2
					je u_stage_2
					cmp di, 160        ; boundary check
					jbe cal_reset
					jmp c2
		u_stage_2:
					cmp di, 160        ; upper line
					jbe cal_reset
	from_down:		mov cx,50
					mov ax,1308
		u_stage_u:						; intermediate line up
					cmp di,ax
					je cal_reset
					add ax,2
					loop u_stage_u
					mov cx,50
					mov ax,2588
		u_stage_d:                      ; intermediate line down
					cmp di,ax
					je cal_reset
					add ax,2
					loop u_stage_d
					
			c2:		cmp di, [life_loc]
					je inc_life
					cmp di, [dangerous_f_loc]
					je decrese_for_dangerous
					cmp di, [big_fruit_loc]
					je increse_for_bonus
					cmp di, [food_loc]
					je increse_size
					jmp normal1
	increse_size:
					inc word[foodcount]
				   add word[len], 4
				   inc word[score]
				   push 6818
					call sound
				   call generate_food
				   cmp word[score],11
					jge change_stage
	normal1:
					mov cx, [len]
					dec cx
					mov si, 2
					call mov_body
					jmp skip
	downcase:
					mov bx, [snake]
					add word[snake], 160
					mov di, [snake]
					push bx
					call check_on_itself
					cmp word[resetf], 1
					je donot3
					mov bx, [snake]
					sub bx, 160
			donot3:
					mov word[resetf], 0
					cmp word[stage],2
					je d_stage_2
					cmp di, 3840                ; boundary check
					jge cal_reset
					jmp c1
		d_stage_2:
					cmp di, 3840                ; boundary line down
					jge cal_reset
					jmp from_down
					
			c1:		cmp di, [life_loc]
					je inc_life
					cmp di, [dangerous_f_loc]
					je decrese_for_dangerous
					cmp di, [big_fruit_loc]
					je increse_for_bonus
					cmp di, [food_loc]
					je increse_size3
					jmp normal4
	increse_size3:
					inc word[foodcount]
				    add word[len], 4
					inc word[score]
					push 6818
					call sound
					call generate_food
					cmp word[score],11
					jge change_stage
	normal4:
					mov cx, [len]
					dec cx
					mov si, 2
					call mov_body
	skip:
					inc word[tickcount]
					inc word[counter_tickcount]
					cmp word[life_loc],0
					je eoi
					inc word[life_time]
eoi:				cmp word[dangerous_f_loc], 0
					je  EOI
					inc word[dan_f_time]
EOI:				cmp word[big_fruit_loc], 0
					je EOI1
					inc word[big_fruit_time]
EOI1:				inc word[endtime]
					inc word[print_time_tick]
					cmp word[print_time_tick], 18
					jne timerend
					add word[print_time_sec], 1
					mov word[print_time_tick], 0
					cmp word[print_time_sec], 60
					jne timerend
					add word[print_time_min], 1
					mov word[print_time_sec], 0
timerend:			
					mov al,0x20
					out 0x20,al

					pop di
					pop si
					pop dx
					pop cx
					pop bx
					pop ax
					IRET
					
mykbisr:
			push ax
			push bx
			push cx
			push si
			push di
			push es

			mov ax, 0xB800
			mov es, ax
			in al, 0x60
			cmp al, 0x39
			je Pause_Game
			cmp al, 0x48
			je mov_up
			cmp al, 0x4D
			je mov_right
			cmp al, 0x4B
			je mov_l
			cmp al, 0x50
			je mov_d
			jmp nomatch
	Pause_Game:
		cmp byte[flag_for_space],0
		je Space_Flag_Is_Zero
		jmp Space_Flag_Is_One
	Space_Flag_Is_Zero:
		mov byte[flag_for_space], 1
		jmp nomatch
	Space_Flag_Is_One:
		mov byte[flag_for_space], 0
		jmp nomatch
	mov_l:      jmp mov_left
	mov_d:      jmp mov_down
	mov_up:
					cmp byte[direction], 4
					je up_release
					mov byte[direction], 3
	up_release:
					jmp nomatch
	mov_right:
					cmp byte[direction], 2
					je right_release
					mov byte[direction], 1
	right_release:
					jmp nomatch
	mov_left:
					cmp byte[direction], 1
					je nomatch
					mov byte[direction], 2
	left_release:
					jmp nomatch
	mov_down:
					cmp byte[direction], 3
					je nomatch
					mov byte[direction], 4
	down_release:
					jmp nomatch
	nomatch:
			pop es
			pop di
			pop si
			pop cx
			pop bx
			pop ax
			jmp far[cs:oldisr]
clrscr:	             ; for clearing screen
			push bp
			mov bp, sp
			push es
			push ax
			push di
			push si

			mov ax, 0xB800
			mov es, ax
			mov di, 0
			mov ax, [bp + 4]
	nextcha:
				mov word[es:di], ax
				add di, 2
				cmp di, 4000
				jne nextcha

			pop di
			pop ax
			pop es
			pop es
			pop bp
			ret 2
START:
			call DisplayTitlePage
			push 0x7C01
			call clrscr
			call print_boundary
			call printsnake
			call generate_food

			; ;for timer
			xor ax, ax
			mov es, ax
			mov ax, [es: 8 * 4]
			mov [oldtimer], ax
			mov ax, [es: 8* 4 + 2]
			mov [oldtimer + 2], ax

			xor ax, ax
			mov es, ax
			cli
			mov word[es: 8 * 4], mytimer
			mov [es: 8 *4 + 2], cs
			sti
			; ;for kbisr
			xor ax, ax
			mov es, ax
			mov ax, [es: 9 * 4]
			mov [oldisr], ax
			mov ax, [es: 9 * 4 + 2]
			mov [oldisr + 2], ax
			cli
			mov word[es: 9 * 4], mykbisr
			mov [es: 9 * 4 + 2], cs
			sti
	l1:
			mov ah, 0
			int 0x16
			cmp al, 27
			jne l1
			call game_over
			mov ax, [oldisr]
			mov bx, [oldisr + 2]
			cli
			mov word[es: 9 * 4], ax
			mov [es: 9 * 4 + 2], bx
			sti
exitprogram:
			mov ax, 0x4C00
			int 0x21
