module my_full_adder( input A,
       input B,
       input CIN,
       output S,
       output COUT
       );
       assign S = A^B^CIN;
       assign COUT = (A&B) | (CIN&(A^B));

endmodule

module Ripple_Carry_Adder(a, b, cin, cout, sum );
    input [3:0] a;
    input [3:0] b;
    input cin;
    output cout;
    output [3:0] sum;
    
    wire C1,C2,C3;

    my_full_adder fa0 (a[0],b[0],cin,sum[0],C1);
    my_full_adder fa1 (a[1],b[1],C1,sum[1],C2);
    my_full_adder fa2 (a[2],b[2],C2,sum[2],C3);
    my_full_adder fa3 (a[3],b[3],C3,sum[3],cout);


endmodule