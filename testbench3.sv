module testbench_tv();
	logic clk, reset;
	logic [3:0] data;
	logic [6:0] yexpected, y;
	logic [31:0] vectornum, errors;
	logic [10:0] testvectors[10000:0];

	sevenseg dut(data, y);

	always
		begin
			clk = 1;#5; clk = 0; #5;
		end
	
	initial
		begin
			$readmemb("example.tv",testvectors);
			vectornum = 0; errors = 0;
			reset = 1; #27; reset = 0;
		end

	always @(posedge clk)
		begin
			#1; {data, yexpected} = testvectors[vectornum];
		end
	
	always @(negedge clk)
		if(~reset)  begin
			if (y !== yexpected) begin
				$display("Error: input = %b", data);
				$display(" outputs = %b (%b expected)", y, yexpected);
				errors = errors + 1;
			end
			vectornum = vectornum + 1;
			if(testvectors[vectornum] === 11'bx) begin
				$display("%d tests compilated with %d errors", vectornum, errors);
			$finish;
			end
		end
endmodule