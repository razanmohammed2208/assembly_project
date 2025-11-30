.MODEL SMALL
.STACK 100H
.DATA
    msg1 db "Enter Player 1 Name: $"
    msg2 db 13,10,"Enter Player 2 Name: $"
    msg3 db 13,10,"player 1 :Enter choice (H=Rock, P=Paper, S=Scissors): $"
    msg4 db 13,10,"player 2 :Enter choice (H=Rock, P=Paper, S=Scissors): $"
    winner_msg db 13,10,"Winner is: $"
    msg_tie db 13,10,"It's a TIE!$" ; ????? ???????
    pname1 db 20 dup(0)
    pname2 db 20 dup(0)
    choice1 db 0
    choice2 db 0
.CODE
start:
    mov ax, @data
    mov ds, ax

;----------------------------------
; Input Player 1 Name
    lea dx, msg1
    mov ah, 09h
    int 21h
    lea dx, pname1
    mov cx, 20
    call ReadString

; Input Player 2 Name
    lea dx, msg2
    mov ah, 09h
    int 21h
    lea dx, pname2
    mov cx, 20
    call ReadString

;----------------------------------
; Player 1 enters choice
    lea dx, msg3
    mov ah, 09h
    int 21h
    call GetChar
    mov choice1, al

; Player 2 enters choice
    lea dx, msg4
    mov ah, 09h
    int 21h
    call GetChar
    mov choice2, al

;----------------------------------
; Decide winner
    mov al, choice1
    mov bl, choice2
    cmp al, bl
    je Tie

    cmp al, 'H'
    jne chk1
    cmp bl, 'S'
    je P1Wins
chk1:
    cmp al, 'S'
    jne chk2
    cmp bl, 'P'
    je P1Wins
chk2:
    cmp al, 'P'
    jne chk3
    cmp bl, 'H'
    je P1Wins
chk3:
    jmp P2Wins

P1Wins:
    lea si, pname1
    jmp ShowWinner
P2Wins:
    lea si, pname2
    jmp ShowWinner
Tie:
    lea dx, msg_tie
    mov ah, 09h
    int 21h
    jmp Exit

;----------------------------------

ShowWinner:
    ; Print "Winner is:"
    lea dx, winner_msg
    mov ah, 09h
    int 21h

    ;------------------------------------
    ; Write winner name directly to video RAM
    ;------------------------------------

    mov ax, 0B800h
    mov es, ax

    ; Row = 10 (???? ???? ??? ????)
    ; Column = 35 (??? Winner is ?????? ???????)
    ; DI = row*160 + col*2
    mov di, (7 * 160) + (35 * 2)

print_loop:
    mov al, [si]
    cmp al, '$'
    je Exit

    mov ah, 02h          ; green
    mov es:[di], ax

    add di, 2
    inc si
    jmp print_loop




;----------------------------------
Exit:
    mov ah, 4Ch
    int 21h

;----------------------------------
ReadString proc
    push ax
    push cx
    push si
    mov si, dx
    mov bx, 0
read_loop:
    mov ah, 01h
    int 21h
    cmp al, 13
    je end_read
    mov [si + bx], al
    inc bx
    loop read_loop
end_read:
    mov byte ptr [si + bx], '$'
    pop si
    pop cx
    pop ax
    ret
ReadString endp

;----------------------------------
GetChar proc
    mov ah, 08h
    int 21h
    ret
GetChar endp

end start