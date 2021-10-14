data Segment

board  db 0,0,0,2,6,0,7,0,1
       db 6,8,0,0,7,0,0,9,0
       db 1,9,0,0,0,4,5,0,0
       db 8,2,0,1,0,0,0,4,0
       db 0,0,4,6,0,2,9,0,0
       db 0,5,0,0,0,3,0,2,8
       db 0,0,9,3,0,0,0,7,4
       db 0,4,0,0,5,0,0,3,6
       db 7,0,3,0,1,8,0,0,0,'$'

board2 db 0,0,0,0,0,0,0,0,0,10
       db 0,0,0,0,0,0,0,0,0,10
       db 0,0,0,0,0,0,0,0,0,10
       db 0,0,0,0,0,0,0,0,0,10
       db 0,0,0,0,0,0,0,0,0,10
       db 0,0,0,0,0,0,0,0,0,10
       db 0,0,0,0,0,0,0,0,0,10
       db 0,0,0,0,0,0,0,0,0,10
       db 0,0,0,0,0,0,0,0,0,'$'
data Ends

code Segment
Assume CS:code,DS:data
start:
mov ax,data
mov ds,ax
lea si,board
l1:
mov al,[si]
cmp al,'$'            ;stop when end of array
jz EN
cmp al,0              ;find blank space
jz l6
inc si
jmp l1
l6:
mov cx,09
l2:
inc al

call check            ;check for validity of number
jc l3
jnc l4
l3:
mov [si],al            ;move to next number
push ax
dec cx
push cx
mov bx,si
push bx
inc si
jmp l1
l4:            ;check for next number if not possible then
                ;bactrack
cmp cx,1
jz l5
loop l2
l5:
mov ah,0
mov [si],ah
lh:
pop bx
lea si,board
add si,bx
pop cx
pop ax              ;pop out of the stack
cmp cx,00
jz lx
jnz l2
lx:
mov ah,0
mov [si],ah
jmp lh             ;jump to loop 'h'

EN:                ;printing the SUDOKU board
mov cx,81
lea si,board
ll:
mov al,[si]
add al,48
mov [si],al
inc si
loop ll
lea di,board2
lea si,board
l22:
mov cx,09
op:
mov al,[si]
mov [di],al
inc si
inc di
loop op
mov al,[di]
inc di
cmp al,'$'
jnz l22
lea si,board2
lea di,board2
mov ah,09
lea dx,board2
int 21h
hlt


check proc           ;call to check function
push ax
mov bx,si
push bx
push cx
xor bx,bx
mov bl,al
xor ax,ax
mov ax,si
mov bh,09
div bh
mov bh,ah
lea si,board
mov cx,09
mov ah,00
mul cx
add si,ax
mov ah,bh
xor cx,cx
mov cx,09
l8:
mov bh,[si]
cmp bh,bl
jz l7
inc si
loop l8
mov al,ah
mov ah,00
lea si,board
add si,ax
mov cx,09
l10:
mov bh,[si]
cmp bh,bl
jz l7
add si,09
loop l10
xor ax,ax
mov al,bl
pop cx
pop bx
push bx
push cx
xor cx,cx
mov bh,al
mov al,bl
mov bl,27
push ax
div bl
mov ah,00
mul bl
pop cx
push ax
mov ax,cx
mov bl,09
div bl
mov al,ah
mov ah,00
mov bl,03
div bl
mov ah,00
mul bl
pop cx
add ax,cx
lea si,board
add si,ax
mov bl,[si]
cmp bh,bl
jz l7
inc si
mov bl,[si]
cmp bh,bl
jz l7
inc si
mov bl,[si]
cmp bh,bl
jz l7

add si,09
mov bl,[si]
cmp bh,bl
jz l7
dec si
mov bl,[si]
cmp bh,bl
jz l7
dec si
mov bl,[si]
cmp bh,bl
jz l7

add si,09
mov bl,[si]
cmp bh,bl
jz l7
inc si
mov bl,[si]
cmp bh,bl
jz l7
inc si
mov bl,[si]
cmp bh,bl
jz l7


pop cx
pop bx
lea si,board
add si,bx
pop ax
stc
jmp l11
l7:
pop cx
pop bx
lea si,board
add si,bx
pop ax
clc
l11:
ret
check Endp
HLT
code Ends
End start
