from Jasmin require  import JModel JMemory.
import W64.
require import Fq_spec Mul Add List Int Real Bool Bitsliced_ffarith Array64 Array4.
require StdBigop.
import StdBigop.Bigbool.BBXor.
require import IntDiv.
pragma Goals:printall.

print WArray64.

axiom w_masked (w : W64.t)(i : int) :
   (w `&` (W64.of_int 15)).[i] = (w.[i] /\ i <=0<4).  

op add (x y : element) : element =
  let (x0, x1, x2, x3) = x in
  let (y0, y1, y2, y3) = y in
  (x0 ^ y0, x1 ^ y1, x2 ^ y2, x3 ^ y3).

(* Abstract multiplication operation - to be defined based on the implementation *)
op mul (x y : element) : element =
  let (a0, a1, a2, a3) = x in
  let (b0, b1, b2, b3) = y in
  ( (a0 /\ b0) ^ (a1 /\ b3) ^ (a2 /\ b2) ^ (a3 /\ b1),
    (a0 /\ b1) ^ (a1 /\ b0) ^ (a1 /\ b3) ^ (a2 /\ b2) ^ (a3 /\ b1) ^ (a2 /\ b3) ^ (a3 /\ b2),
    (a0 /\ b2) ^ (a1 /\ b1) ^ (a2 /\ b0) ^ (a2 /\ b3) ^ (a3 /\ b2) ^ (a3 /\ b3),
    (a0 /\ b3) ^ (a1 /\ b2) ^ (a2 /\ b1) ^ (a3 /\ b0) ^ (a3 /\ b3) ).


(*convert from W64 to element *)
op W64_to_element(w: W64.t): element = 
  (w.[0], w.[1], w.[2], w.[3]).
axiom zero_get:forall i, 0 <= i < 64 => W64.zero.[i] = false.
axiom of_int15: forall i, 0 <= i < 4 => (W64.of_int 15).[i] = true.
axiom of_int240: forall i, 4 <= i < 8 => (W64.of_int 240).[i] = true.
axiom of_int240_bit3: (W64.of_int 240).[3] = false. 

axiom bitwise_shift_mul (w1 w2 : W64.t) (i : int):
  0 <= i < 64 =>
  (w1 `&` (W64.of_int (Ring.IntID.(^) 2 i))) * w2 = if w1.[i] then (w2 `<<<` i) else W64.zero.

axiom mulE1 : forall (w1 w2 : W64.t),
  (w1 * w2).[1] = (w1.[0] /\ w2.[1]) ^^ (w1.[1] /\ w2.[0]).

axiom mulE2 : forall (w1 w2 : W64.t),
  (w1 * w2).[2] =
    (w1.[0] /\ w2.[2]) ^^
    (w1.[1] /\ w2.[1]) ^^
    (w1.[2] /\ w2.[0]).
axiom mulE3 : forall (w1 w2 : W64.t),
  (w1 * w2).[3] =
    (w1.[0] /\ w2.[3]) ^^
    (w1.[1] /\ w2.[2]) ^^
    (w1.[2] /\ w2.[1]) ^^
    (w1.[3] /\ w2.[0]).
lemma xor_proj_tuple_eq (x y : bool * bool * bool * bool) :
  (x.`1 ^ y.`1, x.`2 ^ y.`2, x.`3 ^ y.`3, x.`4 ^ y.`4)
  =
  let (x0, x1, x2, x3) = x in
  let (y0, y1, y2, y3) = y in
  (x0 ^ y0, x1 ^ y1, x2 ^ y2, x3 ^ y3).
proof.
  (* Projections are well-defined, so we can case inside the proof body *)
  case x => [x0 x1 x2 x3].
  case y => [y0 y1 y2 y3].
  simplify.
  trivial.
qed.



hoare add_correct (x y : element): 
  M2.add: 
  arg = (x, y) ==> 
  res = add x y.
proof.
  proc. auto. move => &hr. 
  move=> [Ha Hb].
  rewrite Ha Hb.
  rewrite /add.
    
  have -> : 
  (x.`1 ^ y.`1, x.`2 ^ y.`2, x.`3 ^ y.`3, x.`4 ^ y.`4) =
  let (x0, x1, x2, x3) = x in
  let (y0, y1, y2, y3) = y in
  (x0 ^ y0, x1 ^ y1, x2 ^ y2, x3 ^ y3)
  by apply xor_proj_tuple_eq.
  trivial.  

qed.

lemma big_expr_proj_eq (x y : bool * bool * bool * bool) :
  let a0_0 = x.`1 in
  let a1_0 = x.`2 in
  let a2_0 = x.`3 in
  let a3_0 = x.`4 in
  let b0_0 = y.`1 in
  let b1_0 = y.`2 in
  let b2_0 = y.`3 in
  let b3_0 = y.`4 in
  ((a0_0 /\ b0_0) ^ (a1_0 /\ b3_0) ^ (a2_0 /\ b2_0) ^ (a3_0 /\ b1_0),
   (a0_0 /\ b1_0) ^ (a1_0 /\ b0_0) ^ (a1_0 /\ b3_0) ^ (a2_0 /\ b2_0) ^
   (a3_0 /\ b1_0) ^ (a2_0 /\ b3_0) ^ (a3_0 /\ b2_0),
   (a0_0 /\ b2_0) ^ (a1_0 /\ b1_0) ^ (a2_0 /\ b0_0) ^ (a2_0 /\ b3_0) ^
   (a3_0 /\ b2_0) ^ (a3_0 /\ b3_0),
   (a0_0 /\ b3_0) ^ (a1_0 /\ b2_0) ^ (a2_0 /\ b1_0) ^ (a3_0 /\ b0_0) ^
   (a3_0 /\ b3_0))
  =
  let (a0_1, a1_1, a2_1, a3_1) = x in
  let (b0_1, b1_1, b2_1, b3_1) = y in
  ((a0_1 /\ b0_1) ^ (a1_1 /\ b3_1) ^ (a2_1 /\ b2_1) ^ (a3_1 /\ b1_1),
   (a0_1 /\ b1_1) ^ (a1_1 /\ b0_1) ^ (a1_1 /\ b3_1) ^ (a2_1 /\ b2_1) ^
   (a3_1 /\ b1_1) ^ (a2_1 /\ b3_1) ^ (a3_1 /\ b2_1),
   (a0_1 /\ b2_1) ^ (a1_1 /\ b1_1) ^ (a2_1 /\ b0_1) ^ (a2_1 /\ b3_1) ^
   (a3_1 /\ b2_1) ^ (a3_1 /\ b3_1),
   (a0_1 /\ b3_1) ^ (a1_1 /\ b2_1) ^ (a2_1 /\ b1_1) ^ (a3_1 /\ b0_1) ^
   (a3_1 /\ b3_1)).
proof.
  case x => [a0 a1 a2 a3].
  case y => [b0 b1 b2 b3].
  simplify.
  trivial.
qed.



hoare mul_correct (x y : element):
  M2.mul: 
  arg = (x, y) ==> 
  res = mul x y.
proof.
  proc. auto. move => &hr [Ha Hb].
  rewrite Ha Hb /mul.  
  rewrite (big_expr_proj_eq x y).
qed.  


lemma two_eq_one_shift_left_1 : 2 = 1 `<<` 1.
proof. reflexivity. qed.
lemma two_eq_one_shift_left_2 : 4 = 1 `<<` 2.
proof. reflexivity. qed.
lemma two_eq_one_shift_left_3 : 8 = 1 `<<` 3.
proof. reflexivity. qed.
(* Now rewrite using the lemma *)
axiom oneE0 : W64.one.[0] = true.
axiom oneE1 : W64.one.[1] = false.
axiom oneE2 : W64.one.[2] = false.
axiom oneE3 : W64.one.[3] = false.
axiom twoE0 : (W64.of_int 2).[0] = false.
axiom twoE1: (W64.of_int 2).[1] = true.
axiom twoE2: (W64.of_int 2).[2] = false.
axiom twoE3: (W64.of_int 2).[3] = false.
axiom fourE0 : (W64.of_int 4).[0] = false.
axiom eightE0 : (W64.of_int 8).[0] = false.
axiom fourE1 : (W64.of_int 4).[1] = false.
axiom fourE2 : (W64.of_int 4).[2] = true.
axiom fourE3 : (W64.of_int 4).[3] = false.
axiom eightE1 : (W64.of_int 8).[1] = false.
axiom eightE2 : (W64.of_int 8).[2] = false.
axiom eightE3 : (W64.of_int 8).[3] = true.
axiom twofortyE4 : (W64.of_int 240).[4] = true.
axiom of_int240_bit4: (W64.of_int 240).[4] = true.
axiom of_int240_bit5: (W64.of_int 240).[5] = true.
axiom of_int240_bit6: (W64.of_int 240).[6] = true.
axiom of_int240_bit7: (W64.of_int 240).[7] = true.
axiom andEa : forall (w1 w2 : W64.t) (i : int),
  0 <= i < 64 => (w1 `&` w2).[i] = (w1.[i] /\ w2.[i]).

axiom mulE0 : forall (w1 w2 : W64.t), (w1 * w2).[0] = (w1.[0] /\ w2.[0]).
lemma one_is_shift0 : W64.one = W64.of_int (1 `<<` 0).
proof. reflexivity. qed.

lemma mul_chk w1 w2:
  equiv [M.gf16_mul ~ M2.mul : (forall (i:int),  4<= i< 64 => w2.[i] = false)/\  
         in1{1} = w1 /\ in2{1} = w2 /\ 
         a{2} = W64_to_element w1 /\ b{2} = W64_to_element w2 
         ==> res{2} = W64_to_element res{1}].
proof.
  proc; auto => />  @/W64_to_element /=.
  move => i.
  split.
  rewrite !shrwE !mulE0 !andEa //=. 
  rewrite !of_int15 /=. smt.
  rewrite oneE0 twoE0 fourE0 eightE0 /=.
  rewrite twofortyE4 of_int240_bit3 /=.
  rewrite (bitwise_shift_mul _ _ 0) //.
  rewrite (bitwise_shift_mul _ _ 1) //.
  rewrite (bitwise_shift_mul _ _ 2) //.
  rewrite (bitwise_shift_mul _ _ 3) //.
  rewrite !(fun_if2 ("_.[_]")%W64) zero_get.
  smt.
  move => //=.
  rewrite (i 4) => //=.  
  print (^).
  print (^^).

  (* Link them *)
  have eqx: forall b1 b2, b1 ^ b2 = b1 ^^ b2 by case=> [] [].
  
  print (&&).
  print (/\).
  
  (* Rewrite all occurrences of (^) to (^^). *)
  (* Proof is then done by reflexivity *)
  rewrite !eqx => //=.
  rewrite !andaE !xorA.
  reflexivity.    
  
  split.  
  rewrite !shrwE !mulE1 !andEa /=.
  trivial  => //=.
  smt. smt. smt. smt. smt. smt. smt. smt. smt.  
  rewrite oneE0 oneE1 twoE0 twoE1 fourE0 fourE1 eightE0 eightE1 of_int240_bit4 of_int240_bit5=> /=.
  rewrite (bitwise_shift_mul _ _ 0) //.
  rewrite (bitwise_shift_mul _ _ 1) //.
  rewrite (bitwise_shift_mul _ _ 2) //.
  rewrite (bitwise_shift_mul _ _ 3) //.      
  rewrite !(fun_if2 ("_.[_]")%W64) zero_get.
  smt.
  move => //=.
  rewrite (i 4) => //=.
  rewrite (i 5) => //=.
  have eqx: forall b1 b2, b1 ^ b2 = b1 ^^ b2 by case=> [] []. 
 rewrite !eqx => //=.
  rewrite !andaE !of_int15 => /=.
  smt. ring.    
  split.
  rewrite !shrwE !mulE2 !andEa /=.   
  smt. smt. smt. smt. smt. smt. smt. smt. smt. smt. smt. smt. smt.
  smt.
  rewrite oneE0 oneE1 oneE2 twoE0 twoE1 twoE2 fourE0 fourE1 fourE2 eightE0 eightE1 eightE2 of_int240_bit6 of_int240_bit5 of_int15=> /=. smt.
  rewrite (bitwise_shift_mul _ _ 0) //.
  rewrite (bitwise_shift_mul _ _ 1) //.
  rewrite (bitwise_shift_mul _ _ 2) //.
  rewrite (bitwise_shift_mul _ _ 3) //.
  rewrite !(fun_if2 ("_.[_]")%W64) zero_get.
  smt.
  move => //=.
  rewrite (i 5).
  smt.
  rewrite (i 4) => /=.
  smt.
  rewrite (i 6) => /=.
  smt.
  have eqx: forall b1 b2, b1 ^ b2 = b1 ^^ b2 by case=> [] []. 
  rewrite !eqx => //=.
  rewrite !andaE.
  ring.
  
  rewrite !shrwE !mulE3 !andEa //=.
  rewrite !of_int15 /=. smt.
  rewrite oneE0 oneE1 oneE2 oneE3 twoE0 twoE1 twoE2 twoE3 fourE0 fourE1 fourE2 fourE3 eightE0 eightE1 eightE2 eightE3=> /=.
  rewrite of_int240_bit6 of_int240_bit7 /=.
  rewrite (bitwise_shift_mul _ _ 0) //.
  rewrite (bitwise_shift_mul _ _ 1) //.
  rewrite (bitwise_shift_mul _ _ 2) //.
  rewrite (bitwise_shift_mul _ _ 3) //.
  rewrite !(fun_if2 ("_.[_]")%W64) zero_get.
  smt.
  move => //=.
  rewrite (i 4) => //=.
  rewrite (i 5) => //=. 
  rewrite (i 6) => //=.
  rewrite (i 7) => //=.
  have eqx: forall b1 b2, b1 ^ b2 = b1 ^^ b2 by case=> [] [].
  rewrite !eqx => //=.
  rewrite !andaE.
  ring.
qed.


op Array4_to_Array64(a: W64.t Array4.t): element Array64.t = 
   let w0 = a.[0] in
   let w1 = a.[1] in 
   let w2 = a.[2] in
   let w3 = a.[3] in
   Array64.init (fun i => 
     (w0.[i], w1.[i], w2.[i], w3.[i])
   ).
