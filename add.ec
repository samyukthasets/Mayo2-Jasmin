require import AllCore IntDiv CoreMap List Distr.
from Jasmin require import JModel_x86.
import SLH64.


require import Array16.
require import WArray128.

abbrev tabler = Array16.of_list witness [W64.of_int 0; W64.of_int 1;
W64.of_int 9; W64.of_int 14; W64.of_int 13; W64.of_int 11; W64.of_int 7;
W64.of_int 6; W64.of_int 15; W64.of_int 2; W64.of_int 12; W64.of_int 5;
W64.of_int 10; W64.of_int 4; W64.of_int 3; W64.of_int 8].


module M3 = {
  proc gf16_add (in1:W64.t, in2:W64.t) : W64.t = {
    
    
    
    in1 <- (in1 `^` in2);
    in1 <- in1;
    return (in1);
  }
}.

