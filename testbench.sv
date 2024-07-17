`timescale 1ns / 1ps
`define CLK @(posedge clk)
module fifo_tb();
  localparam DW = 8;
  localparam DP = 24;
  
  logic clk;
  logic rst;
  logic push;
  logic [DW-1:0] push_data;
  logic pop;
  logic [DW-1:0] pop_data_o;
  logic full_flag;
  logic empty_flag;
  
  fifo #(.DW(DW), .DP(DP)) FIFO (.*);
  
  // clock
  always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
  end
  
  // test cases
  initial begin
    rst = 1'b1;
    push = 1'b0;
    pop = 1'b0;
    repeat (2) @(posedge clk);
    rst = 1'b0;
    `CLK;
    push = 1'b1;
    push_data = 8'h12;
    `CLK;
    push_data = 8'hAC;
    `CLK;
    push = 1'b0;
    `CLK;
    push = 1'b0;
    push_data = 8'hx;
    pop = 1'b1;
    `CLK;
    pop = 1'b0;
    
    repeat (2) `CLK;
    $finish();
  
  end
  
endmodule