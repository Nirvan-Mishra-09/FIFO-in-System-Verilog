`timescale 1ns / 1ps
module fifo #(	parameter DW = 8,
              parameter DP = 4)(
  
  input logic 			clk, rst,
  input logic 			push,
  input logic [DW-1:0] 	push_data,
  input logic			pop,
  output logic [DW-1:0]	pop_data_o,
  output logic	full_flag,
  output logic empty_flag
);
  
  localparam PUSH = 2'b10, POP = 2'b01, PUSHPOP = 2'b11;
  localparam pntr_wd = $clog2(DP);
  
  // Memory to Store data
  logic [DW-1:0] fifo_data [DP-1:0];
  logic [pntr_wd-1:0] rd_pntr;
  logic [pntr_wd-1:0] wr_pntr;
  logic [pntr_wd-1:0] nxt_rd_pntr;
  logic [pntr_wd-1:0] nxt_wr_pntr;
  // Wrap pointer for checking the full and empty flag
  logic wrp_rd_pntr;
  logic wrp_wr_pntr;
  logic nxt_wrp_rd_pntr;
  logic nxt_wrp_wr_pntr;
  logic [DW-1:0] nxt_fifo_data;
  
  logic [DW-1:0] data_pop;
  
  logic full, empty;
  // Pointers toggelling
  
  always_ff @ (posedge clk or posedge rst)
    if (rst) begin
      	rd_pntr <= pntr_wd'(1'b0);
  		wr_pntr <= pntr_wd'(1'b0);
      	wrp_rd_pntr <= pntr_wd'(1'b0);
      	wrp_wr_pntr <= pntr_wd'(1'b0);
    end else begin
      	rd_pntr <= nxt_rd_pntr; 
      	wr_pntr <= nxt_wr_pntr;
      	wrp_rd_pntr <= nxt_rd_pntr;
      	wrp_wr_pntr <= nxt_wr_pntr;
    end
  
  // State Machines
  
  always_comb begin
    nxt_fifo_data = fifo_data[wr_pntr];
    nxt_rd_pntr = rd_pntr;
    nxt_wr_pntr = wr_pntr;
    nxt_wrp_rd_pntr = wrp_rd_pntr;
    nxt_wrp_wr_pntr = wrp_wr_pntr;
    case({push, pop})
 /////////////////// PUSH ////////////////////////////////////////////  
      	PUSH:begin
          nxt_fifo_data = push_data;
          // incrementing the write pointers
          if (wr_pntr == pntr_wd'(DP-1)) begin nxt_wr_pntr = pntr_wd'(1'b0); 
            								nxt_wrp_wr_pntr = ~wrp_wr_pntr;
          end
          else nxt_wr_pntr = wr_pntr + pntr_wd'(1'b1);
        end
/////////////////// POP ////////////////////////////////////////////      
        POP:begin
          data_pop = fifo_data[rd_pntr[pntr_wd-1]];
          //incrementing the read pointers
          if (rd_pntr == pntr_wd'(DP-1)) begin nxt_rd_pntr = pntr_wd'(1'b0); 
            								nxt_wrp_rd_pntr = ~wrp_rd_pntr;
          end
          else nxt_rd_pntr = rd_pntr + pntr_wd'(1'b1);
        end
/////////////////// PUSHPOP ////////////////////////////////////////////        
        PUSHPOP:
          begin
            
          nxt_fifo_data = push_data;
          // incrementing the write pointers
          if (wr_pntr == pntr_wd'(DP-1)) begin nxt_wr_pntr = pntr_wd'(1'b0); 
            								nxt_wrp_wr_pntr = ~wrp_wr_pntr;
          end
          else nxt_wr_pntr = wr_pntr + pntr_wd'(1'b1); 
            
          data_pop = fifo_data[rd_pntr[pntr_wd-1]];
          //incrementing the read pointers
            if (rd_pntr == pntr_wd'(DP-1)) begin nxt_rd_pntr = pntr_wd'(1'b0); 
            								nxt_wrp_rd_pntr = ~wrp_rd_pntr;
          end
          else nxt_rd_pntr = rd_pntr + pntr_wd'(1'b1);
            
          end
      default: begin	nxt_fifo_data = fifo_data[wr_pntr[pntr_wd-1:0]]; 
      			nxt_rd_pntr = rd_pntr;
        nxt_wr_pntr = wr_pntr; end
    endcase
    
  end
   
// assigning empty
  assign empty = (wr_pntr == rd_pntr) & (wrp_rd_pntr == wrp_wr_pntr);
// assigning full
  assign full = (wr_pntr == rd_pntr) & (wrp_rd_pntr != wrp_wr_pntr);

  // assigning the fifo data

   always_ff @ (posedge clk)
      fifo_data[wr_pntr[pntr_wd-1:0]] <= nxt_fifo_data;
   
   // Outputs
   	assign pop_data_o = data_pop;
  	assign full_flag = full;
  	assign empty_flag = empty;
  
endmodule

