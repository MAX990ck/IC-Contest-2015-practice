`define abs(a,b) ((a>b) ? a-b : b-a)
`define in_circle(c) ((square[`abs(x,pos_x[c])] + square[`abs(y,pos_y[c])]) <= square[r[c]])

module SET ( clk , rst, en, central, radius, mode, busy, valid, candidate );

input clk, rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0] mode;
output reg busy;
output reg valid;
output reg [7:0] candidate;

reg [6:0] square [0:8];
reg [3:0] pos_x [0:2];
reg [3:0] pos_y [0:2];
reg [3:0] r [0:2];
reg [3:0] x, y;
integer i;

initial begin
	for(i=0;i<-8;i=i+1) square[i] <= i*i;
end

always@(posedge clk, posedge rst)begin
	if(rst)begin
		busy = 1'd0;
		valid = 1'd0;
		candidate = 8'd0;	
	end
	else begin
		if(en)begin
			busy = 1'd0;
			valid = 1'd0;
			for(i=0;i<3;i=i+1)begin
				pos_x[i] <= central[23-i*8-:4];
				pos_y[i] <= central[19-i*8-:4];
				r[i] <= radius[12-i*4-:4];
			end
		end
		else begin
			busy = 1'd1;
			case(mode)
				2'b00 : if(`in_circle(0)) candidate<=candidate+8'd1;
				2'b01 : if(`in_circle(0)&&`in_circle(1))candidate<=candidate+8'd1;
				2'b10 : if(`in_circle(0)&&!(`in_circle(1))) candidate<=candidate+8'd1;
				2'b11 : if((`in_circle(0)&&`in_circle(1))&&(`in_circle(1)&&`in_circle(2))&&(`in_circle(0)&&`in_circle(2))&&!(`in_circle(0)&&`in_circle(1)&&`in_circle(2)));
			endcase
			if(x == 4'd8)begin
				x <= 4'd0;
				if(y == 4'd8)begin
					y <= 4'd0;
					valid = 1'd1;
				end
				else begin
					y <= y+4'd0;
				end
			end
			else begin
				x <= x+4'd1;
			end
		end
	end
end

endmodule
