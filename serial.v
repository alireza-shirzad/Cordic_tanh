module serial(clk, resetn, rx_enable, tx);

input rx, clk, reset, rx_enable;
output tx;
wire [7:0] loopback;
wire tx_enable, tx_ready;
// Handdhake protocol instantiation
basic_uart #(.DIVISOR(54)) uart(.clk(clk), .reset(resetn), .rx_data(loopback), .rx_enable(rx_enable), .tx_data(loopback)
												  	, .tx_enable(tx_enable), .tx_ready(tx_ready), .rx(rx), .tx(tx));
													
// FSM
reg [1:0] CS, NS;
parameter RESET = 2'b00, RX = 2'b01, TX = 2'b10;
always @(rx_enable,tx_ready, CS)
begin
	case (CS)
		RESET: if (rx_enable == 1) NS = RX;
		else NS = RESET;						 
		RX: if (tx_ready == 1)  NS = TX;
		else NS = RX;				 
		TX: NS = RESET;				 
		default: NS = 2'bxx;
	endcase
end


											
always @(posedge clk, posedge resetn)
begin
	if (resetn == 0)
		CS <= RESET;
	else
		CS <= NS;
end													

assign tx_enable = (CS==TX);

endmodule
