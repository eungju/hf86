\
\ TURTLE.F
\ Turtle graphics package for hForth
\
\ English and Korean sources are provided (See [IF] ... [ELSE] ... [THEN]).
\
\ ETURTLE.EXE and HTURTLE.EXE is built from HF86EXE.EXE by loading Forth
\   sources in the following order.
\
\	<< OPTIONAL.F
\	<< ASM8086.F
\	<< COREEXT.F
\	<< MSDOS.F
\	BL PARSE MULTI.F    INCLUDED
\	BL PARSE HIOMULT2.F INCLUDED
\	BL PARSE TURTLE.F   INCLUDED
\	SAVE-SYSTEM-AS ETURTLE.EXE
\	( or SAVE-SYSTEM-AS HTURTLE.EXE )
\
\ 1996. 2. 21.
\ Wonyong Koh

BASE @
GET-ORDER  GET-CURRENT
WORDLIST WORDLIST-NAME GRAPHIC-WORDLIST
�e�i���b-WORDLIST GRAPHIC-WORDLIST GET-ORDER 2 + SET-ORDER

MARKER ~TURTLE

DECIMAL
CREATE sin16384
     0 ,    286 ,    572 ,    857 ,   1143 ,   1428 ,	1713 ,	 1997 ,   2280 ,   2563 ,
  2845 ,   3126 ,   3406 ,   3686 ,   3964 ,   4240 ,	4516 ,	 4790 ,   5063 ,   5334 ,
  5604 ,   5872 ,   6138 ,   6402 ,   6664 ,   6924 ,	7182 ,	 7438 ,   7692 ,   7943 ,
  8192 ,   8438 ,   8682 ,   8923 ,   9162 ,   9397 ,	9630 ,	 9860 ,  10087 ,  10311 ,
 10531 ,  10749 ,  10963 ,  11174 ,  11381 ,  11585 ,  11786 ,	11982 ,  12176 ,  12365 ,
 12551 ,  12733 ,  12911 ,  13085 ,  13255 ,  13421 ,  13583 ,	13741 ,  13894 ,  14044 ,
 14189 ,  14330 ,  14466 ,  14598 ,  14726 ,  14849 ,  14968 ,	15082 ,  15191 ,  15296 ,
 15396 ,  15491 ,  15582 ,  15668 ,  15749 ,  15826 ,  15897 ,	15964 ,  16026 ,  16083 ,
 16135 ,  16182 ,  16225 ,  16262 ,  16294 ,  16322 ,  16344 ,	16362 ,  16374 ,  16382 ,
 16384 ,  16382 ,  16374 ,  16362 ,  16344 ,  16322 ,  16294 ,	16262 ,  16225 ,  16182 ,
 16135 ,  16083 ,  16026 ,  15964 ,  15897 ,  15826 ,  15749 ,	15668 ,  15582 ,  15491 ,
 15396 ,  15296 ,  15191 ,  15082 ,  14968 ,  14849 ,  14726 ,	14598 ,  14466 ,  14330 ,
 14189 ,  14044 ,  13894 ,  13741 ,  13583 ,  13421 ,  13255 ,	13085 ,  12911 ,  12733 ,
 12551 ,  12365 ,  12176 ,  11982 ,  11786 ,  11585 ,  11381 ,	11174 ,  10963 ,  10749 ,
 10531 ,  10311 ,  10087 ,   9860 ,   9630 ,   9397 ,	9162 ,	 8923 ,   8682 ,   8438 ,
  8192 ,   7943 ,   7692 ,   7438 ,   7182 ,   6924 ,	6664 ,	 6402 ,   6138 ,   5872 ,
  5604 ,   5334 ,   5063 ,   4790 ,   4516 ,   4240 ,	3964 ,	 3686 ,   3406 ,   3126 ,
  2845 ,   2563 ,   2280 ,   1997 ,   1713 ,   1428 ,	1143 ,	  857 ,    572 ,    286 ,
     0 ,   -286 ,   -572 ,   -857 ,  -1143 ,  -1428 ,  -1713 ,	-1997 ,  -2280 ,  -2563 ,
 -2845 ,  -3126 ,  -3406 ,  -3686 ,  -3964 ,  -4240 ,  -4516 ,	-4790 ,  -5063 ,  -5334 ,
 -5604 ,  -5872 ,  -6138 ,  -6402 ,  -6664 ,  -6924 ,  -7182 ,	-7438 ,  -7692 ,  -7943 ,
 -8192 ,  -8438 ,  -8682 ,  -8923 ,  -9162 ,  -9397 ,  -9630 ,	-9860 , -10087 , -10311 ,
-10531 , -10749 , -10963 , -11174 , -11381 , -11585 , -11786 , -11982 , -12176 , -12365 ,
-12551 , -12733 , -12911 , -13085 , -13255 , -13421 , -13583 , -13741 , -13894 , -14044 ,
-14189 , -14330 , -14466 , -14598 , -14726 , -14849 , -14968 , -15082 , -15191 , -15296 ,
-15396 , -15491 , -15582 , -15668 , -15749 , -15826 , -15897 , -15964 , -16026 , -16083 ,
-16135 , -16182 , -16225 , -16262 , -16294 , -16322 , -16344 , -16362 , -16374 , -16382 ,
-16384 , -16382 , -16374 , -16362 , -16344 , -16322 , -16294 , -16262 , -16225 , -16182 ,
-16135 , -16083 , -16026 , -15964 , -15897 , -15826 , -15749 , -15668 , -15582 , -15491 ,
-15396 , -15296 , -15191 , -15082 , -14968 , -14849 , -14726 , -14598 , -14466 , -14330 ,
-14189 , -14044 , -13894 , -13741 , -13583 , -13421 , -13255 , -13085 , -12911 , -12733 ,
-12551 , -12365 , -12176 , -11982 , -11786 , -11585 , -11381 , -11174 , -10963 , -10749 ,
-10531 , -10311 , -10087 ,  -9860 ,  -9630 ,  -9397 ,  -9162 ,	-8923 ,  -8682 ,  -8438 ,
 -8192 ,  -7943 ,  -7692 ,  -7438 ,  -7182 ,  -6924 ,  -6664 ,	-6402 ,  -6138 ,  -5872 ,
 -5604 ,  -5334 ,  -5063 ,  -4790 ,  -4516 ,  -4240 ,  -3964 ,	-3686 ,  -3406 ,  -3126 ,
 -2845 ,  -2563 ,  -2280 ,  -1997 ,  -1713 ,  -1428 ,  -1143 ,	 -857 ,   -572 ,   -286 ,
    -0 ,    286 ,    572 ,    857 ,   1143 ,   1428 ,	1713 ,	 1997 ,   2280 ,   2563 ,
  2845 ,   3126 ,   3406 ,   3686 ,   3964 ,   4240 ,	4516 ,	 4790 ,   5063 ,   5334 ,
  5604 ,   5872 ,   6138 ,   6402 ,   6664 ,   6924 ,	7182 ,	 7438 ,   7692 ,   7943 ,
  8192 ,   8438 ,   8682 ,   8923 ,   9162 ,   9397 ,	9630 ,	 9860 ,  10087 ,  10311 ,
 10531 ,  10749 ,  10963 ,  11174 ,  11381 ,  11585 ,  11786 ,	11982 ,  12176 ,  12365 ,
 12551 ,  12733 ,  12911 ,  13085 ,  13255 ,  13421 ,  13583 ,	13741 ,  13894 ,  14044 ,
 14189 ,  14330 ,  14466 ,  14598 ,  14726 ,  14849 ,  14968 ,	15082 ,  15191 ,  15296 ,
 15396 ,  15491 ,  15582 ,  15668 ,  15749 ,  15826 ,  15897 ,	15964 ,  16026 ,  16083 ,
 16135 ,  16182 ,  16225 ,  16262 ,  16294 ,  16322 ,  16344 ,	16362 ,  16374 ,  16382 ,

CODE sin* ( length theta -- length*sin[theta] )
\ : sin*   CELLS sin16384 + @ M* 16384 SM/REM NIP ;
    BX 1 SHL,
    sin16384 [BX] BX MOV,
    AX POP,
    BX IMUL,
    BX BX XOR,
    AX 1 SHL,
    DX 1 RCL,
    AX 1 SHL,
    DX 1 RCL,
    DX BX ADC,
    NEXT,
END-CODE

CODE cos* ( length theta -- length*cos[theta] )
\ : cos*   90 + CELLS sin16384 + @ M* 16384 SM/REM NIP ;
    90 # BX ADD,
    BX 1 SHL,
    sin16384 [BX] BX MOV,
    AX POP,
    BX IMUL,
    BX BX XOR,
    AX 1 SHL,
    DX 1 RCL,
    AX 1 SHL,
    DX 1 RCL,
    DX BX ADC,
    NEXT,
END-CODE

HEX
\ : PLOT  ( x y -- )
\     Y>SEG SWAP 8 /MOD SWAP >R 	  \ seg_addr x/8  R: x_mod_8
\     2DUP LC@ R> CHARS XMASK + C@ OR ROT ROT LC! ;

CODE PLOT  ( x y -- )
    BX 1 SHL,
    Y>SegTable ) BX ADD,
    0 [BX] ES MOV,
    BX POP,
    BX CX MOV,
    BX 1 SHR,
    BX 1 SHR,
    BX 1 SHR,
    ES: 0 [BX] AL MOV,
    1 # AH MOV,
    CL NOT,
    7 # CL AND,
    AH CL ROL,
    AH AL OR,
    ES: AL 0 [BX] MOV,
    BX POP,
    NEXT,
END-CODE

\ : 2ROT
\     >R >R 2SWAP R> R> 2SWAP ;
\
\ : LINE  ( x1 y1 x2 y2--)
\     2OVER 2OVER ROT - ABS >R - ABS R> MAX 2 <
\     IF 2DROP PLOT EXIT THEN
\     2OVER 2OVER ROT + 1+ 2/ >R + 1+ 2/ R>
\     2DUP 2ROT RECURSE RECURSE ;

VARIABLE Delta
VARIABLE Delta/2

\ y changing faster than x
CODE steep640	\ on entry, ax = delta x, bx = delta y, cx=x1, dx=y1
    BX BP MOV,			\ for counter
    BX 1 SHR,
    BX Delta/2 ) MOV,		\ halfy
    BX BX XOR,			\ clear for cmp
6 L:
    BX PUSH,
    CX PUSH,		\ x
    DX BX MOV,
    BX 1 SHL,
    Y>SegTable ) BX ADD,
    0 [BX] ES MOV,
    CX BX MOV,
    BX 1 SHR,
    BX 1 SHR,
    BX 1 SHR,
    ES: 0 [BX] AL MOV,
    1 # AH MOV,
    CL NOT,
    7 # CL AND,
    AH CL ROL,
    AH AL OR,
    ES: AL 0 [BX] MOV,
    CX POP,
    BX POP,
    DX INC,			\ y is always increasing
    MAX-Y 16* # DX CMP,
    8 L# JL,
    DX DX XOR,
8 L:
    Delta ) BX ADD,		\ = bx + delta_y
    Delta/2 ) BX CMP,		\ bx > halfy ?
    7 L# JLE,
    SI BX SUB,			\ bx - delta_y
    DI CX ADD,			\ inc or dec x
    MAX-X 8 * # CX SUB,
    7 L# JNS,
    MAX-X 8 * # CX ADD,
    7 L# JNS,
    MAX-X 8 * # CX ADD,
7 L:
    BP DEC,
    6 L# JGE,
    BP POP,
    SI POP,
    BX POP,
    NEXT,
END-CODE

\ on exit, cx=x1, dx=y1, ax=x2, bx=y2
CODE line640  ( x1 y1 x2 y2 -- )	\ writes to screen directly
    AX POP,
    DX POP,
    CX POP,
    SI PUSH,   ( used to hold direction)
    BP PUSH,   ( used as counter)
\ see if we'll inc or dec x, y (draws in any direction)
    DX BX SUB,			\ bx <- y2-y1 (delta y)
    2 L# JGE,
    BX DX ADD,			\ dx <- y2
    BX NEG,			\ abs(delta y)
    CX AX XCHG,
2 L:
    BX SI MOV,			\ delta_y(BX) to SI
    CX AX SUB,			\ x2 - x1 = delta_x
    1 # DI MOV, 		\ di to increment x
    4 L# JGE,
    -1 # DI MOV,		\ di to decrement x
    AX NEG,			\ abs(delta x)
4 L:
    \ adjust x1(CX), y1(DX) in proper range
    AX PUSH,
    DX PUSH,
    CX AX MOV,
    CWD,
    MAX-X 8 * # BP MOV,
    BP IDIV,
    DX DX OR,
    1 L# JNS,
    BP DX ADD,
1 L:
    DX CX MOV,
    DX POP,
    DX AX MOV,
    CWD,
    MAX-Y 16* # BP MOV,
    BP IDIV,
    DX DX OR,
    8 L# JNS,
    BP DX ADD,
8 L:
    AX POP,
    AX Delta ) MOV,		\ abs(delta x)
    BX AX CMP,			\ delta_x - delta_y
    5 L# JGE,
    ' steep640 # JMP,		\ y changes faster than x
5 L:
\ x changing faster than y
    AX BP MOV,			\ for counter
    AX 1 SHR,
    AX Delta/2 ) MOV,		\ halfx
    BX BX XOR,			\ clear for cmp
6 L:
    BX PUSH,
    CX PUSH,		\ x
    DX BX MOV,
    BX 1 SHL,
    Y>SegTable ) BX ADD,
    0 [BX] ES MOV,
    CX BX MOV,
    BX 1 SHR,
    BX 1 SHR,
    BX 1 SHR,
    ES: 0 [BX] AL MOV,
    1 # AH MOV,
    CL NOT,
    7 # CL AND,
    AH CL ROL,
    AH AL OR,
    ES: AL 0 [BX] MOV,
    CX POP,
    BX POP,
    DI CX ADD,			\ inc or dec x
    MAX-X 8 * # CX SUB,
    9 L# JNS,
    MAX-X 8 * # CX ADD,
    9 L# JNS,
    MAX-X 8 * # CX ADD,
9 L:
    SI BX ADD,			\ = bx + delta_y
    Delta/2 ) BX CMP,		\ bx > halfx ?
    7 L# JLE,
    Delta ) BX SUB,		\ bx - delta_x
    DX INC,			\ y is always increasing
    MAX-Y 16* # DX CMP,
    7 L# JL,
    DX DX XOR,
7 L:
    BP DEC,
    6 L# JGE,
    BP POP,
    SI POP,
    BX POP,
    NEXT,
END-CODE

\ y changing faster than x
CODE xsteep640	 \ on entry, ax = delta x, bx = delta y, cx=x1, dx=y1
    BX BP MOV,			\ for counter
    BX 1 SHR,
    BX Delta/2 ) MOV,		\ halfy
    BX BX XOR,			\ clear for cmp
6 L:
    BX PUSH,
    CX PUSH,		\ x
    DX BX MOV,
    BX 1 SHL,
    Y>SegTable ) BX ADD,
    0 [BX] ES MOV,
    CX BX MOV,
    BX 1 SHR,
    BX 1 SHR,
    BX 1 SHR,
    ES: 0 [BX] AL MOV,
    1 # AH MOV,
    CL NOT,
    7 # CL AND,
    AH CL ROL,
    AH AL XOR,
    ES: AL 0 [BX] MOV,
    CX POP,
    BX POP,
    DX INC,			\ y is always increasing
    MAX-Y 16* # DX CMP,
    8 L# JL,
    DX DX XOR,
8 L:
    Delta ) BX ADD,		\ = bx + delta_y
    Delta/2 ) BX CMP,		\ bx > halfy ?
    7 L# JLE,
    SI BX SUB,			\ bx - delta_y
    DI CX ADD,			\ inc or dec x
    MAX-X 8 * # CX SUB,
    7 L# JNS,
    MAX-X 8 * # CX ADD,
    7 L# JNS,
    MAX-X 8 * # CX ADD,
7 L:
    BP DEC,
    6 L# JGE,
    BP POP,
    SI POP,
    BX POP,
    NEXT,
END-CODE

\ on exit, cx=x1, dx=y1, ax=x2, bx=y2
CODE xline640  ( x1 y1 x2 y2 -- )	 \ writes to screen directly
    AX POP,
    DX POP,
    CX POP,
    SI PUSH,   ( used to hold direction)
    BP PUSH,   ( used as counter)
\ see if we'll inc or dec x, y (draws in any direction)
    DX BX SUB,			\ bx <- y2-y1 (delta y)
    2 L# JGE,
    BX DX ADD,			\ dx <- y2
    BX NEG,			\ abs(delta y)
    CX AX XCHG,
2 L:
    BX SI MOV,			\ delta_y(BX) to SI
    CX AX SUB,			\ x2 - x1 = delta_x
    1 # DI MOV, 		\ di to increment x
    4 L# JGE,
    -1 # DI MOV,		\ di to decrement x
    AX NEG,			\ abs(delta x)
4 L:
    \ adjust x1(CX), y1(DX) in proper range
    MAX-X 8 * # CX SUB,
    1 L# JNS,
    MAX-X 8 * # CX ADD,
    1 L# JNS,
    MAX-X 8 * # CX ADD,
1 L:
    MAX-Y 16* # DX SUB,
    8 L# JNS,
    MAX-Y 16* # DX ADD,
    8 L# JNS,
    MAX-Y 16* # DX ADD,
8 L:
    AX Delta ) MOV,		\ abs(delta x)
    BX AX CMP,			\ delta_x - delta_y
    5 L# JGE,
    ' xsteep640 # JMP,		\ y changes faster than x
5 L:
\ x changing faster than y
    AX BP MOV,			\ for counter
    AX 1 SHR,
    AX Delta/2 ) MOV,		\ halfx
    BX BX XOR,			\ clear for cmp
6 L:
    BX PUSH,
    CX PUSH,		\ x
    DX BX MOV,
    BX 1 SHL,
    Y>SegTable ) BX ADD,
    0 [BX] ES MOV,
    CX BX MOV,
    BX 1 SHR,
    BX 1 SHR,
    BX 1 SHR,
    ES: 0 [BX] AL MOV,
    1 # AH MOV,
    CL NOT,
    7 # CL AND,
    AH CL ROL,
    AH AL XOR,
    ES: AL 0 [BX] MOV,
    CX POP,
    BX POP,
    DI CX ADD,			\ inc or dec x
    MAX-X 8 * # CX SUB,
    9 L# JNS,
    MAX-X 8 * # CX ADD,
    9 L# JNS,
    MAX-X 8 * # CX ADD,
9 L:
    SI BX ADD,			\ = bx + delta_y
    Delta/2 ) BX CMP,		\ bx > halfx ?
    7 L# JLE,
    Delta ) BX SUB,		\ bx - delta_x
    DX INC,			\ y is always increasing
    MAX-Y 16* # DX CMP,
    7 L# JL,
    DX DX XOR,
7 L:
    BP DEC,
    6 L# JGE,
    BP POP,
    SI POP,
    BX POP,
    NEXT,
END-CODE

\ Get a 'Y' or 'N' key. Return TURE for 'Y', otherwise return FALSE.
: Y/N?	( -- f )
   TRUE 		    \ leave TRUE flag
   BEGIN  KEY
      DUP  [CHAR] Y =
      OVER [CHAR] y = OR 0=
   WHILE
      DUP  [CHAR] N =
      OVER [CHAR] n = OR 0=
   WHILE DROP
   REPEAT   \ 'N' comes hear
      DROP FALSE SWAP
   THEN
	    \ 'Y' comes hear
   DROP ;

CR .( Will you use Turtle Graphics words in Korean? [Y/N] )
Y/N? [IF]

DECIMAL
10 CONSTANT scale
0 VALUE ������?
VARIABLE �wз
MAX-X 8 * 2/ VALUE xOffset
MAX-Y 16 * 2/ VALUE yOffset
VARIABLE xCoord  xOffset xCoord !
VARIABLE yCoord  yOffset yCoord !

: ���i�� ( -- )     FALSE TO ������? ;
: �����a ( -- )     TRUE  TO ������? ;
: �����e ( y -- )   MAX-Y SWAP - TO YTop ;
: �����e ( -- )     PAGE ;

: ��.�a�� ( x y -- )
    scale / yOffset SWAP -	    \ x y1
    SWAP scale / xOffset + SWAP     \ x1 y1
    ������? IF 2DUP xCoord @ yCoord @ line640 THEN
    yCoord !  xCoord ! ;

: �ᦂ���a ( -- )
    xCoord @  8 �wз @ 270 + sin* +
    yCoord @  8 �wз @ 270 + cos* -
    2DUP xCoord @ yCoord @ xline640		    \ x1 y1
    xCoord @  16 �wз @ sin* +
    yCoord @  16 �wз @ cos* -			    \ x1 y1 x2 y2
    2SWAP 2OVER xline640			    \ x2 y2
    xCoord @  8 �wз @ 90 + sin* +
    yCoord @  8 �wз @ 90 + cos* -		    \ x2 y2 x3 y3
    2SWAP 2OVER xline640			    \ x3 y3
    xCoord @  yCoord @	xline640 ;

: ���e���� ( -- )   YTop PAGE 0 OVER AT-XY TO YTop �ᦂ���a ;

HEX
: �{�e�i ( xt 'name2' -- )
    DUP xt>name ?DUP 0= IF -12 THROW THEN
    SWAP head, linkLast
    C@ DUP
    040 AND IF IMMEDIATE    THEN
    020 AND IF COMPILE-ONLY THEN ;

DECIMAL
' IMMEDIATE  �{�e�i  �a��
' RECURSE    �{�e�i  �A����
' IF	     �{�e�i  �e
' ELSE	     �{�e�i  �a���e
' THEN	     �{�e�i  �a
' BEGIN      �{�e�i  ���A����
' UNTIL      �{�e�i  �a��
' WHILE      �{�e�i  ���e
' REPEAT     �{�e�i  ��sЁ
' DO	     �{�e�i  ��
' LOOP	     �{�e�i  ���a
' I	     �{�e�i  �a
' CONSTANT   �{�e�i  ���e�t
' VARIABLE   �{�e�i  ���e�t
' DUP	     �{�e�i  �A�a
' OVER	     �{�e�i  ���
' DROP	     �{�e�i  ��a
' SWAP	     �{�e�i  �a��
' ROT	     �{�e�i  ���a
' >R	     �{�e�i  >�A
' R>	     �{�e�i  �A>
' R@	     �{�e�i  �A@
' AND	     �{�e�i  �{�q�A
' OR	     �{�e�i  �{�a����
' XOR	     �{�e�i  �{�a��
' MOD	     �{�e�i  �a�ỡ
' CR	     �{�e�i  �a�q��
' WORDS      �{�e�i  �i�a
' .S	     �{�e�i  .�ᣡ

' BYE	     �{�e�i  �{

���e�t �a����á
���e�t �A����á

: �A�a����   ( -- )
	�ᦂ���a
	0 �wз !
	0 �a����á !
	0 �A����á !
	0 0 ��.�a��
	�ᦂ���a ;

: ���e����   ( -- )
	���i�� �A�a���� ���e���� �����a ;

: �������e ( -- )    8 �����e  ���e���� ;
: �����e   ( -- )    �����e    ���e���� ;

: ��.���e��  ( �b�� -- )
	�ᦂ���a
	�wз @ +
	�A�a 0 < �e		     ( �b���a 0���a �b�a�e)
		   ���A���� 360 +    ( 0 ���w�� �I ���a�� 360�i ���q)
		   �A�a -1 > �a��
		 �a���e 360 �a�ỡ   ( 0���a �a�e 360�a�� �a�� �a�ỡ�i �q��)
		 �a
	�wз !
	�ᦂ���a ;

: ��.�E��     -1 * ��.���e�� ;

: �e�q.�a    ( dx dy -- )
	�ᦂ���a
	�A����á @ +		( dx y+dy )
	�A�a �A����á ! 	( dx y+dy )
	�a�� �a����á @ +	( y+dy x+dx )
	�A�a �a����á ! 	( y+dy x+dx )
	�a��			( x+dx y+dy )
	��.�a��
	�ᦂ���a ;

: �|�a��   ( l -- )
	�A�a			( l l )
	�wз @ sin*		( l dx )
	�a��			( dx l )
	�wз @ cos*		( dx dy )
	�e�q.�a  ;

: �ᝡ	   ( �១ -- )
	-1 *  �|�a�� ;

: __���e��.�ɍ�   ( �១ �U��  -- )
	0 ��   5 ��.���e��   �A�a �|�a��  5 ��.���e��	���a   ��a ;

: ���e��.�ɍ�	( �e���q �b�� -- )
	�a��  355 2034 */	( �b�� �១ ) ( �ɍ��i 10���� �a���� �a�� )
					( 2*pi*r*�b��/360*10 = pi*r*�b��/18 )
					( pi = 355/113 = 3.141593 )
	�A�a >�A			( �A���� �ᣡ�A �១�i �i����)
	���  10 /		( �b�� �១ �U�� )
	__���e��.�ɍ�		( �b�� )
	10 �a�ỡ		( �b��_�a�ỡ )
	�A�a �A>		( �b��_�a�ỡ �b��_�a�ỡ �១ )
	( 10�a�� �a�� �a�ỡ �b���A Ё�w�a�e �១�e�q �|�a�� �q)
	*  10 /  �|�a�� 	( �b��_�a�ỡ )
	��.���e��  ;

: ���e��.�� ( �e���q -- )   360 ���e��.�ɍ� ;

: __�E��.�ɍ�	( �១ �U��  -- )
	0 ��   5 ��.�E��   �A�a �|�a��	5 ��.�E��   ���a   ��a ;

: �E��.�ɍ�	( �e���q �b�� -- )
	�a��  355 2034 */	( �b�� �១ ) ( �ɍ��i 10���� �a���� �a�� )
					( 2*pi*r*�b��/360*10 = pi*r*�b��/18 )
	�A�a >�A			( �A���� �ᣡ�A �១�i �i����)
	���  10 /		( �b�� �១ �U�� )
	__�E��.�ɍ�		( �b�� )
	10 �a�ỡ		( �b��_�a�ỡ )
	�A�a �A>		( �b��_�a�ỡ �b��_�a�ỡ �១ )
	     ( 10�a�� �a�� �a�ỡ �b���A Ё�w�a�e �១�e�q �|�a�� �q)
	*  10 /  �|�a�� 	( �b��_�a�ỡ )
	��.�E��  ;

: �E��.�� ( �e���q -- )   360 �E��.�ɍ� ;

: �A��	 ( �a�� -- )
	4 0  ��   �A�a �|�a��	90 ��.���e��   ���a   ��a ;

: �så�A��   ( -- )
	100 �A��  200 �A��  300 �A��  400 �A�� ;

: �a���a���a   ( -- )
	45 ��.���e��
	4 0 ��	�så�A��  90 ��.���e��	���a ;

: ���i	 ( �a�� -- )
	�A�a �|�a��  �A�a �A��	�ᝡ ;

: �a�����i   ( �a�� -- )
	6 0 ��	�A�a ���i  60 ��.���e��  ���a ;

: �a�q����   ( -- )
	100 �a�����i  400 �a�����i ;

: ����	 ( �a�� -- )
	�A�a  90 ���e��.�ɍ�  90 ��.���e��
	      90 ���e��.�ɍ�  90 ��.���e�� ;

: ��	 ( �a�� -- )
	8 0 ��	 �A�a  ���� 45 ��.���e��   ���a   ��a ;

: �a�e����   ( �a�� -- )
	�A�a  60 ���e��.�ɍ�  120 ��.���e��
	      60 ���e��.�ɍ�  120 ��.���e�� ;

: �a�e��     ( �a�� -- )
	6 0 ��	 �A�a  �a�e���� 60 ��.���e��   ���a   ��a ;

: Е�i	 ( �a�� -- )
	�A�a  90 �E��.�ɍ�  �A�a 90 ���e��.�ɍ�
	�A�a  90 �E��.�ɍ�	 90 ���e��.�ɍ� ;

: Ё	 ( �a�� -- )
	9 0 ��	 �A�a Е�i  160 ��.���e��   ���a  ��a ;

: �b�w	   ( �a�� ���១�� -- )
	360 ��� /  �a��	( �a�� ��_�b�� ���១�� )
	0 ��  ��� �|�a��  �A�a ��.���e��  ���a
	��a ��a ;

: �i   ( �e��_�� �y�� -- )
	��� ��� *
	0 ��  600 �|�a��  ��� ��� 360 * �a�� / ��.���e��  ���a
	��a ��a ;

: �a�b�w   ( �a�� �b�� -- )
	�wз @ >�A		      ( �A�����ᣡ�A ��q �wз�i �i����)
	���A����
	   ��� �|�a�� �A�a ��.���e��
	�wз @	�A@ = �a��	      ( �wз�� ��q�wз�� �{�a�� ���a�� �AΉ��)
	��a ��a  �A> ��a ;	      ( �t�ᣡ�� �A���� �ᣡ�i ���� )

: �a�b�w�a�w5	 5 0 ��  450  72 �a�b�w  72 ��.���e��  ���a ;
: �a�b�w�a�w4	 4 0 ��  700 135 �a�b�w  90 ��.���e��  ���a ;
: �a�b�w�a�w12	12 0 ��  15 ��.���e��  ���i��  400 �|�a��  �����a
			 200 135 �a�b�w  15 ��.���e��  ���a ;

: �a��	 ( �a���b�� �a������ �a��á���� -- )
	>�A				( �a��á�����i �A�����ᣡ�A �i����)
	�A@ �e				( '�A@ 0 <> �e' �� �{�q)
	   ��� ��.�E��
	   �A�a 2 * �|�a��
	   ��� ��� �A@ 1 - �A����
	   �A�a 2 * �ᝡ
	   ��� 2 * ��.���e��
	   �A�a �|�a��
	   ��� ��� �A@ 1 - �A����
	   �ᝡ  ��.�E��
	�a���e	��a ��a �a
	�A> ��a ;

���e�t ���i�a��  20 ���i�a�� !
: �w   ( �a�� -- )
	�A�a  0 = �e  ���i�a�� @ �|�a��
	      �a���e  �A�a  0 > �e  �A�a 1 - �A����	(  �a��-1 �w )
				    90 ��.���e��
				    1 ��� - �A����	(  1-�a�� �w )
			    �a���e  -1 ��� - �A����	( -1-�a�� �w )
				    90 ��.�E��
				     1 ��� + �A����	(  1+�a�� �w )
	      �a  �a
	��a ;

: ���a�i
    �������e
    ." '�iΑ'�a�� �e �ᦂ�a�� �a���a���i ���b�s���a." �a�q�� �a�q��
    ." ��Ǳ�i�i�i ���a�e	     '�i�a'	      �a�� á����"  �a�q��
    ." ��Ǳ�i�i ����A �a�e�� ���a�e '�����i �����i'  ��� á����"  �a�q��
    ." DOS�� ���a �a�a�e	     '�{'	    ���a�� á������." �a�q��
    ." �a���� �i�a�i �{�� ���a�e '�����e' �a�� ���a�e '�������e'���a�� á������"
    �a�q��
    �����a
    300 ��  450 ��  600 ��
    ���i��  90 ��.�E��	2000 �|�a��  �����a
    900 �a�e��	700 �a�e��  500 �a�e��
    ���i��  4000 �ᝡ  90 ��.���e��  �����a
    300 Ё
    1 �i�A���b�wȁ ! ;	     \ �e�i���b

���a�i

: TURTLE-hi
    DOSCommand>PAD
    GET-MODE TO OldMode# HGRAPHIC hi
    ." ���e�� �A�e�� ���w�i �a���I wykoh�� ���� ��������." CR
    S" BLOCKS.BLK" MAPPED-TO-BLOCK
    ���a�i  QUIT ;

' TURTLE-hi TO 'boot

( �a�q�i �a���� ���a��������. )
( �a���a���a )
( 400 ���i  400 �a�����i  �a�q���� )
( 400 3 �b�w   400 5 �b�w   400 7 �b�w )
( 5 2 �i  7 2 �i  7 3 �i  8 3 �i  9 2 �i  9 4 �i  10 3 �i  11 3 �i  11 5 �i )
( �a�b�w�a�w5 )
( �a�b�w�a�w5 )
( �a�b�w�a�w12 )
( 30 400 4 �a�� )
( 20 250 5 �a�� )
( 20 250 6 �a�� )
( 50 ���i�a�� !   9 �w )
( 20 ���i�a�� !  12 �w )

[ELSE]

DECIMAL
10 CONSTANT scale
0 VALUE PenDown?
VARIABLE Heading
MAX-X 8 * 2/ VALUE xOffset
MAX-Y 16 * 2/ VALUE yOffset
VARIABLE xCoord  xOffset xCoord !
VARIABLE yCoord  yOffset yCoord !

: PENUP   ( -- )     FALSE TO PenDown? ;
: PENDOWN ( -- )     TRUE  TO PenDown? ;
: LINES-SCREEN ( y -- )   MAX-Y SWAP - TO YTop ;
: FULL-SCREEN  ( -- )	  PAGE ;

: TODRAW ( x y -- )
    scale / yOffset SWAP -	    \ x y1
    SWAP scale / xOffset + SWAP     \ x1 y1
    PenDown? IF 2DUP xCoord @ yCoord @ line640 THEN
    yCoord !  xCoord ! ;

: SHOW-TURTLE ( -- )
    xCoord @  8 Heading @ 270 + sin* +
    yCoord @  8 Heading @ 270 + cos* -
    2DUP xCoord @ yCoord @ xline640		\ x1 y1
    xCoord @  16 Heading @ sin* +
    yCoord @  16 Heading @ cos* -		\ x1 y1 x2 y2
    2SWAP 2OVER xline640			\ x2 y2
    xCoord @  8 Heading @ 90 + sin* +
    yCoord @  8 Heading @ 90 + cos* -		\ x2 y2 x3 y3
    2SWAP 2OVER xline640			\ x3 y3
    xCoord @  yCoord @	xline640 ;

: CLEAR-SCREEN ( -- )	YTop PAGE 0 OVER AT-XY TO YTop SHOW-TURTLE ;

DECIMAL

VARIABLE X-POSITION
VARIABLE Y-POSITION

: HOME	 ( -- )
	SHOW-TURTLE
	0 Heading !
	0 X-POSITION !
	0 Y-POSITION !
	0 0 TODRAW
	SHOW-TURTLE ;

: CLEAR-SCREEN	 ( -- )
	PENUP  HOME CLEAR-SCREEN PENDOWN ;

: SPLIT-SCREEN	( -- )	  8 LINES-SCREEN  CLEAR-SCREEN ;
: FULL-SCREEN	( -- )	  FULL-SCREEN	  CLEAR-SCREEN ;

: RIGHT  ( angle -- )
	SHOW-TURTLE
	Heading @ +
	DUP 0 < IF
		   BEGIN 360 +
		   DUP -1 > UNTIL
		 ELSE 360 MOD
		 THEN
	Heading !
	SHOW-TURTLE ;

: LEFT	   -1 * RIGHT ;

: DELTA-MOVE	( dx dy -- )
	SHOW-TURTLE
	Y-POSITION @ +		( dx y+dy )
	DUP Y-POSITION !	( dx y+dy )
	SWAP X-POSITION @ +	( y+dy x+dx )
	DUP X-POSITION !	( y+dy x+dx )
	SWAP			( x+dx y+dy )
	TODRAW
	SHOW-TURTLE ;

: FORWARD   ( length -- )
	DUP			( l l )
	Heading @ sin*		( l dx )
	SWAP			( dx l )
	Heading @ cos*		( dx dy )
	DELTA-MOVE  ;

: BACK	   ( length -- )
	-1 *  FORWARD ;

: ARCR1   ( step times	-- )
	0 DO   5 RIGHT	 DUP FORWARD  5 RIGHT	LOOP   DROP ;

: ARCR	 ( radius degrees -- )
	SWAP  355 2034 */
	DUP >R
	OVER  10 /
	ARCR1
	10 MOD
	DUP R>
	*  10 /  FORWARD
	RIGHT  ;

: CIRCLER ( radius -- )   360 ARCR ;

: ARCL1   ( step times	-- )
	0 DO   5 LEFT	DUP FORWARD  5 LEFT   LOOP   DROP ;

: ARCL	   ( radius degrees -- )
	SWAP  355 2034 */
	DUP >R
	OVER  10 /
	ARCL1
	10 MOD
	DUP R>
	*  10 /  FORWARD
	LEFT  ;

: CIRCLEL ( radius -- )   360 ARCL ;

: SQUARE   ( size -- )
	4 0  DO   DUP FORWARD	90 RIGHT   LOOP   DROP ;

: BOXES   ( -- )
	100 SQUARE  200 SQUARE	300 SQUARE  400 SQUARE ;

: DIAMONDS   ( -- )
	45 RIGHT
	4 0 DO	BOXES  90 RIGHT  LOOP ;

: FLAG	 ( size -- )
	DUP FORWARD  DUP SQUARE  BACK ;

: 6FLAG   ( size -- )
	6 0 DO	DUP FLAG  60 RIGHT  LOOP ;

: SPINFLAG   ( -- )
	100 6FLAG  400 6FLAG ;

: PETAL1   ( size -- )
	DUP  90 ARCR  90 RIGHT
	     90 ARCR  90 RIGHT ;

: FLOWER1     ( size -- )
	8 0 DO	 DUP  PETAL1 45 RIGHT	LOOP   DROP ;

: PETAL2   ( size -- )
	DUP  60 ARCR  120 RIGHT
	     60 ARCR  120 RIGHT ;

: FLOWER2     ( size -- )
	6 0 DO	 DUP  PETAL2 60 RIGHT	LOOP   DROP ;

: RAY	( size -- )
	DUP  90 ARCL  DUP 90 ARCR
	DUP  90 ARCL	   90 ARCR ;

: SUN	  ( size -- )
	9 0 DO	 DUP RAY  160 RIGHT   LOOP  DROP ;

: REGULAR     ( size vertices -- )
	360 OVER /  SWAP
	0 DO  OVER FORWARD  DUP RIGHT  LOOP
	DROP DROP ;

: STARS   ( vertices times -- )
	OVER OVER *
	0 DO  600 FORWARD  OVER OVER 360 * SWAP / RIGHT  LOOP
	DROP DROP ;

: POLY	 ( size angle -- )
	Heading @ >R
	BEGIN
	   OVER FORWARD DUP RIGHT
	Heading @  R@ = UNTIL
	DROP DROP  R> DROP ;

: POLYDEMO5    5 0 DO  450  72 POLY  72 RIGHT  LOOP ;
: POLYDEMO4    4 0 DO  700 135 POLY  90 RIGHT  LOOP ;
: POLYDEMO12  12 0 DO  15 RIGHT  PENUP	 400 FORWARD  PENDOWN
			 200 135 POLY  15 RIGHT  LOOP ;

: TREE	 ( angle length recursion -- )
	>R
	R@ IF
	   OVER LEFT
	   DUP 2 * FORWARD
	   OVER OVER R@ 1 - RECURSE
	   DUP 2 * BACK
	   OVER 2 * RIGHT
	   DUP FORWARD
	   OVER OVER R@ 1 - RECURSE
	   BACK  LEFT
	ELSE  DROP DROP THEN
	R> DROP ;

VARIABLE DRAGON-SIZE  20 DRAGON-SIZE !
: DRAGON   ( n -- )
	DUP  0 = IF  DRAGON-SIZE @ FORWARD
	      ELSE  DUP  0 > IF     DUP 1 - RECURSE
				    90 RIGHT
				    1 OVER - RECURSE
			     ELSE  -1 OVER - RECURSE
				    90 LEFT
				    1 OVER + RECURSE
	      THEN  THEN
	DROP ;

: HELLO
    SPLIT-SCREEN
    ." Starting Turtle Graphics implemented in hForth." CR CR
    ." Type 'FULL-SCREEN' for full screen text display." CR
    ." Type 'SPLIT-SCREEN' for text display in split screen." CR
    CR
    PENDOWN
    300 FLOWER1  450 FLOWER1  600 FLOWER1
    PENUP   90 LEFT  2000 FORWARD  PENDOWN
    900 FLOWER2  700 FLOWER2  500 FLOWER2
    PENUP   4000 BACK  90 RIGHT  PENDOWN
    300 SUN ;

HELLO

: TURTLE-hi
    DOSCommand>PAD
    GET-MODE TO OldMode# HGRAPHIC hi
    S" BLOCKS.BLK" MAPPED-TO-BLOCK
    HELLO  QUIT ;

' TURTLE-hi TO 'boot

( Try the followings: )
( DIAMONDS )
( 400 FLAG  400 6FLAG  SPINFLAG )
( 400 3 REGULAR   400 5 REGULAR   400 7 REGULAR )
( 5 2 STARS  7 2 STARS	7 3 STARS  8 3 STARS  9 2 STARS  9 4 STARS  10 3 STARS	11 3 STARS  11 5 STARS )
( POLYDEMO5 )
( POLYDEMO5 )
( POLYDEMO12 )
( 30 400 4 TREE )
( 20 250 5 TREE )
( 20 250 6 TREE )
( 50 DRAGON-SIZE !   9 DRAGON )
( 20 DRAGON-SIZE !  12 DRAGON )

[THEN]

SET-CURRENT  SET-ORDER
BASE !
