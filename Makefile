JASMIN=jasminc
JFLAGS=-lea 
# -pcstexp 

sign: test_NIST_signverif.c mayo2_keypair_NIST.s mayo2_sign_NIST.s mayo2_verify_NIST.s print.c randombytes.c 
	gcc -g -I. $^ -o $@


%.s: %.jazz
	$(JASMIN) -o $@ $(JFLAGS) $^

.PHONY: clean

clean:
	-rm keygen mayo2_keypair_NIST.s mayo2_sign_NIST.s out.txt
