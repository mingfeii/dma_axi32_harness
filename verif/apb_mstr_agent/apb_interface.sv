`include "apb_param_pkg.sv"
interface apb_interface(
	input 					pclk,
	input                   presetn,    // Active low reset
	input					pclken,
    input                   psel,       // Select signal
    input                   penable,    // Enable signal
    input                   pwrite,     // Write Strobe
    input [`ADDR_WIDTH-1:0] paddr,      // Addr 
    input [`DATA_WIDTH-1:0] pwdata,     // Write Data
    input [`DATA_WIDTH-1:0] prdata,     // Read Data
    input                   pready,     // Slave Ready Signal
    input                   pslverr    // Slave Error Response
	);
	
    logic 					PCLK;
	logic                   PRESETn;    // Active low reset
    logic                   PSEL;       // Select signal
    logic                   PENABLE;    // Enable signal
    logic                   PWRITE;     // Write Strobe
    logic [`ADDR_WIDTH-1:0] PADDR;      // Addr 
    logic [`DATA_WIDTH-1:0] PWDATA;     // Write Data
    logic [`DATA_WIDTH-1:0] PRDATA;     // Read Data
    logic                   PREADY;     // Slave Ready Signal
    logic                   PSLVERR;    // Slave Error Response
    
	assign PCLK = pclk;
	assign PRESETn = !presetn;
	assign psel = PSEL;       // Select signal
	assign pclken = 1;
    assign penable = PENABLE;    // Enable signal
    assign pwrite = PWRITE;     // Write Strobe
    assign paddr = PADDR;      // Addr 
    assign pwdata = PWDATA ;   // Write Data
    assign PRDATA = prdata;     // Read Data
    assign PREADY = pready;     // Slave Ready Signal
    assign PSLVERR = pslverr;    // Slave Error Response
	
    // clocking block declarations
    clocking cb @(posedge PCLK);
        default input #1ns output #1ns;  // default delay skew
        output  PSEL;
        output  PENABLE;
        output  PWRITE;
        output  PADDR;
        output  PWDATA;
        input   PREADY;
        input   PRDATA;
        input   PSLVERR;
    endclocking: cb
    
    // modport declarations
    modport dut(output PRESETn, clocking cb);
    
    ///////////////////////////////////// property check assertions ////////////////////////////////////
    // apb_read transfer seq check
    property apb_read_seq_prop;
        @(posedge PCLK) disable iff(!PRESETn)
        PSEL && !PWRITE && PADDR!='bx |=> PENABLE ##[1:$] PREADY ##1 !PENABLE |-> !PSEL;
    endproperty    
    
    // apb_write transfer seq check
    property apb_write_seq_prop;
        @(posedge PCLK) disable iff(!PRESETn)
        PSEL && PWRITE && PADDR!='bx |=> PENABLE ##[1:$] PREADY ##1 !PENABLE |-> !PSEL;
    endproperty
    
    // property check assertions
    assert property(apb_read_seq_prop); 
    assert property(apb_write_seq_prop);
    
    ///////////////////////////////////// Interface Tasks /////////////////////////////////////////////
    // interface reset task
    task reset_intf();
	    $display("applying reset");
        //PRESETn = 0;  // trigger Reset
        PSEL = 0;
        PENABLE = 0;
        PWRITE = 0;
        repeat(10) 
            @(posedge PCLK);
        //PRESETn = 1;  // back to normal operation
        @(posedge PCLK);
		$display("removed reset");
    endtask
endinterface : apb_interface