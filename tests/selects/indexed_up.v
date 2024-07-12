module t_base(data, sel);
	parameter MSB = 0;
	parameter LSB = 0;
	localparam big_endian = MSB < LSB;

	input [MSB:LSB] data;
	input [2:0] sel;

	wire [1:0] o = data[sel+:2];

	always @* begin
		if (sel[0] === 1'bx ||
				sel[1] === 1'bx ||
				sel[2] === 1'bx) begin
			assert(o === 2'bxx);
		end else begin
			assert(o === (big_endian ?
							{data[sel], data[sel + 1]}
							: {data[sel + 1], data[sel]}));
		end
	end
endmodule

module t01(data, sel);
	input [4:-2] data;
	input [2:0] sel;
	t_base #(.MSB(4), .LSB(-2)) t(.*);
endmodule

module t02(data, sel);
	input [6:0] data;
	input [2:0] sel;
	t_base #(.MSB(6), .LSB(0)) t(.*);
endmodule

module t03(data, sel);
	input [7:2] data;
	input [2:0] sel;
	t_base #(.MSB(7), .LSB(2)) t(.*);
endmodule

module t04(data, sel);
	input [0:6] data;
	input [2:0] sel;
	t_base #(.MSB(0), .LSB(6)) t(.*);
endmodule

module t05(data, sel);
	input [2:7] data;
	input [2:0] sel;
	t_base #(.MSB(2), .LSB(7)) t(.*);
endmodule

module t_base2(i1, i2, sel);
	parameter MSB = 0;
	parameter LSB = 0;
	localparam big_endian = MSB < LSB;

	input [2:0] sel;
	input [MSB:LSB] i1;
	input [1:0] i2;

	reg [MSB:LSB] data;
	always @* begin
		data = i1;
		data[sel+:2] = i2;
	end

	reg [MSB:LSB] data2;
	always @* begin
		data2 = i1;
		if (big_endian) begin
			data2[sel + 1] = i2[0];
			data2[sel] = i2[1];
		end else begin
			data2[sel] = i2[0];
			data2[sel + 1] = i2[1];
		end
	end

	always @* begin
		if (sel[0] === 1'bx ||
				sel[1] === 1'bx ||
				sel[2] === 1'bx) begin
			// No guarantees
		end else begin
			assert(data2 === data);
		end
	end
endmodule

module t06(i1, i2, sel);
	input [4:-2] i1;
	input [1:0] i2;
	input [2:0] sel;
	t_base2 #(.MSB(4), .LSB(-2)) t(.*);
endmodule

module t07(i1, i2, sel);
	input [6:0] i1;
	input [1:0] i2;
	input [2:0] sel;
	t_base2 #(.MSB(6), .LSB(0)) t(.*);
endmodule

module t08(i1, i2, sel);
	input [7:2] i1;
	input [1:0] i2;
	input [2:0] sel;
	t_base2 #(.MSB(7), .LSB(2)) t(.*);
endmodule

module t09(i1, i2, sel);
	input [0:6] i1;
	input [1:0] i2;
	input [2:0] sel;
	t_base2 #(.MSB(0), .LSB(6)) t(.*);
endmodule

module t10(i1, i2, sel);
	input [2:7] i1;
	input [1:0] i2;
	input [2:0] sel;
	t_base2 #(.MSB(2), .LSB(7)) t(.*);
endmodule
