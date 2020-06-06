`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2020 03:39:48 PM
// Design Name: 
// Module Name: buffer2speaker
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module buffer2speaker
#(
    parameter integer DATA_WIDTH = 16,
    parameter integer MEM_ADDR_WIDTH = 11
)(
    input HCLK,
    input HRESETn,
    input [DATA_WIDTH-1:0] pingPong_din,
    output reg[DATA_WIDTH-1:0] pingPong_dout,
    input speaker_ready,
    input [MEM_ADDR_WIDTH-1:0] pingPong_read_addr,
    
    output reg[MEM_ADDR_WIDTH-1:0] addra,
    output reg[DATA_WIDTH-1:0] dina,
    input  [DATA_WIDTH-1:0] douta,
    output wea,
    
    output reg[MEM_ADDR_WIDTH-1:0] addrb,
    output reg[DATA_WIDTH-1:0] dinb,
    input  [DATA_WIDTH-1:0] doutb,
    output web
    );
    
    reg [MEM_ADDR_WIDTH:0] write_addr;
    wire pingPong;
    assign pingPong = write_addr[MEM_ADDR_WIDTH];
    
    
    
    //write data to RAM
    always @( posedge HCLK or negedge HRESETn) begin
        if(!HRESETn) begin
            write_addr <= 0;
        end
        else if (pingPong) begin
            dina <= pingPong_din;
            write_addr <= write_addr + 1;
        end
        else if (!pingPong) begin
            dinb <= pingPong_din;
            write_addr <= write_addr + 1;
        end
        
    end
    
    assign wea = pingPong;
    assign web = !pingPong;
    
    // if pingPong = 1, write to port A, read from port B, 
    // otherwise read from port A, write to port B
    always @(pingPong, write_addr, pingPong_read_addr) begin
        if(pingPong && speaker_ready) begin
             addra <= write_addr;
             pingPong_dout <= douta;
             addrb <= pingPong_read_addr;
        end
        else if(!pingPong && speaker_ready) begin
            addrb <= write_addr;
            pingPong_dout <= doutb;
            addra <= pingPong_read_addr;
        end
    end
    
endmodule