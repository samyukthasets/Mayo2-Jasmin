require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel_x86.
import SLH64.


require import Array4 Array16.
require import WArray32 WArray128.

abbrev tabler = Array16.of_list witness [W64.of_int 0; W64.of_int 1;
W64.of_int 9; W64.of_int 14; W64.of_int 13; W64.of_int 11; W64.of_int 7;
W64.of_int 6; W64.of_int 15; W64.of_int 2; W64.of_int 12; W64.of_int 5;
W64.of_int 10; W64.of_int 4; W64.of_int 3; W64.of_int 8].


module M3 = {
  proc bitsliced_64_vec_mul_add (in_0:W64.t Array4.t, a:W64.t,
                                 acc:W64.t Array4.t) : W64.t Array4.t = {
    
    var v:W64.t;
    var w:W64.t;
    var w2:W64.t;
    var a0:W64.t;
    var a1:W64.t;
    var a2:W64.t;
    var a3:W64.t;
    var t:W64.t;
    var r:W64.t;
    var u:W64.t;
    var x:W64.t;
    var y:W64.t;
    var z:W64.t;
    
    v <- a;
    w <- a;
    w2 <- a;
    a0 <- a;
    a0 <- (a0 `&` (W64.of_int 1));
    a0 <- (- a0);
    a1 <- (v `>>` (W8.of_int 1));
    a1 <- (a1 `&` (W64.of_int 1));
    a1 <- (- a1);
    a2 <- (w `>>` (W8.of_int 2));
    a2 <- (a2 `&` (W64.of_int 1));
    a2 <- (- a2);
    a3 <- (w2 `>>` (W8.of_int 3));
    a3 <- (a3 `&` (W64.of_int 1));
    a3 <- (- a3);
    t <- a0;
    r <- in_0.[0];
    u <- acc.[0];
    t <- (t `&` r);
    u <- (u `^` t);
    acc.[0] <- u;
    t <- a0;
    r <- in_0.[1];
    u <- acc.[1];
    t <- (t `&` r);
    u <- (u `^` t);
    acc.[1] <- u;
    t <- a0;
    r <- in_0.[2];
    u <- acc.[2];
    t <- (t `&` r);
    u <- (u `^` t);
    acc.[2] <- u;
    t <- a0;
    r <- in_0.[3];
    u <- acc.[3];
    t <- (t `&` r);
    u <- (u `^` t);
    acc.[3] <- u;
    t <- in_0.[0];
    r <- in_0.[3];
    t <- (t `^` r);
    x <- t;
    t <- a1;
    r <- in_0.[3];
    u <- acc.[0];
    t <- (t `&` r);
    u <- (u `^` t);
    acc.[0] <- u;
    t <- a1;
    u <- acc.[1];
    t <- (t `&` x);
    u <- (u `^` t);
    acc.[1] <- u;
    t <- a1;
    r <- in_0.[1];
    u <- acc.[2];
    t <- (t `&` r);
    u <- (u `^` t);
    acc.[2] <- u;
    t <- a1;
    r <- in_0.[2];
    u <- acc.[3];
    t <- (t `&` r);
    u <- (u `^` t);
    acc.[3] <- u;
    t <- in_0.[2];
    r <- in_0.[3];
    t <- (t `^` r);
    y <- t;
    t <- a2;
    r <- in_0.[2];
    u <- acc.[0];
    t <- (t `&` r);
    u <- (u `^` t);
    acc.[0] <- u;
    t <- a2;
    u <- acc.[1];
    t <- (t `&` y);
    u <- (u `^` t);
    acc.[1] <- u;
    t <- a2;
    u <- acc.[2];
    t <- (t `&` x);
    u <- (u `^` t);
    acc.[2] <- u;
    t <- a2;
    r <- in_0.[1];
    u <- acc.[3];
    t <- (t `&` r);
    u <- (u `^` t);
    acc.[3] <- u;
    t <- in_0.[2];
    r <- in_0.[1];
    t <- (t `^` r);
    z <- t;
    t <- a3;
    r <- in_0.[1];
    u <- acc.[0];
    t <- (t `&` r);
    u <- (u `^` t);
    acc.[0] <- u;
    t <- a3;
    u <- acc.[1];
    t <- (t `&` z);
    u <- (u `^` t);
    acc.[1] <- u;
    t <- a3;
    u <- acc.[2];
    t <- (t `&` y);
    u <- (u `^` t);
    acc.[2] <- u;
    t <- a3;
    u <- acc.[3];
    t <- (t `&` x);
    u <- (u `^` t);
    acc.[3] <- u;
    return (acc);
  }
}.

