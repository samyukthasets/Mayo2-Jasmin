require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel_x86.
import SLH64.


require import Array16.
require import WArray128.

abbrev tabler = Array16.of_list witness [W64.of_int 0; W64.of_int 1;
W64.of_int 9; W64.of_int 14; W64.of_int 13; W64.of_int 11; W64.of_int 7;
W64.of_int 6; W64.of_int 15; W64.of_int 2; W64.of_int 12; W64.of_int 5;
W64.of_int 10; W64.of_int 4; W64.of_int 3; W64.of_int 8].


module M = {
  proc gf16_mul (in1:W64.t, in2:W64.t) : W64.t = {
    
    var out:W64.t;
    var p1:W64.t;
    var p2:W64.t;
    var p:W64.t;
    var top_p:W64.t;
    var tps3:W64.t;
    var tps4:W64.t;
    
    p1 <- in1;
    p1 <- (p1 `&` (W64.of_int 1));
    p1 <- (p1 * in2);
    p2 <- in1;
    p2 <- (p2 `&` (W64.of_int 2));
    p2 <- (p2 * in2);
    p1 <- (p1 `^` p2);
    p2 <- in1;
    p2 <- (p2 `&` (W64.of_int 4));
    p2 <- (p2 * in2);
    p1 <- (p1 `^` p2);
    p2 <- in1;
    p2 <- (p2 `&` (W64.of_int 8));
    p2 <- (p2 * in2);
    p1 <- (p1 `^` p2);
    p <- p1;
    top_p <- p;
    top_p <- (top_p `&` (W64.of_int 240));
    tps3 <- top_p;
    tps3 <- (tps3 `>>` (W8.of_int 3));
    tps4 <- top_p;
    tps4 <- (tps4 `>>` (W8.of_int 4));
    out <- p;
    out <- (out `^` tps4);
    out <- (out `^` tps3);
    out <- (out `&` (W64.of_int 15));
    return (out);
  }
}.

