Name "Tic Tac Toe" ; Dat ten chuong trinh "Tic Tac Toe"
Org 100h           ; Thiet lap vi tri bat dau trong bo nho
.DATA              ; Khoi du lieu
	MANG DB '1','2','3'  	; Khai bao mang 2D grid
         DB '4','5','6'
         DB '7','8','9'
    
    line1 db '  _______ _        _______             _______        $'
    line2 db ' |__   __|_|      |__   __|           |__   __|       $'
    line3 db '    | |   _  ___     | | __ _  ___       | | ___   ___ $'
    line4 db '    | |  | |/ __|    | |/ _` |/ __|      | |/ _ \ / _ \ $'
    line5 db '    | |  | | |__     | | |_| | |__       | | (_) |  __/ $'
    line6 db '    |_|  |_|\___|    |_|\__,_|\___|      |_|\___/ \___| $'
    menu_instr  db 'Enter a number to navigate (1 - 3):', 13,10,13,10, '$'
    menu_opt1   db '1. Start game', 13,10, '$'
    menu_opt2   db '2. Help', 13,10, '$'
    menu_opt3   db '3. Exit', 13,10, '$'

    help_text   db 'Game help: Player 1 is X, Player 2 is O.', 13,10, 'Enter positions 1-9 to play.', 13,10, '$'
    
    msg_play_again DB 'Play again? (Y/N): $'
    SCORE_X db 0
    SCORE_O db 0
    msg_score db 'Score X - O: $'

	PLAYER DB ?  						; Khai bao bien cho nguoi choi
	INPUT DB 'Enter Position Number, PLAYER Turn is: $' 	; Thong diep nhap du lieu
	DRAW DB 'DRAW! $' 					; Thong diep hoa
	WIN DB 'PLAYER WIN: $' 					; Thong diep chien thang

	LINE DB '+---+---+---+$'  
	
	


.CODE    ; Khoi ma lenh
main:    
    call MENU
game_loop:  
    
    ; Reset bang choi
    mov MANG[0], '1'
    mov MANG[1], '2'
    mov MANG[2], '3'
    mov MANG[3], '4'
    mov MANG[4], '5'
    mov MANG[5], '6'
    mov MANG[6], '7'
    mov MANG[7], '8'
    mov MANG[8], '9'

    mov cx, 9    ; Reset s? lu?t choi

    ; Bat dau vong choi

x:
    call XOA_MAN_HINH  	; Xoa man hinh de cho giao dien dep hon
	call PRINT_MANG    	; In bang luoi
	mov bx, cx        	; Di chuyen cx vao bx
	and bx, 1         	; Kiem tra so chan hoac le
	cmp bx, 0        	; So sanh ket qua AND
	je isEven         	; Nhay den isEven neu ket qua 0 (chan)
	mov PLAYER, 'x'    	; Neu la so le thi la luot cua nguoi choi x
	jmp endif		; Chuyen den buoc tiep theo
isEven:
	mov PLAYER, 'o'    	; Neu la so chan thi la luot cua nguoi choi o
endif:
  NOT_VALID:
	call IN_DONG_MOI 	; In dongf mowis
	call IN_NHAP	 	; In thong diep nhap lieu
	call NHAP   		; Doc du lieu dau vao, al chua vi tri tren bang luoi

	push cx           	; Day cx vao ngan xep
	mov cx, 9         	; Thiet lap so luong vong lap
	mov bx, 0         	; Chi so de truy cap bang luoi
y:
	cmp MANG[bx], al  	; Kiem tra vi tri tren bang luoi voi du lieu dau vao
	je UPDATE         	; Neu trung khop cap nhat vi tri cua nguoi choi(x hoac o)
	jmp CONTINUE     	; Tiep tuc neu khong trung
UPDATE:
	mov dl, PLAYER     	; Di chuyen nguoi choi vao dl
	mov MANG[bx], dl  	; Cap nhat bang luoi voi nguoi choi
CONTINUE:
	inc bx            	; Tang chi so
	loop y            	; Lap den khi hoan tat
	pop cx            	; Lay gia tri cx ra khoi ngan xep
	call CHECKWIN     	; Kiem tra ket qua choi
	loop x             ; Lap lai chuong trinh
	call PRINT_DRAW    ; Neu khong ai thang in hoa
programEnd:
    mov ah, 4Ch
    mov al, 0    ; mã thoát, có th? là 0 ho?c mã khác tùy ý
    int 21h
ret
  
; Cac ham

MENU PROC
    call XOA_MAN_HINH

    ; Hien thi dong chu to (6 dong)
    mov ah, 09h

    mov dh, 1         ; Dat DH = 1, nghia la hang thu 1  (tinh tu 0)
    mov dl, 10        ; Dat DL = 10, nghia la cot thu 10  (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (1, 10)
    mov ah, 9
    lea dx, line1
    int 21h
    
    mov dh, 2         ; Dat DH = 2, nghia la hang thu 2 (tinh tu 0)
    mov dl, 10        ; Dat DL = 10, nghia la cot thu 10 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (2, 10)

    mov ah, 9
    lea dx, line2
    int 21h

    mov dh, 3         ; Dat DH = 3, nghia la hang thu 3 (tinh tu 0)
    mov dl, 10        ; Dat DL = 10, nghia la cot thu 10 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (3, 10)

    mov ah, 9
    lea dx, line3
    int 21h

    mov dh, 4         ; Dat DH = 4 (tinh tu 0)
    mov dl, 10        ; Dat DL = 10 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (4, 10)

    mov ah, 9
    lea dx, line4
    int 21h

    mov dh, 5         ; Dat DH = 5 (tinh tu 0)
    mov dl, 10        ; Dat DL = 10 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (5, 10)

    mov ah, 9
    lea dx, line5
    int 21h

    mov dh, 6         ; Dat DH = 6 (tinh tu 0)
    mov dl, 10        ; Dat DL = 10 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (6, 10)

    
    mov ah, 9
    lea dx, line6
    int 21h

    ; Hien thi huong dan 
    mov dh, 8         ; Dat DH = 8 (tinh tu 0)
    mov dl, 20        ; Dat DL = 20 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (8, 20)

    
    mov ah, 9
    lea dx, menu_instr
    int 21h

    ; In cac option
    
    mov dh, 10        ; Dat DH = 10 (tinh tu 0)
    mov dl, 28        ; Dat DL = 28 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (10, 28)

    
    mov ah, 9
    lea dx, menu_opt1
    int 21h

    mov dh, 11        ; Dat DH = 11 (tinh tu 0)
    mov dl, 28        ; Dat DL = 28 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (11, 28)

    
    mov ah, 9
    lea dx, menu_opt2
    int 21h

    mov dh, 12        ; Dat DH = 12 (tinh tu 0)
    mov dl, 28        ; Dat DL = 28 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (12, 28)

    mov ah, 9
    lea dx, menu_opt3
    int 21h

    ; Nhap lua chon tu nguoi dung
    mov ah, 01h
    int 21h

    cmp al, '1'
    je MENU_START

    cmp al, '2'
    je MENU_HELP

    cmp al, '3'
    je MENU_EXIT

    ; Neu phim khong hop le, quay lai menu
    jmp MENU

MENU_START:
    ret         ; Tro lai main de tiep tuc game

MENU_HELP:
    call XOA_MAN_HINH
    lea dx, help_text
    mov ah, 09h
    int 21h

    call IN_DONG_MOI
    call IN_DONG_MOI

    ; nhap phim bat ki và quay lai menu
    mov ah, 01h
    int 21h
    jmp MENU

MENU_EXIT:
    mov ah, 4Ch
    int 21h
MENU ENDP


ASK_PLAY_AGAIN:
    call IN_DONG_MOI   
    
    mov dh, 21        ; Dat DH = 21 (tinh tu 0)
    mov dl, 23        ; Dat DL = 23 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (21, 23)


    lea dx, msg_play_again
    mov ah, 9
    int 21h

    mov ah, 1
    int 21h
    cmp al, 'Y'
    je game_loop
    cmp al, 'y'
    je game_loop
    jmp programEnd
ret

move_cursor proc     ; di chuyen con tro den vi tri (row, column) tren man hinh
    ; INPUT: dh = row , dl = column
    mov ah, 02h       ; Dat AH = 02h de chon chuc nang 02h cua ngat 10h (di chuyen con tro)
    mov bh, 0         ; Dat BH = 0 de chi ro dang lam viec voi trang hien thi 0 (page 0)
    int 10h           ; Goi ngat BIOS 10h de di chuyen con tro den vi tri (row, column)
    
    ret               ; Tro ve tu thu tuc
move_cursor endp     ; Ket thuc dinh nghia thu tuc

PRINT_MANG:

    call IN_DONG_MOI

    mov dh, 8         ; Dat DH = 8 (tinh tu 0)
    mov dl, 27        ; Dat DL = 27 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (8, 27)

    ; In dong 1
    call PRINT_ROW_1
    call PRINT_LINE1

    mov dh, 10        ; Dat DH = 10 (tinh tu 0)
    mov dl, 27        ; Dat DL = 27 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (10, 27)


    ; In dong 2
    call PRINT_ROW_2
    call PRINT_LINE2

    mov dh, 12        ; Dat DH = 12 (tinh tu 0)
    mov dl, 27        ; Dat DL = 27 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (12, 27)

    ; In dong 3
    call PRINT_ROW_3
    call PRINT_LINE3
    
    ; dong duoi cung 
    call PRINT_LINE4 
    call IN_DONG_MOI 
    
    mov dh, 15        ; Dat DH = 15 (tinh tu 0)
    mov dl, 23        ; Dat DL = 23 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (15, 23)

    lea dx, msg_score   ; chu?i 'Score - X: '
    mov ah, 9
    int 21h

    ; In di?m X
    mov al, SCORE_X
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h

    ; In ti?p ' O: '
    mov dl, ' '
    int 21h
    mov dl, '-'
    int 21h
    mov dl, ' '
    int 21h

    ; In diem O
    mov al, SCORE_O
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h
ret

PRINT_LINE1:
    mov dh, 7         ; Dat DH = 7 (tinh tu 0)
    mov dl, 27        ; Dat DL = 27 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (7, 27)
    
    lea dx, LINE
    mov ah, 9
    int 21h
    call IN_DONG_MOI
ret

PRINT_LINE2:
    mov dh, 9         ; Dat DH = 9 (tinh tu 0)
    mov dl, 27        ; Dat DL = 27 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (9, 27)
    
    lea dx, LINE
    mov ah, 9
    int 21h
    call IN_DONG_MOI
ret

PRINT_LINE3:
    mov dh, 11        ; Dat DH = 11 (tinh tu 0)
    mov dl, 27        ; Dat DL = 27 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (11, 27)

    lea dx, LINE
    mov ah, 9
    int 21h
    call IN_DONG_MOI
ret

PRINT_LINE4:
    mov dh, 13        ; Dat DH = 13 (tinh tu 0)
    mov dl, 27        ; Dat DL = 27 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (13, 27)

    lea dx, LINE
    mov ah, 9
    int 21h
    call IN_DONG_MOI
ret

print_char proc
    mov ah, 02h
    int 21h
    ret
print_char endp

print_colored_at proc

    cmp dl,'x'
    je print_x

    cmp dl,'o'
    je print_o

    mov bl, 0Fh  ;mau den
    jmp print_colored




    print_o:
        mov bl, 0Ah ;mau xanh la nen den
        jmp print_colored

    print_x:
        mov bl, 0Ch ;mau do nen den



    print_colored:
        push cx
        mov ah, 09h ;ham in mau
        mov bh, 0
        mov cx, 1  ;in 1 lan
        int 10h  ;lenh ngat cua ham in mau
        pop cx


        call print_char



    ret



print_colored_at endp


; Thu tuc in dong 1: | 1 | 2 | 3 |
PRINT_ROW_1:
    mov dl, '|'
    call print_char

    mov dl, ' '
    call print_char


    mov dl,MANG[0]
    call print_colored_at


     mov dl, ' '
    call print_char

    mov dl, '|'
    call print_char

    mov dl, ' '
    call print_char
    mov dl,MANG[1]
    call print_colored_at
    mov dl, ' '
    call print_char
    mov dl, '|'
    call print_char

    mov dl, ' '
    call print_char
    mov dl,MANG[2]
    call print_colored_at
    mov dl, ' '
    call print_char
    mov dl, '|'
    call print_char

    call IN_DONG_MOI
ret

; Thu tuc in dong 2: | 4 | 5 | 6 |
PRINT_ROW_2:
    mov dl, '|'
    mov ah, 2
    int 21h

    mov dl, ' '
    int 21h
    mov dl,MANG[3]
    call print_colored_at
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h

    mov dl, ' '
    int 21h
    mov dl, MANG[4]
    call print_colored_at
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h

    mov dl, ' '
    int 21h
    mov dl, MANG[5]
    call print_colored_at
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h

    call IN_DONG_MOI
ret

; Thu tuc in dong 3: | 7 | 8 | 9 |
PRINT_ROW_3:
    mov dl, '|'
    mov ah, 2
    int 21h

    mov dl, ' '
    int 21h
    mov dl, MANG[6]
    call print_colored_at
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h

    mov dl, ' '
    int 21h
    mov dl, MANG[7]
    call print_colored_at
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h

    mov dl, ' '
    int 21h
    mov dl, MANG[8]
    call print_colored_at
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h

    call IN_DONG_MOI
ret

IN_DONG_MOI:            		; Thu tuc in dong moi
	mov dl, 0ah     		; Ky tu xuong dong
	mov ah, 2       		; Cau lenh in ky tu
	int 21h         		; Goi ngat de in ky tu
	mov dl, 13
	mov ah, 2       		; Cau lenh in ky tu
	int 21h         		; Goi ngat de in ky tu
ret

PRINT_Space:            		; Thu tuc in khoang trang
	mov dl, 32          		; Ma ascii cua khoang trang
	mov ah, 2            		; Cau lenh in ky tu
	int 21h              		; Goi ngat de in ky tu
ret

NHAP:  				        ; Thu tuc doc du lieu dau vao
	mov ah, 1        		; Cho phep nhap ky tu
	int 21h               	 	; Goi ngat de nhap du lieu
	cmp al, '1'                     ; Kiem tra gia tri nhap vao
	je VALID
	cmp al, '2'
	je VALID
	cmp al, '3'
	je VALID
	cmp al, '4'
	je VALID
	cmp al, '5'
	je VALID
	cmp al, '6'
	je VALID
	cmp al, '7'
	je VALID
	cmp al, '8'
	je VALID
	cmp al, '9'
	je VALID
	jmp NOT_VALID                   ; Quay lai vi tri khong hop le
VALID:                             ; Diem hop le
ret

PRINT_DRAW:                  		; Thu tuc in thong diep hoa
	call IN_DONG_MOI       		; In dong moi

    mov dh, 19        ; Dat DH = 19 (tinh tu 0)
    mov dl, 31        ; Dat DL = 31 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (19, 31)

	lea dx, DRAW            	; Tai dia chi thong diep
	mov ah, 9                	; Cau lenh in chuoi
	int 21h                   	; Goi ngat de in chuoi
    call ASK_PLAY_AGAIN
ret

PRINT_WIN:                     		; Thu tuc in thong diep chien thang
	call IN_DONG_MOI       	 	; In dong moi
	call PRINT_MANG           	; In bang luoi lan cuoi

    mov dh, 19        ; Dat DH = 19 (tinh tu 0)
    mov dl, 27        ; Dat DL = 27 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (19, 27)

	lea dx, WIN               	; Tai dia chi thong diep
	mov ah, 9                 	; Cau lenh in chuoi
	int 21h                    	; Goi ngat de in chuoi
    ; Tang diem cho nguoi thang
    mov al, PLAYER
    cmp al, 'x'
    je tang_diem_x

tang_diem_o:
    inc SCORE_O
    jmp diem_xong

tang_diem_x:
    inc SCORE_X
diem_xong:
	mov dl, PLAYER            	; Di chuyen gia tri nguoi choi vao dl
	mov ah, 2h                 	; Cau lenh in ky tu
	int 21h                    	; Goi ngat de in ky tu
    call ASK_PLAY_AGAIN

ret

IN_NHAP:                 		; Thu tuc in thong diep nhap lieu
    mov dh, 17        ; Dat DH = 17 (tinh tu 0)
    mov dl, 15        ; Dat DL = 15 (tinh tu 0)
    call move_cursor  ; Goi thu tuc move_cursor de di chuyen con tro den vi tri (17, 15)

	lea dx, INPUT            	; Tai dia chi thong diep
	mov ah, 9                   	; Cau lenh in chuoi
	int 21h                       	; Goi ngat de in chuoi
	mov dl, PLAYER               	; Di chuyen gia tri nguoi choi vao dl
	mov ah, 2h                     	; Cau lenh in ky tu
	int 21h                       	; Goi ngat de in ky tu
	call PRINT_Space                ; Goi thu tuc in khoang trang
ret

CHECKWIN:                      		; Thu tuc kiem tra ket qua
	mov bl, MANG[0]                 ; Kiem tra hang 0
	cmp bl, MANG[1]          	; So sanh gia tri dau tien va thu 2
	jne skip1                	; Neu khong giong nhau bo qua
	cmp bl, MANG[2]          	; So sanh gia tri dau tien va thu 3
	jne skip1                	; Neu khong giong nhau bo qua
	call PRINT_WIN           	; Neu giong nhau in thong diep chien thang

skip1:
	mov bl, MANG[3]          	; Kiem tra hang 1
	cmp bl, MANG[4]
	jne skip2
	cmp bl, MANG[5]
	jne skip2
	call PRINT_WIN

skip2:
	mov bl, MANG[6]          	; Kiem tra hang 2
	cmp bl, MANG[7]
	jne skip3
	cmp bl, MANG[8]
	jne skip3
	call PRINT_WIN

skip3:
	mov bl, MANG[0]          	; Kiem tra cot 0
	cmp bl, MANG[3]
	jne skip4
	cmp bl, MANG[6]
	jne skip4
	call PRINT_WIN

skip4:
	mov bl, MANG[1]          	; Kiem tra cot 1
	cmp bl, MANG[4]
	jne skip5
	cmp bl, MANG[7]
	jne skip5
	call PRINT_WIN

skip5:
	mov bl, MANG[2]          	; Kiem tra cot 2
	cmp bl, MANG[5]
	jne skip6
	cmp bl, MANG[8]
	jne skip6
	call PRINT_WIN

skip6:
	mov bl, MANG[0]          	; Duong cheo chinh
	cmp bl, MANG[4]
	jne skip7
	cmp bl, MANG[8]
	jne skip7
	call PRINT_WIN

skip7:
	mov bl, MANG[2]          	; Duong cheo phu
	cmp bl, MANG[4]
	jne skip8
	cmp bl, MANG[6]
	jne skip8
	call PRINT_WIN

skip8:
ret

XOA_MAN_HINH:                    	; Thu tuc xoa man hinh
	mov ax, 3
	int 10h
ret

end main                         	; Ket thuc chuong trinh
  	; Ket thuc chuong trinh
