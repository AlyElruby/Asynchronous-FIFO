//
// Verilog Module test2_lib.fifo1
//
// Created:
//          by - alymo.UNKNOWN (AELRUBY)
//          at - 15:48:26 03-Mar-23
//
// using Mentor Graphics HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//
//in this design we made the read operation susupended if the empty flag is raisd and write operatio is suspended if the full flag is suspended to avoid -
//-lossing data and undesirable behavior
module FIFO(clk_read,clk_write,data_in,enqueue,dequeue,data_out);
  parameter ADDR_WIDTH=5;
  parameter DATA_WIDTH=8;
  input [DATA_WIDTH-1:0] data_in;
  input wire clk_read,clk_write,enqueue,dequeue;
  output reg [DATA_WIDTH-1:0] data_out;
  //internal flags
  wire full,empty;
  //internal registers
  reg [ADDR_WIDTH:0] wr_addr=0,rd_addr=0;
/////////////////////////
//memory ram
  reg [DATA_WIDTH-1:0] fifo [(2**ADDR_WIDTH)-1:0];
//////////assign empty and full flags
  assign full=({!wr_addr[ADDR_WIDTH] , wr_addr[ADDR_WIDTH-1:0]} == rd_addr);//check for equality after warping around we compare n-1 bits and !n th bit
  assign empty = (wr_addr == rd_addr);//checking for equality for all bits
///////// Read block with only read clock to avoid CDC
  always @(posedge clk_read) begin
    if(dequeue && !empty) begin
      data_out<= fifo[rd_addr[ADDR_WIDTH-1:0]];
      rd_addr<=rd_addr+1;
      end
  end
  ////////
////write block
  always @(posedge clk_write) begin
    if(enqueue && !full) begin
      fifo[wr_addr[ADDR_WIDTH-1:0]]<=data_in;
      wr_addr<=wr_addr+1;
      end
  end
endmodule

