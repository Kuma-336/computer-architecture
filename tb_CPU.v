`timescale 1ns/1ps
module tb_CPU();

reg clk;
reg rst;

initial begin
    rst = 1'b1;
    clk = 1'b1;
    #10
    clk = 1'b0;
    rst = 1'b0;
    forever begin
        #10 clk = ~clk;
    end 
end
initial begin
        #15000 $stop;
end

CPU uut(
    .clk (clk ),
    .rst(rst)
);
endmodule

