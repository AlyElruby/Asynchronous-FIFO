//
// Verilog Module test2_lib.FIFO_TB
//
// Created:
//          by - alymo.UNKNOWN (AELRUBY)
//          at - 18:34:34 03-Mar-23
//
// using Mentor Graphics HDL Designer(TM) 2021.1 Built on 14 Jan 2021 at 15:11:42
//

`resetall
`timescale 1ns/10ps
module FIFO_TB ;
parameter ADDR_WIDTH=5;
parameter DATA_WIDTH=8;
reg clk_read,clk_write,enqueue,dequeue;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;
FIFO f1(clk_read,clk_write,data_in,enqueue,dequeue,data_out);
int i;
initial begin
  //write 2 word and read them
  #0 enqueue=0; dequeue=0; data_in=0;
  #10 enqueue=1; dequeue=0; data_in=8'b10101010;
  #10 enqueue=1; dequeue=0; data_in=8'b11001100;
  #10 enqueue=0; dequeue=1; data_in=0;
  #20 enqueue=0; dequeue=1; data_in=0;
  //read from empty fifo
  #20 enqueue=0; dequeue=1; data_in=0;
  #20 assert(data_out== 8'b11001100) $display("success"); else $error("It's gone wrong"); 
  //writr till the fifo is full
  #20
  for(i=0;i<32;i++)begin
    enqueue=1; dequeue=0; data_in=(i);
    #10;
  end
  //read all data
  #10
  for(i=0;i<32;i++)begin
    enqueue=0; dequeue=1; data_in=0;
    #20;
    assert (data_out==i) $display("success"); else $error("It's gone wrong");
      
  end
  $finish;
  
end
initial begin
  clk_read=0;
  forever #10 clk_read=~clk_read;
end
initial begin
  clk_write=0;
  forever #5 clk_write=~clk_write;
end
initial begin
  $monitor("enqueue= %0h  data_in= %0h dequeue=%0b data_out= %0h",enqueue,data_in,dequeue,data_out);
end

endmodule
