require import AllCore.
require import Bool Array64.

type element = bool * bool * bool * bool.
op int_to_bool n = (n <> 0).
module M2 = {
var a : element
var b : element
var c : element
proc mul(a : element, b : element):element = {

var a0, a1,a2, a3, b0, b1, b2, b3, c0, c1, c2, c3 : bool; 
(a0, a1, a2, a3) <- a;
(b0, b1, b2, b3) <- b;
(c0, c1, c2, c3) <- c;

c0 <- (a0 /\ b0) ^ (a1 /\ b3) ^ (a2 /\ b2) ^ (a3 /\ b1);
c1 <- (a0 /\ b1) ^ (a1 /\ b0) ^ (a1 /\ b3) ^ (a2 /\ b2) ^ (a3 /\ b1) ^ (a2 /\ b3) ^ (a3 /\ b2);
c2 <- (a0 /\ b2) ^ (a1 /\ b1) ^ (a2 /\ b0) ^ (a2 /\ b3) ^ (a3 /\ b2) ^ (a3 /\ b3);
c3 <- (a0 /\ b3) ^ (a1 /\ b2) ^ (a2 /\ b1) ^ (a3 /\ b0) ^ (a3 /\ b3);
c <- (c0,c1,c2,c3);
return c;
}

proc add(a : element, b : element):element = {

var a0, a1,a2, a3, b0, b1, b2, b3, c0, c1, c2, c3 : bool;
(a0, a1, a2, a3) <- a;
(b0, b1, b2, b3) <- b;
(c0, c1, c2, c3) <- c;

c0 <- a0 ^ b0;
c1 <- a1 ^ b1;
c2 <- a2 ^ b2;
c3 <- a3 ^ b3;
c <- (c0,c1,c2,c3);
return c;
}

var tmp : element
var inp : element Array64.t
var acc : element Array64.t

proc vec_mul_add_64(inp acc : element Array64.t, a : element):element Array64.t = {
var i: int;
i <- 0;

while(i < 64){
  tmp <@ mul(inp.[i], a);
  tmp <@ add(acc.[i],tmp);
  acc.[i] <- tmp;
  i <- i + 1;
}
return acc;
}

}.
