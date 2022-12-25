`timescale 1ns/1ns
module ASCGEN;
parameter OUTFILE = "ASCII.txt";
reg [7:0] ASC;
integer I;
integer fout;

initial begin
    fout = $fopen(OUTFILE,"wb");
    ASC = 8'b0;
    for(I=0;I<256;I=I+1) begin
        $fwrite(fout,"%b",ASC);
        if(I<255) begin
            $fwrite(fout,"\n");
            ASC = ASC+1'b1;
        end
    end
    $fclose(fout);
    #10;
    $finish;
end
endmodule