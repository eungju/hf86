\ IBM-PC�A�� �a�e hForth �w �e�i ���b �a���a�������a. ���q�e ���s�w
\ �e�i�e �i �� ���s���a.
\
\ �� �a���a���e VGA �a��Ϣ �a�a�� ���I�A�a �a��Ϣ �a�a�e�i �����s���a.
\
\ 'TEXT'�a�� ���a�e �B�a�a ���e�a�� �a�ቡ 'HGRAPHIC'���a�� ��ǡ�e �a��Ϣ
\ ���e�a�� �a���� �e�i�i ���e�A �a���i �� ���s���a.
\
\ ��q�A�e ���鯢 �a�e�a�� ����A�� ���s���a. 3�鯢 �a�e�a�� �a���a�e
\ '3BUL'���a�� ��ǡ�� 2�鯢 �a�e�a�� �a���a�e '2BUL'���a�� ��ǡ������.
\
\ �i���i �a���a�e �a����� ENGFONT-LOADED�� HANFONT-LOADED�i �a������.
\
\     BL PARSE ENG.FNT ENGFONT-LOADED
\     BL PARSE HAN.FNT HANFONT-LOADED
\
\ �a���a 11008���a 11520 �a���a�� 8��X4��X4�� �i���i �i �� ���s���a.
\
\ HF86EXE.EXE�i ���b�e ҁ �a�q ���ᝡ �� �a���a���i ���� �� ���s���a.
\
\	<< OPTIONAL.F
\	<< ASM8086.F
\	<< COREEXT.F
\	<< MSDOS.F
\	BL PARSE MULTI.F    INCLUDED
\	BL PARSE HIOMULT2.F INCLUDED
\
\ 1996. 2. 9.
\ Wonyong Koh
\
\ Usage:
\   TEXT  ( -- )
\	Set text screen and redirect i/o vectors to DOS functions.
\   HGRAPHIC  ( -- )
\	Set graphics screen and redirect i/o vectors to handle Korean
\	character input and graphics screen output.
\   ENGFONT-LOADED  ( c-addr u -- )
\	Load English font file 'c-addr u' of which size is 4096 bytes.

CHAR " PARSE FILE" ENVIRONMENT? 0= [IF] 0 [THEN]
0= [IF]
    CR .( This program needs FILE wordset words.) ABORT
[THEN]

BASE @
GET-ORDER  GET-CURRENT

FORTH-WORDLIST SET-CURRENT
WORDLIST WORDLIST-NAME �e�i���b-WORDLIST
�e�i���b-WORDLIST SET-CURRENT
GET-ORDER �e�i���b-WORDLIST SWAP 1+ SET-ORDER

CR .( Loading character font data)
DECIMAL
CREATE ENGFONT	    \ 8x16, 128 �a
16 128 * ALLOT

CREATE HANFONT	    \ 16x16, 19 �a x 8 �� + 21 �a X 4 �� + 27 �a X 4 ��
11008 ALLOT
HANFONT CONSTANT �����i��
�����i�� 32 19 * 8 * + CONSTANT �����i��
�����i�� 32 21 * 4 * + CONSTANT �hñ�i��

NONSTANDARD-WORDLIST SET-CURRENT
: ENGFONT-LOADED  ( c_addr u -- )
    R/O OPEN-FILE THROW 				    \ fileid
    DUP ENGFONT [ 16 128 * ] LITERAL ROT READ-FILE THROW    \ fileid n
    [ 16 128 * ] LITERAL <> IF
	." �w���i�� �a���A �i���t�� ���a�s���a." CR
	ABORT" Not enough font data in English font file." THEN
    CLOSE-FILE THROW ;

: HANFONT-LOADED ( c_addr u -- )
    R/O OPEN-FILE THROW 	\ fileid
    DUP FILE-SIZE THROW 	\ fileid ud
    IF	." ���a�e �e�i�i�� �a�������a - �a���� �ᢁ �s���a." CR
	ABORT" Unknown type of Korean font file - file too big." THEN
    \ fileid u
    CASE
      11008 OF DUP �����i�� 11008 ROT READ-FILE THROW DROP ENDOF
      11520 OF
	8 0 DO DUP DUP FILE-POSITION THROW 32 S>D D+ ROT REPOSITION-FILE THROW
	       DUP �����i�� [ 19 32 * ] LITERAL I * + [ 19 32 * ] LITERAL
	       ROT READ-FILE THROW DROP LOOP
	4 0 DO DUP DUP FILE-POSITION THROW 32 S>D D+ ROT REPOSITION-FILE THROW
	       DUP �����i�� [ 21 32 * ] LITERAL I * + [ 21 32 * ] LITERAL
	       ROT READ-FILE THROW DROP LOOP
	4 0 DO DUP DUP FILE-POSITION THROW 32 S>D D+ ROT REPOSITION-FILE THROW
	       DUP �hñ�i�� [ 27 32 * ] LITERAL I * + [ 27 32 * ] LITERAL
	       ROT READ-FILE THROW DROP LOOP
	ENDOF
      DROP ." ���a�e �e�i�i�� �a�������a." CR
	   ABORT" Unknown type of Korean font file."
    ENDCASE
    CLOSE-FILE THROW ;

BL PARSE ENG.FNT ENGFONT-LOADED
BL PARSE HAN.FNT HANFONT-LOADED

�e�i���b-WORDLIST SET-CURRENT

\
\ �e�i �b �{�i
\
CR .( Loading character output words)

DECIMAL 80 CONSTANT MAX-X
VARIABLE VIR_X
VARIABLE VIR_Y

HEX
: BINARY   2 BASE ! ;
: 16* ( n -- 16*n )   2* 2* 2* 2* ;
: ���A= ( char -- 0|-1 )   DUP 08 = OVER 07F = OR SWAP 0FF = OR ;

CODE INT10  ( AX -- AX )
    BX AX MOV,		\ BX�a �ᣡ�� �� �� �t�����a.
    10 INT,		\ AH = 0
    AX BX MOV,
    NEXT,
END-CODE

: GET-MODE ( -- mode )
    0F00 INT10 0FF AND ;

3 VALUE OldMode#

: SET-MODE  ( mode -- )   INT10 DROP ;

: VGA?	( -- flag )   1A00 INT10 0FF AND 1A = ;

0 VALUE GRAPHIC?
3 VALUE textmode#

\ for VGA graphics card
DECIMAL 30 VALUE MAX-Y			\ 640X480 Ё�w��; 480 / 16 = 30 ��
HEX

: VGA-SET-GRAPHIC  ( -- )   11 SET-MODE  -1 TO GRAPHIC? ;

\ VGA ������ �A������ �b ���A ���e �A�a���a ������ �a�i �e�k
\ Y ���a�� �� �A�a���a �t�i ��a�e X ���a�i �a��
\ ���a�U ������ �i �� ���s���a.
CREATE VGA-Y>SegTable MAX-Y 16* CELLS ALLOT

MARKER ~TEMP
:NONAME
   MAX-Y 16* 0 DO  0A000  I 5 *  +  VGA-Y>SegTable I CELLS + !	LOOP ;
EXECUTE
~TEMP	\ �a�i ������ �� �{�i�i ����

\ for Hercules monochrome grahics card
DECIMAL 25 TO MAX-Y			\ 640X400 Ё�w��; 400 / 16 = 25 ��
HEX

CREATE 6854REGS 	\ 640X400 Ё�w���A ϩ�a�e 6845 �A���a�� �����t
31 C, 28 C, 29 C, 08 C, 68 C, 02 C, 64 C, 65 C, 02 C, 03 C,

: HERC?  ( -- flag )
    03B5 PC@  4F DUP  03B5 PC!	100 0 DO LOOP
    03B5 PC@  ROT  03B5 PC!  = IF
	03BA PC@ 80 AND
	8000 0 DO 03BA PC@ 80 AND OVER <> IF UNLOOP DROP TRUE EXIT THEN LOOP
    THEN FALSE ;

: HERC-SET-GRAPHIC  ( -- )
   0A 0 DO I 03B4 PC! 6854REGS I + C@ 03B5 PC! LOOP
   1 03BF PC!		\ �a��Ϣ ���a�i ��w, �a��Ϣ �A���� 1 �e �a�w ���a�w
   [ BINARY ] 00001010 [ HEX ]
   03B8 PC!		\ �a��Ϣ �A���� 0 �i �a��Ϣ ���a�� �a��
   -1 TO GRAPHIC? ;

\ ���I�A�a ������ �A������ �b ���A ���e �A�a���a ������ �a�i �e�k
\ �a��Ϣ �A���� 1�e 0B000:0h�A�� ���b
\ Y ���a�� �� �A�a���a �t�i ��a�e X ���a�i �a��
\ ���a�U ������ �i �� ���s���a.
CREATE HERC-Y>SegTable MAX-Y 16* CELLS ALLOT

MARKER ~TEMP
:NONAME
   MAX-Y 16* 0 DO 0B000  I 4 MOD 200 *	+  I 4 /  5 *  +
		  HERC-Y>SegTable I CELLS + !		   LOOP ;
EXECUTE
~TEMP	\ �a�i ������ �� �{�i�i ����

VARIABLE Y>SegTable
: Y>SEG  ( y -- segment_addr )
    CELLS Y>SegTable @ + @ ;

' VGA-SET-GRAPHIC VALUE 'SET-GRAPHIC

NONSTANDARD-WORDLIST SET-CURRENT
: SET-GRAPHIC  ( -- )	'SET-GRAPHIC EXECUTE ;
�e�i���b-WORDLIST SET-CURRENT

DECIMAL

\ �B�a�a Y ���a�� ���e�A �a���E ���a�i�i �a�� �� ���� ����
\ �a��Ϣ ���a���e 16y ���� 16 �a�����i �b�b 16 �� �ᝡ ����
\ : UP-LINE
\    16* DUP 16 - DO
\      I 16 + Y>SEG  I Y>SEG
\      40 0 DO OVER I 2* L@  OVER I 2* L! LOOP	2DROP
\    LOOP ;

CODE UP-LINE  ( y -- )
   SI PUSH,
   BX DEC,
   5 # CL MOV,
   BX CL SHL,			\ BX = (VIR_Y@-1)@ * 32
   Y>SegTable ) BX ADD,
   16 # DX MOV,
1 L:
   SI SI XOR,
   DI DI XOR,
   SS:	0 [BX] ES MOV,
   SS: 32 [BX] DS MOV,
   40 # CX MOV,
   REPE, WORD MOVS,
   2 # BX ADD,
   DX DEC,
   1 L# JNE,
   SS AX MOV,
   AX DS MOV,
   SI POP,
   BX POP,
   NEXT,
END-CODE

\ �B�a�a Y ���a�� ���i ����
\ : CLEAR-LINE
\    16* DUP 16 + SWAP
\    DO I Y>SEG
\	40 0 DO 0 OVER I 2* L! LOOP  DROP
\    LOOP ;

CODE CLEAR-LINE  ( y -- )
   5 # CL MOV,
   BX CL SHL,			\ BX = VIR_Y@ * 32
   Y>SegTable ) BX ADD,
   AX AX XOR,
   16 # DX MOV,
1 L:
   0 [BX] ES MOV,
   DI DI XOR,
   40 # CX MOV,
   REPE,
   WORD STOS,
   2 # BX ADD,
   DX DEC,
   1 L# JNE,
   BX POP,
   NEXT,
END-CODE

HEX
VARIABLE VSCR0
VARIABLE YY
VARIABLE XX
1000 CONSTANT VSCREEN-SIZE
0FFF CONSTANT VSCR-MASK
CREATE VSCREEN VSCREEN-SIZE CHARS ALLOT
: >VSCR-ADDR   ( offset -- c_addr )
    VSCR0 @ + VSCR-MASK AND VSCREEN + ;

DECIMAL

\ : EFONT!  ( x y char -- )
\    16* ENGFONT +	  \ x y font-addr
\    SWAP 16*		  \ x font-addr 16y
\    16 0 DO OVER I + C@ OVER I + Y>SEG 4 PICK LC! LOOP DROP 2DROP ;

CODE EFONT!  ( x y char -- )
   SI DX MOV,		\ MOV	DX,SI
   BX SI MOV,		\ MOV	SI,BX
   BX POP,		\ POP	BX
   DI POP,		\ POP	DI
   4 # CL MOV,		\ MOV	CL,#4
   SI CL SHL,		\ SHL	SI,CL
   ENGFONT # SI ADD,	\ ADD	SI,ENGFONT	; SI = font-addr
   CL INC,		\ INC	CL		; CL = 5
   BX CL SHL,		\ SHL	BX,CL		; BX = VIR_Y@ * 32
   Y>SegTable ) BX ADD,
   2 # CX MOV,
 15
   0 [BX] ES MOV, BYTE LODS, ES: AL 0 [DI] MOV, CX BX ADD, 1- ?DUP [IF] 0 >IN ! [THEN]
   0 [BX] ES MOV, BYTE LODS, ES: AL 0 [DI] MOV,
   DX SI MOV,
   BX POP,
   NEXT,
END-CODE

HEX
CREATE �����i��
00000 , 00000 , 00000 , 00000 , 00000 , 00000 , 00000 , 00000 , \ ����
00000 , 00000 , 00000 , 00000 , 00000 , 00000 , 00000 , 00000 ,

CREATE �a���a�i��
05555 , 0AAAA , 05555 , 0AAAA , 05555 , 0AAAA , 05555 , 0AAAA , \ �a�� �g�q
05555 , 0AAAA , 05555 , 0AAAA , 05555 , 0AAAA , 05555 , 0AAAA ,

BINARY
00001 CONSTANT ��������
00010 CONSTANT ��������
00001 CONSTANT �����hñ
1000010001000001 CONSTANT �����a	\ ����, ����, �hñ ���� �����a
0111110000000000 CONSTANT ������
0000001111100000 CONSTANT ������
0000000000011111 CONSTANT �hñ��
1000001111111111 CONSTANT ����������
1111110000011111 CONSTANT ����������
1111111111100000 CONSTANT �hñ������
DECIMAL

VARIABLE HCHAR

\ VARIABLE H1FONT
\ VARIABLE H2FONT
\ VARIABLE H3FONT
\ : Y>SEG  ( y -- segment )   CELLS Y>SegTable @ + @ ;
\ : H2FONT!  ( x y �����i���t �����i���t -- )
\     H2FONT !
\     H1FONT !
\     16*
\     16 0 DO H1FONT @ @
\	      H2FONT @ @ OR
\	      OVER I + Y>SEG 3 PICK L!
\	      2 H1FONT +!  2 H2FONT +!
\	   LOOP  2DROP ;
\
\ : H3FONT!  ( x y �����i���t �����i���t �hñ�i���t -- )
\     H3FONT !
\     H2FONT !
\     H1FONT !
\     16*
\     16 0 DO H1FONT @ @
\	      H2FONT @ @ OR
\	      H3FONT @ @ OR
\	      OVER I + Y>SEG 3 PICK L!
\	      2 H1FONT +!  2 H2FONT +!	2 H3FONT +!
\	   LOOP  2DROP ;

\ ���s�wš�a�i �� �a�� ���e �i�� š�a�t�a�� �a��
\ '���A�� ���� �e�i' ����Ӂ, ������ ���q, �������� (1991) 122-134�� �q��
\ �����a�e 32�i, �A�a�a�� �g�e š�a�e 96(=32+64)�i �ᣡ�A ����

CREATE �����i��š�a�a  ( ���s�w����š�a -- �����i��š�a )
    96 C, 32 C,  0 C,  1 C,  2 C,  3 C,  4 C,  5 C,
     6 C,  7 C,  8 C,  9 C, 10 C, 11 C, 12 C, 13 C,
    14 C, 15 C, 16 C, 17 C, 18 C, 96 C, 96 C, 96 C,
    96 C, 96 C, 96 C, 96 C, 96 C, 96 C, 96 C, 96 C, ALIGN

CREATE �����i��š�a�a  ( ���s�w����š�a -- �����i��š�a )
    96 C, 96 C, 32 C,  0 C,  1 C,  2 C,  3 C,  4 C,
    96 C, 96 C,  5 C,  6 C,  7 C,  8 C,  9 C, 10 C,
    96 C, 96 C, 11 C, 12 C, 13 C, 14 C, 15 C, 16 C,
    96 C, 96 C, 17 C, 18 C, 19 C, 20 C, 96 C, 96 C, ALIGN

CREATE �hñ�i��š�a�a  ( ���s�w�hñš�a -- �hñ�i��š�a )
    96 C, 32 C,  0 C,  1 C,  2 C,  3 C,  4 C,  5 C,
     6 C,  7 C,  8 C,  9 C, 10 C, 11 C, 12 C, 13 C,
    14 C, 15 C, 96 C, 16 C, 17 C, 18 C, 19 C, 20 C,
    21 C, 22 C, 23 C, 24 C, 25 C, 26 C, 96 C, 96 C, ALIGN

19 VALUE š�a��
: *,   š�a�� * , ;

CREATE �hñ���e�����i���飻  ( �����i��š�a -- �����i���� )
    \ �a   ��	��   ��   ��   �A   �a	 ��   ��   ��	��
       0 *, 0 *, 0 *, 0 *, 0 *, 0 *, 0 *, 0 *, 1 *, 3 *, 3 *,
    \ �A   �a	��   ��   ��   ��   �A	 �a   ��   ��
       3 *, 1 *, 2 *, 4 *, 4 *, 4 *, 2 *, 1 *, 3 *, 0 *,

21 TO š�a��
CREATE �hñ���e�����i���飻  ( �����i��š�a -- �����i���� )
    \ �A   �A	�A   �A   �A   �A   �A	 �A   �A   �A
      0 *, 1 *, 1 *, 1 *, 1 *, 1 *, 1 *, 1 *, 1 *, 1 *,
    \ �A   �A	�A   �A   �A   �A   �A	 �A   �A
      1 *, 1 *, 1 *, 1 *, 1 *, 0 *, 1 *, 1 *, 1 *,

19 TO š�a��
CREATE �hñ���e�����i���飻  ( �����i��š�a -- �����i���� )
    \ �a   ��	��   ��   ��   �A   �a	 ��   ��   ��	��
       5 *, 5 *, 5 *, 5 *, 5 *, 5 *, 5 *, 5 *, 6 *, 7 *, 7 *,
    \ �A   �a	��   ��   ��   ��   �A	 �a   ��   ��
       7 *, 6 *, 6 *, 7 *, 7 *, 7 *, 6 *, 6 *, 7 *, 5 *,

21 TO š�a��
CREATE �hñ���e�����i���飻  ( �����i��š�a -- �����i���� )
    \ �A   �A	�A   �A   �A   �A   �A	 �A   �A   �A
      2 *, 3 *, 3 *, 3 *, 3 *, 3 *, 3 *, 3 *, 3 *, 3 *,
    \ �A   �A	�A   �A   �A   �A   �A	 �A   �A
      3 *, 3 *, 3 *, 3 *, 3 *, 2 *, 3 *, 3 *, 3 *,

27 TO š�a��
CREATE �hñ�i���飻  ( �����i��š�a -- �hñ�i���� )
    \ �a   ��	��   ��   ��   �A   �a	 ��   ��   ��	��
       0 *, 2 *, 0 *, 2 *, 1 *, 2 *, 1 *, 2 *, 3 *, 0 *, 2 *,
    \ �A   �a	��   ��   ��   ��   �A	 �a   ��   ��
       1 *, 3 *, 3 *, 1 *, 2 *, 1 *, 3 *, 3 *, 1 *, 1 *,

\ : CCFONT!  ( x y �hñ���e16���a�e�iš�a -- )
\     DUP ������ AND 10 RSHIFT CHARS
\     �����i��š�a�a + C@ SWAP		  \ x y �����i��š�a �e�iš�a
\     ������ AND 5 RSHIFT CHARS
\     �����i��š�a�a + C@		  \ x y �����i��š�a �����i��š�a
\     2DUP OVER 31 > IF
\	  DROP 63 > IF �a���a�i�� ELSE �����i�� THEN
\     ELSE DUP 31 > IF DROP 0 THEN
\	  CELLS �hñ���e�����i���飻 + @ + 5 LSHIFT �����i�� +	    THEN
\     ROT ROT DUP 31 > IF NIP 63 > IF �a���a�i�� ELSE �����i�� THEN
\     ELSE SWAP DUP 31 > IF DROP 0 THEN
\	  CELLS �hñ���e�����i���飻 + @ + 5 LSHIFT �����i�� +	    THEN
\     H2FONT! ;

CODE CCFONT!  ( x y �hñ���e16���a�e�iš�a -- )
    CX POP,
    DX POP,
    BP PUSH,
    SI PUSH,
    DX PUSH,
    CX PUSH,
    BX SI MOV,				\ SI = �e�iš�a
    ������ # BX AND,
    10 # CL MOV,
    BX CL SHR,
    �����i��š�a�a [BX] BL MOV,
    BX AX MOV,				\ AX = �����i��š�a�a
    SI BX MOV,
    ������ # BX AND,
    5 # CL MOV,
    BX CL SHR,
    �����i��š�a�a [BX] BL MOV,
    BX DX MOV,				\ DX = �����i��š�a�a
xhere ( HFONT!�A�� ��ᵩ �����i �ᣡ�A �q��)
    BINARY 00100000 DECIMAL # AL TEST,
    1 L# JZ,
    \ AX(=����)�a �����a����a ���a�i�����e
    �����i�� # SI MOV,
    BINARY 01000000 DECIMAL # AL TEST,
    2 L# JZ,
    �a���a�i�� # SI MOV,
    2 L# JU,
1 L:
    BX BX XOR,
    BINARY 00100000 DECIMAL # DL TEST,
    3 L# JNZ,
    DX BX MOV,
    BX 1 SHL,
3 L:
    �hñ���e�����i���飻 [BX] SI MOV,
    AX SI ADD,
    5 # CL MOV,
    SI CL SHL,
    �����i�� # SI ADD,
2 L:	\ SI = �����i������
    BINARY 00100000 DECIMAL # DL TEST,
    4 L# JZ,
    \ DX(=����)�a �����a����a ���a�i�����e
    �����i�� # DI MOV,
    BINARY 01000000 DECIMAL # DL TEST,
    5 L# JZ,
    �a���a�i�� # DI MOV,
    5 L# JU,
4 L:
    BX BX XOR,
    BINARY 00100000 DECIMAL # AL TEST,
    6 L# JNZ,
    AX BX MOV,
    BX 1 SHL,
6 L:
    �hñ���e�����i���飻 [BX] DI MOV,
    DX DI ADD,
    5 # CL MOV,
    DI CL SHL,
    �����i�� # DI ADD,
5 L:	\ DI = �����i������
    BX POP,			\ BX = y
    DX POP,			\ DX = x
    5 # CL MOV,
    BX CL SHL,			\ BX = y * 32
    Y>SegTable ) BX ADD,
    2 # CX MOV,
  15
    WORD LODS, 0 [DI] AX OR, 0 [BX] ES MOV, BX DX XCHG, ES: AX 0 [BX] MOV, BX DX XCHG, CX DI ADD, CX BX ADD, 1- ?DUP [IF] 0 >IN ! [THEN]
    WORD LODS, 0 [DI] AX OR, 0 [BX] ES MOV, BX DX XCHG, ES: AX 0 [BX] MOV,
    SI POP,
    BP POP,
    BX POP,
    NEXT,
END-CODE

\ : CCCFONT!  ( x y �hñ���e16���a�e�iš�a -- )
\     DUP ������ AND 10 RSHIFT CHARS
\     �����i��š�a�a + C@ SWAP	    \ x y �����i��š�a �e�iš�a
\     DUP ������ AND 5 RSHIFT CHARS
\     �����i��š�a�a + C@ SWAP	    \ x y �����i��š�a �����i��š�a �e�iš�a
\     �hñ�� AND CHARS
\     �hñ�i��š�a�a + C@	    \ x y �����i��š�a �����i��š�a �hñ�i��š�a
\     DUP 31 > IF 63 > IF �a���a�i�� ELSE �����i�� THEN
\     ELSE OVER DUP 31 > IF DROP 0 THEN
\	   CELLS �hñ�i���飻 + @ + 5 LSHIFT �hñ�i�� + THEN
\     ROT ROT
\     2DUP OVER 31 > IF DROP 63 > IF �a���a�i�� ELSE �����i�� THEN
\     ELSE DUP 31 > IF DROP 0 THEN
\	   CELLS �hñ���e�����i���飻 + @ + 5 LSHIFT �����i�� +     THEN
\     ROT ROT DUP 31 > IF NIP 63 > IF �a���a�i�� ELSE �����i�� THEN
\     ELSE SWAP DUP 31 > IF DROP 0 THEN
\	   CELLS �hñ���e�����i���飻 + @ + 5 LSHIFT �����i�� +     THEN
\     H3FONT! ;

\ : HFONT!  ( x y 16���a�e�iš�a -- )
\     DUP �hñ�� AND 1 = IF CCFONT! ELSE CCCFONT! THEN ;

CODE HFONT!  ( x y 16���a�e�iš�a -- )
    CX POP,
    DX POP,
    BP PUSH,
    SI PUSH,
    DX PUSH,
    CX PUSH,
    BX SI MOV,				\ SI = �e�iš�a
    ������ # BX AND,
    10 # CL MOV,
    BX CL SHR,
    �����i��š�a�a [BX] BL MOV,
    BX AX MOV,				\ AX = �����i��š�a�a
    SI BX MOV,
    ������ # BX AND,
    5 # CL MOV,
    BX CL SHR,
    �����i��š�a�a [BX] BL MOV,
    BX DX MOV,				\ DX = �����i��š�a�a
    SI BX MOV,
    �hñ�� # BX AND,
    1 # BX CMP,
    0 L# JNZ,
    ( CCFONT! ���� �e�A�� �q�� ����) # JMP,
0 L:
    �hñ�i��š�a�a [BX] BL MOV,
    BX CX MOV,				\ CX = �hñ�i��š�a�a
    BINARY 00100000 DECIMAL # CL TEST,
    1 L# JZ,
    \ CX(=�hñ)�a �����a����a ���a�i�����e
    �����i�� # BP MOV,
    BINARY 01000000 DECIMAL # CL TEST,
    2 L# JZ,
    �a���a�i�� # BP MOV,
    2 L# JU,
1 L:
    BX BX XOR,
    BINARY 00100000 DECIMAL # DL TEST,
    3 L# JNZ,
    DX BX MOV,
    BX 1 SHL,
3 L:
    �hñ�i���飻 [BX] BP MOV,
    CX BP ADD,
    5 # CL MOV,
    BP CL SHL,
    �hñ�i�� # BP ADD,
2 L:	\ BP = �hñ�i������
    BINARY 00100000 DECIMAL # AL TEST,
    4 L# JZ,
    \ AX(=����)�a �����a����a ���a�i�����e
    �����i�� # SI MOV,
    BINARY 01000000 DECIMAL # AL TEST,
    5 L# JZ,
    �a���a�i�� # SI MOV,
    5 L# JU,
4 L:
    BX BX XOR,
    BINARY 00100000 DECIMAL # DL TEST,
    6 L# JNZ,
    DX BX MOV,
    BX 1 SHL,
6 L:
    �hñ���e�����i���飻 [BX] SI MOV,
    AX SI ADD,
    5 # CL MOV,
    SI CL SHL,
    �����i�� # SI ADD,
5 L:	\ SI = �����i������
    BINARY 00100000 DECIMAL # DL TEST,
    7 L# JZ,
    \ DX(=����)�a �����a����a ���a�i�����e
    �����i�� # DI MOV,
    BINARY 01000000 DECIMAL # DL TEST,
    8 L# JZ,
    �a���a�i�� # DI MOV,
    8 L# JU,
7 L:
    BX BX XOR,
    BINARY 00100000 DECIMAL # AL TEST,
    9 L# JNZ,
    AX BX MOV,
    BX 1 SHL,
9 L:
    �hñ���e�����i���飻 [BX] DI MOV,
    DX DI ADD,
    5 # CL MOV,
    DI CL SHL,
    �����i�� # DI ADD,
8 L:	\ DI = �����i������
    BX POP,			\ BX = y
    DX POP,			\ DX = x
    5 # CL MOV,
    BX CL SHL,			\ BX = y * 32
    Y>SegTable ) BX ADD,
    2 # CX MOV,
  15
    WORD LODS, 0 [DI] AX OR, 0 [BP] AX OR, 0 [BX] ES MOV, BX DX XCHG, ES: AX 0 [BX] MOV, BX DX XCHG, CX DI ADD, CX BP ADD, CX BX ADD, 1- ?DUP [IF] 0 >IN ! [THEN]
    WORD LODS, 0 [DI] AX OR, 0 [BP] AX OR, 0 [BX] ES MOV, BX DX XCHG, ES: AX 0 [BX] MOV,
    SI POP,
    BP POP,
    BX POP,
    NEXT,
END-CODE

: xySTR!  ( x y c_addr u -- )
    BEGIN >R >R 2DUP R@ C@
	  DUP 128 < IF EFONT!
	  ELSE 8 LSHIFT R> CHAR+ DUP >R C@ OR HFONT! SWAP 1+ SWAP
	  THEN
	  SWAP 1+ SWAP R> CHAR+ R> 1- DUP 0=
    UNTIL 2DROP 2DROP ;

DECIMAL 30 TO MAX-Y

CREATE MAX-X*Table MAX-Y 1+ CELLS ALLOT
MARKER ~TEMP
:NONAME   MAX-Y 1+ 0 DO I MAX-X *  MAX-X*Table I CELLS +  !  LOOP ; EXECUTE
~TEMP
: MAX-X*  ( y -- MAX_X*y )   CELLS MAX-X*Table + @ ;

HEX
: SHOW-LINE  ( y -- )		\ �a�w���e�� y ���i �a��Ϣ ���e�A �a��
    >R 1 MAX-X* 0				\ max-x 0  R: y
    BEGIN
       DUP R@ OVER >VSCR-ADDR DUP C@		\ max-x x x 0 c_addr char
       DUP 80 < IF NIP EFONT!
       ELSE 8 LSHIFT
	    SWAP CHAR+ C@ OR HFONT! CHAR+ THEN
       CHAR+ 2DUP =
    UNTIL 2DROP R> DROP ;

0 VALUE YTop

: SCROLL  ( -- )
    MAX-Y MAX-X* DUP MAX-X + SWAP
    DO BL I >VSCR-ADDR C! LOOP
    MAX-Y 1-  MAX-X 0 DO I OVER BL EFONT! LOOP DROP
    VSCR0 @ MAX-X + VSCR-MASK AND VSCR0 !
    YTop SHOW-LINE
    0 XX !  YTop YY ! ;

: VIR_X+!  ( n -- )
    VIR_X @ + MAX-X /MOD VIR_Y +! VIR_X !
    VIR_Y @ MAX-Y = IF SCROLL -1 VIR_Y +! THEN ;

: VSCR!  ( char -- )   VIR_Y @ MAX-X* VIR_X @ + >VSCR-ADDR C! ;

: multiEMIT  ( char -- )
    DUP ���A= IF DROP VIR_X @ VIR_Y @ BL EFONT! -1 VIR_X +! BL VSCR! EXIT THEN
    DUP 0D ( CR) =  IF DROP  0 VIR_X !				     EXIT THEN
    DUP 0A ( LF) =  IF DROP  VIR_Y @ 1+ MAX-Y < IF 1 VIR_Y +! EXIT THEN
			     SCROLL				     EXIT THEN
    VSCR!  1 VIR_X+! ;

: HEMIT  ( char -- )
    HCHAR @ 0= IF			\ ���� ���b�a�e �i�a
      DUP 80 < IF multiEMIT EXIT THEN	\ �e�i�� �a���e �a���� �b
      VIR_X @ 1+ MAX-X = IF VIR_X @ multiEMIT BL multiEMIT THEN
      HCHAR ! EXIT			\ �� 8 ���a �e�a�i �i����
    THEN
    HCHAR @ multiEMIT  multiEMIT  0 HCHAR ! ;

\
\ �e�i ���b �{�i�i
\

CR .( Loading character input words)

CODE INT16h
   BX AX MOV,
   16 INT,
   AX BX MOV,
   NEXT,
END-CODE

\ �a���b �i�A ���b �� �E�� ���i�A�a ���v�a�e �q, �a���e �ỵ
: �E�����A����?  ( -- flag )
	200 INT16h  [ BINARY ] 00000010 [ HEX ] AND 0= 0= ;

\ �a���b �i�A ���b �� CapsLock �wȁ�v�a�e �q, �a���e �ỵ
: CapsLock?  ( -- flag )
	200 INT16h  [ BINARY ] 01000000 [ HEX ] AND 0= 0= ;

VARIABLE �i�A���b�wȁ
VARIABLE �i�Aɷ
VARIABLE ���Ŭ��a
CREATE �i�A���b�wȁ����  8 CELLS ALLOT
CREATE ���Ŭ��a����	 8 CELLS ALLOT
VARIABLE �����b�wȁ
VARIABLE �����Ŭ��a
: �|�a����  ( -- )
    ���Ŭ��a @	�����Ŭ��a @ 7 AND CELLS ���Ŭ��a���� + !
    1 �����Ŭ��a +! ;
: �wȁ����  ( �wȁ -- )
    �����b�wȁ @ 7 AND CELLS �i�A���b�wȁ���� + !
    1 �����b�wȁ +! ;

DECIMAL
: |  ( "<spaces>name" -- )   ' , ;
: �e ;
: ��ɡ�a�a:  ( width -- )
	CREATE , ;
: ;��ɡ�a�a
	DOES>
	TUCK @				\ ���� ���A �e��
	�i�A���b�wȁ @
	DUP �wȁ���� �|�a����	      \ �e�i�i�a���e
	* + 2* CELLS + CELL+
	DUP >R
	@ EXECUTE
	R> CELL+
	@ EXECUTE
	�i�A���b�wȁ ! ;

0 CONSTANT >0 IMMEDIATE
1 CONSTANT >1 IMMEDIATE
2 CONSTANT >2 IMMEDIATE
3 CONSTANT >3 IMMEDIATE
5 CONSTANT >5 IMMEDIATE

HEX
\ �e���a ���e ���e���{�A ���a�e �a�qЗ�A�� ���b�h�q
: �e����á����	( -- )	 VIR_X @ 1+ MAX-X = ( -1|0) NEGATE VIR_X+! ;
: ���Ŭ��a���a	 ( -- )   VIR_X @  VIR_Y @  ���Ŭ��a @	HFONT! ;
: �a��	( -- )	 VIR_X @ VIR_Y @  BL  EFONT! ;
: ����!  ( -- )   �����a  ���Ŭ��a !  1 �wȁ����  �|�a���� ;
: ���Ŭ��a����	( -- ���� )   ���Ŭ��a @  ������  AND 0A RSHIFT ;
: ���Ŭ��a����	( -- ���� )   ���Ŭ��a @  ������  AND 05 RSHIFT ;
: ���Ŭ��a�hñ	( -- �hñ )   ���Ŭ��a @  �hñ��  AND ;
: ���b����  ( -- 0 )   ���Ŭ��a���a 0 ;
: �{�a�a��  ( �t ������ -- )   ���Ŭ��a @  AND	OR  ���Ŭ��a ! ;
: �����a��  ( ���� -- )   0A LSHIFT  ���������� �{�a�a�� ;
: �����a��  ( ���� -- )   05 LSHIFT  ���������� �{�a�a�� ;
: �hñ�a��  ( �hñ -- ) 	     �hñ������ �{�a�a�� ;
: ����!   ( ���� -- 0 )   �e����á����	�����a�� ���b���� ;
: ����!   ( ���� -- 0 ) 		�����a�� ���b���� ;

: �Ŭ�	 (    0 -- 16���a�a )	DROP	  ���Ŭ��a @  ����! ;
: ��+ch  ( char -- 16���a�a )	�i�Aɷ !  ���Ŭ��a @  ����! ;
: ��+��  ( ���� -- 16���a�a )	���Ŭ��a @  ����!  SWAP �����a�� ;
: ��+��  ( ���� -- 16���a�a )	���Ŭ��a @  ����!  SWAP �����a�� ;

: �ᝡ	( ���A -- 0 )
    DROP -2 �����Ŭ��a +!
    �����Ŭ��a @ 7 AND CELLS ���Ŭ��a���� + @  ���Ŭ��a !  ���b���� ;
: >��  ( -- �|�wȁ )
    -2 �����b�wȁ +!
    �����b�wȁ @ 7 AND CELLS �i�A���b�wȁ���� + @ ;

CREATE ����>�s�����a  \ �s�����i �e�i�� ���e �A,�A,�A,�A,�A�A ��Ё��e 1,
		      \ �a���e 0
\ *   ����  �A	 �A   �A   �A	�A   �A   �A   �A   �A
  0 C, 0 C, 1 C, 0 C, 0 C, 1 C, 0 C, 0 C, 0 C, 1 C, 0 C,
\ �A   �A   �A	 �A   �A   �A	�A   �A   �A   �A
  1 C, 0 C, 0 C, 1 C, 0 C, 0 C, 0 C, 0 C, 0 C, 0 C,  ALIGN

CREATE ����>�hñ�a  \ �hñ�� �a�� ���� �A,�A,�A�A ��Ё��e 0, �a���e �hñ�t
\ *   ����  �A	 �A   �A   �A	�A   �A   �A	�A    �A
  0 C, 1 C, 2 C, 3 C, 5 C, 8 C, 0 C, 9 C, 11 C, 13 C, 0 C,
\ �A	�A    �A    �A	  �A   �A    �A    �A	 �A    �A
  15 C, 16 C, 17 C, 18 C, 0 C, 19 C, 1A C, 1B C, 1C C, 1D C,  ALIGN

CREATE �hñ>ѻ�hñ�����a  \ �s�hñ: ��8���a�e ѻ�hñ�t, �a��8���a�e �����t
			  \ ѻ�hñ: ��8���a�e	�����t, �a��8���a�e �����t
\  *   ����  �B     �C	   �D	  �E	 �F	�G     �H     �I
   0 ,	0 , 0102 , 0103 , 020B , 0104 , 050E , 0514 , 0105 , 0107 ,
\  �J	  �K	 �L	�M     �N     �O     �P     �Q	   *	�S
  0902 , 0908 , 0909 , 090B , 0912 , 0913 , 0914 , 0108 ,  0 , 0109 ,
\  �T	  �U	 �V	�W     �X     �Y     �Z     �[	   �\	  �]
  130B , 010B , 010C , 010D , 010E , 0110 , 0111 , 0112 , 0113 , 0114 ,

CREATE �A����>�s�hñ�a	\ �A�� �s�hñ�i �e�i�� ���e �������e �s�hñ�t, �a���e 0
\ *   ����   �A   �A   �A   �A	 �A   �A   �A	 �A    �A
  0 C, 0 C, 0A C, 0 C, 0 C, 0 C, 0 C, 0 C, 0B C, 0C C, 0 C,
\ �A	�A   �A   �A   �A   �A	 �A   �A    �A	  �A
  0D C, 0 C, 0 C, 0 C, 0 C, 0 C, 0 C, 0E C, 0F C, 10 C,  ALIGN

CREATE �s>ѻ�����a  \ �s�����A ��Ё �|ѻ�����t, �s������ �a���e 0
\   *	*   ���� �a   ��   ��	��   ��    *	*
   0 C, 0 C, 0 C, 0 C, 0 C, 0 C, 0 C, 0 C, 0 C, 0 C,
\ �A   �a   ��	  ��   ��    ��    *	*    �A    �a
   0 C, 0 C, 0 C, 0 C, 0D C, 0D C, 0 C, 0 C, 0D C, 0 C,
\ ��   ��    ��    ��	 *    *    �A	�a   ��   ��
  0 C, 14 C, 14 C, 14 C, 0 C, 0 C, 0 C, 0 C, 1B C, 0 C,

: ����>�s����? ( ���� -- ���� 0 | �s���� -1 )
    DUP ���Ŭ��a���� = IF
	DUP CHARS ����>�s�����a + C@ 1 = IF 1+ -1 EXIT THEN  THEN
    0 ;
: �s����?  ( ���� -- 0 | 16���a�e�i�a )
    ����>�s����? IF   �����a�� ���b����
		 ELSE ���Ŭ��a @ SWAP ����!  �����a�� THEN ;
: ����>�hñ?  ( ���� -- ���� 0 | �hñ -1 )
	DUP CHARS  ����>�hñ�a + C@ DUP IF NIP -1 EXIT THEN ;
: �A����>�s�hñ   ( ���� -- 0|�s�hñ )	 CHARS	�A����>�s�hñ�a + C@ ;
: �s>ѻ����   ( ���� -- 0|ѻ���� )   CHARS  �s>ѻ�����a + C@ ;
: �s>�|ѻ�hñ ( �hñ -- 0|ѻ�hñ )
	CELLS  �hñ>ѻ�hñ�����a +  @  8 RSHIFT  DUP �����hñ <>  AND ;
: �hñ>�hñ����  ( �hñ -- �hñ ���� )
	CELLS �hñ>ѻ�hñ�����a + @  DUP 8 RSHIFT  SWAP 0FF AND ;

\ �}�����a �A, �A, �A���e �Ŭ�, �a���e �hñ�A ���� ����
: �hñ?  ( ���� -- 0 | 16���a�e�i�a )
    ����>�hñ?	IF   �hñ�a��  ���b����
		ELSE ���Ŭ��a @  SWAP  ����!  �����a��	THEN ;
: >3?  ( -- 3|4 )   ���Ŭ��a����  �s>ѻ���� 0= ( -1|0) 4 + ;
: >5?  ( -- 2|5 )   ���Ŭ��a�hñ  �����hñ = ( -1|0) 3 * 5 + ;
: >6?  ( -- 2|6 )   ���Ŭ��a�hñ  �����hñ = ( -1|0) 2* 2* 6 + ;

: ����>�s�hñ?	( ���� -- ���� 0 | �s�hñ -1 )
    ���Ŭ��a�hñ
    CASE
      ( �B) 02 OF DUP ( �A) 0B = IF DROP 04 -1 EXIT THEN  ENDOF
      ( �S) 13 OF DUP ( �A) 0B = IF DROP 14 -1 EXIT THEN  ENDOF
      ( �E) 05 OF DUP ( �A) 0E = IF DROP 06 -1 EXIT THEN
		  DUP ( �A) 14 = IF DROP 07 -1 EXIT THEN  ENDOF
      ( �I) 09 OF DUP �A����>�s�hñ ?DUP IF NIP -1 EXIT THEN  ENDOF
    ENDCASE  0 ;

: �s�hñ?  ( ���� -- 0 | 16���a�e�i�a )
	����>�s�hñ? IF  �hñ�a�� ���b����  ELSE  ��+��  THEN ;
: ѻ�hñ  ( ���A -- 0 )
	DROP  ���Ŭ��a�hñ  �s>�|ѻ�hñ �hñ�a��  ���b���� ;

: ����>�s����?	( ���� -- ���� 0 | �s���� -1 )
    ���Ŭ��a����
    CASE
      ( �a) 1B OF DUP ( ��) 1D = IF DROP 1C -1 EXIT THEN
		  0 EXIT				    ENDOF
      ( ��) 0D OF DUP ( �a) 03 = IF DROP 0E -1 EXIT THEN
		  DUP ( ��) 04 = IF DROP 0F -1 EXIT THEN
		  DUP ( ��) 1D = IF DROP 12 -1 EXIT THEN
		  0 EXIT				    ENDOF
      ( ��) 14 OF DUP ( ��) 07 = IF DROP 15 -1 EXIT THEN
		  DUP ( �A) 0A = IF DROP 16 -1 EXIT THEN
		  DUP ( ��) 1D = IF DROP 17 -1 EXIT THEN
		  0 EXIT				    ENDOF
    ENDCASE  0 ;

: �s����?  ( ���� -- 0 | 16���a�e�i�a )
	����>�s����? IF  �����a�� ���b����  ELSE  ��+��  THEN ;
: ѻ����  ( ���A -- 0 )
	DROP  ���Ŭ��a����  �s>ѻ���� �����a��	���b���� ;

\ ���Ŭ��a�A�� �hñ�i �� �i�a�i �Ŭ��a�� ��������
\ �a �hñ�i ���Ŭ��a�� �����A ���� �����i ���Ŭ��a�A ���q
: ��+����  ( ���� -- 16���a�a )
    ���Ŭ��a�hñ �hñ>�hñ����		\ ���� ���hñ ����
    SWAP �hñ�a�� ���Ŭ��a @		\ ���� ���� 16���a�e�i�a
    ����!  SWAP �����a�� 2 �wȁ���� �|�a����  SWAP �����a�� ;

CREATE �w�A>�e�i�a
\  a>�A  b>�A  c>�A  d>�A  e>�A  f>�A  g>�A  h>��  i>��  j>��
   308 , 41A , 310 , 30D , 305 , 307 , 314 , 40D , 405 , 407 ,
\  k>�a  l>��  m>�a  n>��  o>��  p>�A  q>�A  r>�A  s>�A  t>�A
   403 , 41D , 41B , 414 , 404 , 40A , 309 , 302 , 304 , 30B ,
\  u>�a  v>�A  w>�A  x>�A  y>�a  z>�A
   40B , 313 , 30E , 312 , 413 , 311 ,

CREATE �w���A>�e�i�a
\  A>A	 B>B   C>C   D>D   E>�A  F>F   G>G   H>H   I>I	 J>J
   041 , 042 , 043 , 044 , 306 , 046 , 047 , 048 , 049 , 04A ,
\  K>K	 L>L   M>M   N>N   O>��  P>��  Q>�A  R>�A  S>S	 T>�A
   04B , 04C , 04D , 04E , 406 , 40C , 30A , 303 , 053 , 30C ,
\  U>U	 V>V   W>�A  X>X   Y>Y	 Z>Z
   055 , 056 , 30F , 058 , 059 , 05A ,

\ EKEY �� �h�e �t�A�� �i�A�� ���A�i '>�i�a-2�鯢'�� ��
\ 2�鯢�A�� �i�A ���A�e �a�� �a��:
\ �e�w�a��(1), ���A(2), �}����(3), ѩ����(4), �a�ỡ(0)
: >�i�A�t�����A-2�鯢  ( �i�A�t -- �i�A�t' ���A )
   0FF AND						\ special key �e ����
   DUP BL = �E�����A����? AND IF DROP 0 1 EXIT THEN	\ �e�w�a���i�A���e 0 1
   DUP ���A=  IF DROP 8 2 EXIT THEN			\ ���i�A���e
   DUP [CHAR] A [CHAR] Z 1+ WITHIN �i�A���b�wȁ @ AND IF \ �e�i���b���� A-Z ���e
	[CHAR] A -  CELLS   �w���A>�e�i�a
	[ �w�A>�e�i�a �w���A>�e�i�a - ] LITERAL CapsLock? AND
	+ + @  DUP 0FF AND SWAP 8 RSHIFT EXIT			THEN
   DUP [CHAR] a [CHAR] z 1+ WITHIN �i�A���b�wȁ @ AND IF \ �e�i���b���� a-z ���e
	[CHAR] a -  CELLS   �w�A>�e�i�a
	[ �w���A>�e�i�a �w�A>�e�i�a - ] LITERAL CapsLock? AND
	+ + @  DUP 0FF AND SWAP 8 RSHIFT EXIT			THEN
   0 ;					\ �a�ỡ

\ 2�鯢 �a�e �wȁ
\  0 : �w�� ���b
\  1 : �e�i���b ���b
\  2 : ���� ���b
\  3 : ����+���� ���b ( �����A ���� �i�a�� ��w )
\  4 : ����+�s���� ���b ( �����A ���� �i�a�� ��w )
\  5 : ����+����+�hñ ���b
\  6 : ����+����+�s�hñ ���b
5 �e ��ɡ�a�a: >�i�a-2�鯢
\ ���b|   �a�ỡ?  | �e�w�a��?	|   ���A?    |	  �}����?    |	 ѩ����?   |
\ �wȁ----------------------------------------------------------------------
 ( 0) | �a��  | >0 | ����! | >1 | �a�� | >0  | �a��    | >0  | �a��    | >0
 ( 1) | �a��  | >1 | �a��  | >0 | �a�� | >1  | ����!   | >2  | ����!   | >3
 ( 2) | ��+ch | >1 | �Ŭ�  | >0 | �ᝡ | >�� | �s����? | >2  | ����!   | >3
 ( 3) | ��+ch | >1 | �Ŭ�  | >0 | �ᝡ | >�� | �hñ?   | >5? | �s����? | >3?
 ( 4) | ��+ch | >1 | �Ŭ�  | >0 | �ᝡ | >�� | �hñ?   | >5? | ��+��   | >3
 ( 5) | ��+ch | >1 | �Ŭ�  | >0 | �ᝡ | >�� | �s�hñ? | >6? | ��+���� | >3
 ( 6) | ��+ch | >1 | �Ŭ�  | >0 | �ᝡ | >�� | ��+��   | >2  | ��+���� | >3
;��ɡ�a�a

\
\  3�鯢 �a�e ���b�A ϩ�a�e �{�i�i
\

CREATE �A�hñ>�s�hñ�a	\ �A�� �s�hñ�i �e�i�� ���e �hñ���e �s�hñ�t, �a���e 0
\  *   ����   �B    �C	  �D	�E    �F    �G	  �H	�I
   0 C,  0 C, 0A C,  0 C,  0 C,  0 C,  0 C,  0 C,  0 C,  0 C,
\ �J	�K    �L    �M	  �N	�O    �P    �Q	   *	�S
   0 C,  0 C,  0 C,  0 C,  0 C,  0 C,  0 C, 0B C,  0 C, 0C C,
\ �T	�U    �V    �W	  �X	�Y    �Z    �[	  �\	�]
   0 C, 0D C,  0 C,  0 C,  0 C,  0 C,  0 C, 0E C, 0F C, 10 C, ALIGN

: �hñ!    ( �hñ -- 0 )	  �hñ�a�� ���b���� ;
: ��+�hñ  ( �hñ -- 16���a�a )   ���Ŭ��a @  ����!  SWAP �hñ�a�� ;
: �A�hñ>�s�hñ  ( �hñ -- 0|�s�hñ )	CHARS  �A�hñ>�s�hñ�a + C@ ;
: �hñ>�s�hñ?	( �hñ -- �hñ 0 | �s�hñ -1 )
    ���Ŭ��a�hñ
    CASE
      ( �B) 02 OF DUP ( �B) 02 = IF DROP 03 -1 EXIT THEN
		      ( �U) 15 = IF DROP 04 -1 EXIT THEN  ENDOF
      ( �S) 13 OF DUP ( �U) 15 = IF DROP 14 -1 EXIT THEN  ENDOF
      ( �U) 15 OF DUP ( �U) 15 = IF DROP 16 -1 EXIT THEN  ENDOF
      ( �E) 05 OF DUP ( �X) 18 = IF DROP 06 -1 EXIT THEN
		  DUP ( �]) 1D = IF DROP 07 -1 EXIT THEN  ENDOF
      ( �I) 09 OF DUP �A�hñ>�s�hñ ?DUP IF NIP -1 EXIT THEN  ENDOF
    ENDCASE  0 ;
: �s�hñ?  ( �hñ -- 0 | 16���a�e�i�a )
	�hñ>�s�hñ? IF  �hñ�a�� ���b����  ELSE  ��+�hñ  THEN ;

CREATE 3��A>�e�i�a
\  !>�X  ">"   #>#   $>$   %>%   &>&   '>�A  (>(   )>)   *>*   +>+   ,>,
   518 , 022 , 023 , 024 , 025 , 026 , 312 , 028 , 029 , 02A , 02B , 02C ,
\  ->-	 .>.   />��  0>�A  1>�]  2>�V  3>�S  4>�a  5>�A  6>��  7>��  8>��
   02D , 02E , 40D , 311 , 51D , 516 , 513 , 413 , 41A , 405 , 40C , 41C ,
\  9>��  :>:   ;>�A  <>2   =>=	 >>3   ?>?   @>@   A>�H  B>!   C>�K  D>�J
   414 , 03A , 309 , 032 , 03D , 033 , 03F , 040 , 508 , 021 , 50B , 50A ,
\  E>�Z  F>�C  G>/   H>'   I>8   J>4   K>5   L>6   M>1   N>0   O>9   P>>
   51A , 503 , 02F , 027 , 038 , 034 , 035 , 036 , 031 , 030 , 039 , 03E ,
\  Q>�\  R>��  S>�G  T>;   U>7	 V>�P  W>�[  X>�T  Y>8	 Z>�Y  [>[   \>\
   51C , 406 , 507 , 03B , 037 , 510 , 51B , 514 , 038 , 519 , 05B , 05C ,
\  ]>]	 ^>^   _>_   `>`   a>�W  b>��  c>�A  d>��  e>�a  f>�a  g>�a  h>�A
   05D , 05E , 05F , 060 , 517 , 414 , 40A , 41D , 40B , 403 , 41B , 304 ,
\  i>�A  j>�A  k>�A  l>�A  m>�A  n>�A  o>�A  p>�A  q>�U  r>��  s>�E  t>��
   308 , 30D , 302 , 30E , 314 , 30B , 310 , 313 , 515 , 404 , 505 , 407 ,
\  u>�A  v>��  w>�I  x>�B  y>�A  z>�Q  {>{   |>|   }>}	 ~>~
   305 , 40D , 509 , 502 , 307 , 511 , 07B , 07C , 07D , 07E ,

\ EKEY �� �h�e �t�A�� �i�A�� ���A�i '>�i�a-3�鯢'�a�� ��
\ 3�鯢�A�� �i�A ���A�e �a�� �a��:
\   �e�w�a��(1), ���A(2), ����(3), ����(4), �hñ(5), �a�ỡ(0)
: >�i�A�t�����A-3�鯢  ( �i�A�t -- �i�A�t' ���A )
   0FF AND						\ special key �e ����
   DUP BL = �E�����A����? AND IF DROP 0 1 EXIT THEN	\ �e�w�a���i�A���e 0 1
   DUP ���A=  IF DROP 8 2 EXIT THEN			\ ���i�A���e
   DUP BL > 0= IF 0 EXIT THEN				\ �A�ᢅ�a�a ���e���e
   �i�A���b�wȁ @ 0= IF 0 EXIT THEN			\ �w�����b
   CapsLock? IF
       DUP [CHAR] A [CHAR] Z 1+ WITHIN IF
	   [ CHAR a CHAR A - ] LITERAL +
       ELSE DUP [CHAR] a [CHAR] z 1+ WITHIN IF
	   [ CHAR A CHAR a - ] LITERAL +    THEN THEN THEN
   [CHAR] ! - CELLS 3��A>�e�i�a + @
   DUP 0FF AND SWAP 8 RSHIFT ;

\ 3�鯢 �a�e �wȁ
\  0 : �w�� ���b
\  1 : �e�i���b ���b
\  2 : ���� ���b
\  3 : ����+���� ���b ( �����A ���� �i�a�� ��w )
\  4 : ����+�s���� ���b ( �����A ���� �i�a�� ��w )
\  5 : ����+����+�hñ ���b
\  6 : ����+����+�s�hñ ���b
6 �e ��ɡ�a�a: >�i�a-3�鯢
\ ���b|   �a�ỡ?  | �e�w�a��?	|   ���A?    |	   ����?    |	 ����?	    |	�hñ?	   |
\ �wȁ--------------------------------------------------------------------------------------
 ( 0) | �a��  | >0 | ����! | >1 | �a�� | >0  | �a��    | >0 | �a��    | >0  | �a��     | >0
 ( 1) | �a��  | >1 | �a��  | >0 | �a�� | >1  | ����!   | >2 | ����!   | >3  | �hñ!    | >5
 ( 2) | ��+ch | >1 | �Ŭ�  | >0 | �ᝡ | >�� | �s����? | >2 | ����!   | >3  | �hñ!    | >5
 ( 3) | ��+ch | >1 | �Ŭ�  | >0 | �ᝡ | >�� | ��+��   | >2 | �s����? | >3? | �hñ!    | >5
 ( 4) | ��+ch | >1 | �Ŭ�  | >0 | �ᝡ | >�� | ��+��   | >2 | ��+��   | >3  | �hñ!    | >5
 ( 5) | ��+ch | >1 | �Ŭ�  | >0 | �ᝡ | >�� | ��+��   | >2 | ��+��   | >3  | �s�hñ?  | >5?
 ( 6) | ��+ch | >1 | �Ŭ�  | >0 | �ᝡ | >�� | ��+��   | >2 | ��+��   | >3  | ��+�hñ  | >5
;��ɡ�a�a

' >�i�a-2�鯢         VALUE '>�i�a
' >�i�A�t�����A-2�鯢 VALUE '>�i�A�t�����A
: >�i�a 	  '>�i�a         EXECUTE ;
: >�i�A�t�����A   '>�i�A�t�����A EXECUTE ;

NONSTANDARD-WORDLIST SET-CURRENT
: 2BUL ( -- )
    ['] >�i�a-2�鯢         TO '>�i�a
    ['] >�i�A�t�����A-2�鯢 TO '>�i�A�t�����A ;
: 3BUL ( -- )
    ['] >�i�a-3�鯢         TO '>�i�a
    ['] >�i�A�t�����A-3�鯢 TO '>�i�A�t�����A ;
�e�i���b-WORDLIST SET-CURRENT

: HEKEY
   �i�Aɷ @ ?DUP IF		\ �i�Aɷ�A �i�a�a ���a�e �a �i�a�i ����
     DUP 0FF00 AND		\ �i�Aɷ�A �� �i�a�a ���a�e �� 8 ���a�i ����
     IF DUP 8 RSHIFT
	SWAP 0FF AND
	�i�Aɷ ! EXIT THEN
     0 �i�Aɷ ! EXIT  THEN	\ �i�Aɷ�� �e �i�a�i ����
   ���Ŭ��a @  �����a  <>  �i�A���b�wȁ @  AND	IF  ���Ŭ��a���a  THEN
   BEGIN  BEGIN PAUSE RX? UNTIL  RX@  >�i�A�t�����A  >�i�a  ?DUP UNTIL
	\ BEGIN ... UNTIL �i �a�a �a�� �� �ᣡ�A �q�e �t�e
	\   8 ���a : �e �i�a : �a��
	\  16 ���a : �� �i�a : �Ŭ� , ��+�� , ��+���� , ...
	\  16 ���a : �A �i�a : �Ŭ�+ch ( char �t�e �i�Aɷ �A �i�� ���q )
   DUP 0FF00 AND IF		\ 16���a �e�i�a���e �a�ỡ �i�a�i �i�Aɷ�A �q�q
     DUP 8 RSHIFT SWAP 0FF AND	\ �ᣡ: ��8���a �a��8���a
     �i�Aɷ @ ?DUP IF		\ �ᣡ: ��8���a �a��8���a char
       SWAP 8 LSHIFT OR THEN
     �i�Aɷ !
   THEN ;

: HEKEY?
    ���Ŭ��a @ �����a <> �i�Aɷ @ OR IF -1 ELSE RX? THEN ;

: SET-TEXT-I/O	( -- )
    ['] RX? TO 'ekey?
    ['] RX@ TO 'ekey
    ['] TX! TO 'emit ;

: SET-HGRAPHIC-I/O
    ['] HEKEY? TO 'ekey?
    ['] HEKEY  TO 'ekey
    ['] HEMIT  TO 'emit ;

NONSTANDARD-WORDLIST SET-CURRENT

DECIMAL VARIABLE �q�b��
0 60 CELLS 60 CELLS HAT multiI/O  multiI/O BUILD
0 60 CELLS 60 CELLS HAT HCURSOR   HCURSOR BUILD

: TEXT
    textmode# SET-MODE
    SET-TEXT-I/O
    0 TO GRAPHIC?
    multiI/O SLEEP  HCURSOR SLEEP ;

HEX
CODE ReadClockCount  ( -- ud )
    BX PUSH,
    AX AX XOR,	\ MOV AH,00
    1A INT,
    DX PUSH,
    CX BX MOV,
    NEXT,
END-CODE

DECIMAL
: �q�b������  ( -- )
    ReadClockCount
    BEGIN 2DUP DNEGATE ReadClockCount D+ DROP UNTIL 2DROP
    ReadClockCount
    -1 0 DO PAUSE 0 0 BL EFONT! 0 0 BL EFONT!
	    2DUP DNEGATE ReadClockCount D+ DROP
	    IF 2DROP I �q�b�� ! UNLOOP EXIT THEN LOOP
    2DROP -1 �q�b�� ! ;

: HGRAPHIC
    VGA? IF
	3 TO textmode#
	['] VGA-SET-GRAPHIC TO 'SET-GRAPHIC
	VGA-Y>SegTable Y>SegTable !
	30 TO MAX-Y		\ 640X480 Ё�w��; 480 / 16 = 30 ��
    ELSE HERC? IF
	7 TO textmode#
	['] HERC-SET-GRAPHIC TO 'SET-GRAPHIC
	HERC-Y>SegTable Y>SegTable !
	25 TO MAX-Y		\ 640X400 Ё�w��; 400 / 16 = 25 ��
	MAX-Y 0 DO 1 MAX-X* 0 DO I J BL EFONT! LOOP LOOP
    ELSE SET-TEXT-I/O  0 TO GRAPHIC?
	 ." Korean characters can be displayed only on VGA or Hercules Graphics screen."
	 multiI/O SLEEP HCURSOR SLEEP EXIT
    THEN THEN
    VSCREEN VSCREEN-SIZE CHARS BL FILL
    SET-GRAPHIC
    0 HCHAR !
    0 �i�A���b�wȁ !
    0 �i�Aɷ !
    ����!
    0 VSCR0 !
    0 YY !  0 VIR_Y !
    0 XX !  0 VIR_X !
    SET-HGRAPHIC-I/O
    multiI/O AWAKE  HCURSOR SLEEP  �q�b������  HCURSOR AWAKE ;

�e�i���b-WORDLIST SET-CURRENT

: NEW-SET-I/O
    GRAPHIC? IF SET-HGRAPHIC-I/O ELSE SET-TEXT-I/O THEN ;

HEX
: NEW-hi
    DOSCommand>PAD
    GET-MODE TO OldMode# HGRAPHIC hi
    ." ���e�� �A�e�� ���w�i �� ����U �����a �a���I wykoh�� ���� ��������." CR
    S" BLOCKS.BLK" MAPPED-TO-BLOCK  QUIT ;

' NEW-SET-I/O TO 'init-i/o
' NEW-hi TO 'boot

: XX+!	( n -- )
   XX @ + MAX-X /MOD YY +! XX ! ;

FALSE VALUE SCREEN-UPDATED?

HEX
:NONAME multiI/O ACTIVATE
	BEGIN
	   PAUSE
	   YY @ MAX-X* XX @ + DUP VIR_Y @ MAX-X* VIR_X @ + <	IF
	      FALSE TO SCREEN-UPDATED?
	      YY @ VIR_Y @ < IF YY @ 1+ MAX-X*
			     ELSE VIR_Y @ MAX-X* VIR_X @ + THEN
	      SWAP
	      BEGIN DUP >VSCR-ADDR C@
		    DUP 80 <				IF
			 XX @ YY @ ROT EFONT! 1 XX+!	ELSE
			 8 LSHIFT >R
			 CHAR+ DUP >VSCR-ADDR C@ R> OR
			 XX @ YY @ ROT HFONT! 2 XX+!	THEN
	      CHAR+ 2DUP > 0= UNTIL 2DROP			ELSE
	      TRUE TO SCREEN-UPDATED?
	      DROP VIR_X @ XX ! VIR_Y @ YY !			THEN
	AGAIN
; EXECUTE

:NONAME HCURSOR ACTIVATE
	BEGIN
	  �q�b�� @ 0 DO PAUSE LOOP
	  SCREEN-UPDATED?				    IF
	    GRAPHIC?					IF
		�i�A���b�wȁ @	?DUP		   IF
		    1-			  IF
		    ���Ŭ��a���a	  ELSE
		    XX @ YY @ [CHAR] _ EFONT! THEN ELSE
		    XX @ YY @ [CHAR] - EFONT!	   THEN THEN
	    �q�b�� @ 0 DO PAUSE LOOP
	    GRAPHIC?				   IF
		XX @ YY @ BL EFONT!
		�i�A���b�wȁ @		      IF
		    XX @ CHAR+ YY @ BL EFONT! THEN THEN     THEN
	AGAIN
; EXECUTE

�e�i���b-WORDLIST SET-CURRENT

HEX
CODE textAT-XY	( column row -- )
    2 # AH MOV,
    DX POP,
    BL DH MOV,
    BX BX XOR,
    10 INT,
    BX POP,
    NEXT,
END-CODE

FORTH-WORDLIST SET-CURRENT

\   AT-XY	( u1 u2 -- )			\ FACILITY
\		Perform implementation-dependent steps so that the next
\		character displayed will appear in column u1, row u2 of the
\		user output device, the upper left corner of which is column
\		zero, row zero.  An ambiguous condition exists if the
\		operation cannot be performed on the user output Adevice
\		with the specified parameters.
: AT-XY
   GRAPHIC? IF DUP YY ! VIR_Y ! DUP XX ! VIR_X !
   ELSE textAT-XY THEN ;

\   PAGE	( -- )				\ FACILITY
\		Move to another page for output. Actual function depends on
\		the output device.  On a terminal, PAGE clears the screen
\		and resets the cursor position to the upper left corner. On
\		a printer, PAGE performs a form feed.
DECIMAL
: PAGE
    GRAPHIC? IF MAX-Y 0 DO 1 MAX-X* 0 DO
		    BL J MAX-X* I + >VSCR-ADDR C!  I J BL EFONT!
		LOOP LOOP
		0 TO YTop
    ELSE 0 0 AT-XY 25 0 DO 80 0 DO BL EMIT LOOP LOOP
    THEN 0 0 AT-XY ;

: BYE	OldMode# SET-MODE  BYE ;

HGRAPHIC

SET-CURRENT  SET-ORDER
BASE !
