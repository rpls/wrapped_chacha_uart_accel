// Generator : SpinalHDL v1.4.3    git head : adf552d8f500e7419fff395b7049228e4bc5de26
// Component : chacha_uart_accel
// Git hash  : 2eef5afe634a7f554a1e7752fb1e4e793ca928e0

`timescale 1ns/1ps 
`define UartStopType_defaultEncoding_type [0:0]
`define UartStopType_defaultEncoding_ONE 1'b0
`define UartStopType_defaultEncoding_TWO 1'b1

`define UartParityType_defaultEncoding_type [1:0]
`define UartParityType_defaultEncoding_NONE 2'b00
`define UartParityType_defaultEncoding_EVEN 2'b01
`define UartParityType_defaultEncoding_ODD 2'b10

`define fsm_enumDefinition_defaultEncoding_type [2:0]
`define fsm_enumDefinition_defaultEncoding_fsm_BOOT 3'b000
`define fsm_enumDefinition_defaultEncoding_fsm_IO 3'b001
`define fsm_enumDefinition_defaultEncoding_fsm_CYCLE 3'b010
`define fsm_enumDefinition_defaultEncoding_fsm_PERMUTE 3'b011
`define fsm_enumDefinition_defaultEncoding_fsm_UPDATE 3'b100

`define fsm_enumDefinition_1_defaultEncoding_type [2:0]
`define fsm_enumDefinition_1_defaultEncoding_fsm_BOOT 3'b000
`define fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE 3'b001
`define fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE 3'b010
`define fsm_enumDefinition_1_defaultEncoding_fsm_TOODD 3'b011
`define fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN 3'b100

`define UartCtrlTxState_defaultEncoding_type [2:0]
`define UartCtrlTxState_defaultEncoding_IDLE 3'b000
`define UartCtrlTxState_defaultEncoding_START 3'b001
`define UartCtrlTxState_defaultEncoding_DATA 3'b010
`define UartCtrlTxState_defaultEncoding_PARITY 3'b011
`define UartCtrlTxState_defaultEncoding_STOP 3'b100

`define UartCtrlRxState_defaultEncoding_type [2:0]
`define UartCtrlRxState_defaultEncoding_IDLE 3'b000
`define UartCtrlRxState_defaultEncoding_START 3'b001
`define UartCtrlRxState_defaultEncoding_DATA 3'b010
`define UartCtrlRxState_defaultEncoding_PARITY 3'b011
`define UartCtrlRxState_defaultEncoding_STOP 3'b100


module chacha_uart_accel (
  output              uart_txd,
  input               uart_rxd,
  input               div_valid,
  input      [19:0]   div_payload,
  input               clk,
  input               reset
);
  reg                 _zz_1;
  reg                 _zz_2;
  wire       [2:0]    _zz_3;
  wire       `UartStopType_defaultEncoding_type _zz_4;
  wire       `UartParityType_defaultEncoding_type _zz_5;
  wire                _zz_6;
  reg                 _zz_7;
  wire                _zz_8;
  reg                 _zz_9;
  wire       [7:0]    _zz_10;
  wire                _zz_11;
  wire       [31:0]   accel_io_state_out;
  wire                accel_io_ready;
  wire                uart_io_write_ready;
  wire                uart_io_read_valid;
  wire       [7:0]    uart_io_read_payload;
  wire                uart_io_uart_txd;
  wire                uart_io_readError;
  wire                uart_io_readBreak;
  wire                io_read_fifo_io_push_ready;
  wire                io_read_fifo_io_pop_valid;
  wire       [7:0]    io_read_fifo_io_pop_payload;
  wire       [2:0]    io_read_fifo_io_occupancy;
  wire       [2:0]    io_read_fifo_io_availability;
  wire                outQueue_io_push_ready;
  wire                outQueue_io_pop_valid;
  wire       [7:0]    outQueue_io_pop_payload;
  wire       [2:0]    outQueue_io_occupancy;
  wire       [2:0]    outQueue_io_availability;
  wire                _zz_12;
  wire                _zz_13;
  wire       [0:0]    _zz_14;
  wire       [5:0]    _zz_15;
  wire       [23:0]   _zz_16;
  reg        [31:0]   inreg;
  reg        [31:0]   outreg;
  reg        [19:0]   div_payload_regNextWhen;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  reg                 fsm_counter_willIncrement;
  wire                fsm_counter_willClear;
  reg        [5:0]    fsm_counter_valueNext;
  reg        [5:0]    fsm_counter_value;
  wire                fsm_counter_willOverflowIfInc;
  wire                fsm_counter_willOverflow;
  reg        `fsm_enumDefinition_defaultEncoding_type fsm_stateReg;
  reg        `fsm_enumDefinition_defaultEncoding_type fsm_stateNext;
  `ifndef SYNTHESIS
  reg [87:0] fsm_stateReg_string;
  reg [87:0] fsm_stateNext_string;
  `endif


  assign _zz_12 = (fsm_counter_value == 6'h0);
  assign _zz_13 = (io_read_fifo_io_pop_valid && _zz_7);
  assign _zz_14 = fsm_counter_willIncrement;
  assign _zz_15 = {5'd0, _zz_14};
  assign _zz_16 = (outreg >>> 8);
  ChaChaRegBased accel (
    .io_state_in     (inreg[31:0]               ), //i
    .io_state_out    (accel_io_state_out[31:0]  ), //o
    .io_cycle        (_zz_1                     ), //i
    .io_start        (_zz_2                     ), //i
    .io_ready        (accel_io_ready            ), //o
    .clk             (clk                       ), //i
    .reset           (reset                     )  //i
  );
  UartCtrl uart (
    .io_config_frame_dataLength    (_zz_3[2:0]                     ), //i
    .io_config_frame_stop          (_zz_4                          ), //i
    .io_config_frame_parity        (_zz_5[1:0]                     ), //i
    .io_config_clockDivider        (div_payload_regNextWhen[19:0]  ), //i
    .io_write_valid                (outQueue_io_pop_valid          ), //i
    .io_write_ready                (uart_io_write_ready            ), //o
    .io_write_payload              (outQueue_io_pop_payload[7:0]   ), //i
    .io_read_valid                 (uart_io_read_valid             ), //o
    .io_read_ready                 (io_read_fifo_io_push_ready     ), //i
    .io_read_payload               (uart_io_read_payload[7:0]      ), //o
    .io_uart_txd                   (uart_io_uart_txd               ), //o
    .io_uart_rxd                   (uart_rxd                       ), //i
    .io_readError                  (uart_io_readError              ), //o
    .io_writeBreak                 (_zz_6                          ), //i
    .io_readBreak                  (uart_io_readBreak              ), //o
    .clk                           (clk                            ), //i
    .reset                         (reset                          )  //i
  );
  StreamFifo io_read_fifo (
    .io_push_valid      (uart_io_read_valid                 ), //i
    .io_push_ready      (io_read_fifo_io_push_ready         ), //o
    .io_push_payload    (uart_io_read_payload[7:0]          ), //i
    .io_pop_valid       (io_read_fifo_io_pop_valid          ), //o
    .io_pop_ready       (_zz_7                              ), //i
    .io_pop_payload     (io_read_fifo_io_pop_payload[7:0]   ), //o
    .io_flush           (_zz_8                              ), //i
    .io_occupancy       (io_read_fifo_io_occupancy[2:0]     ), //o
    .io_availability    (io_read_fifo_io_availability[2:0]  ), //o
    .clk                (clk                                ), //i
    .reset              (reset                              )  //i
  );
  StreamFifo outQueue (
    .io_push_valid      (_zz_9                          ), //i
    .io_push_ready      (outQueue_io_push_ready         ), //o
    .io_push_payload    (_zz_10[7:0]                    ), //i
    .io_pop_valid       (outQueue_io_pop_valid          ), //o
    .io_pop_ready       (uart_io_write_ready            ), //i
    .io_pop_payload     (outQueue_io_pop_payload[7:0]   ), //o
    .io_flush           (_zz_11                         ), //i
    .io_occupancy       (outQueue_io_occupancy[2:0]     ), //o
    .io_availability    (outQueue_io_availability[2:0]  ), //o
    .clk                (clk                            ), //i
    .reset              (reset                          )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      `fsm_enumDefinition_defaultEncoding_fsm_BOOT : fsm_stateReg_string = "fsm_BOOT   ";
      `fsm_enumDefinition_defaultEncoding_fsm_IO : fsm_stateReg_string = "fsm_IO     ";
      `fsm_enumDefinition_defaultEncoding_fsm_CYCLE : fsm_stateReg_string = "fsm_CYCLE  ";
      `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE : fsm_stateReg_string = "fsm_PERMUTE";
      `fsm_enumDefinition_defaultEncoding_fsm_UPDATE : fsm_stateReg_string = "fsm_UPDATE ";
      default : fsm_stateReg_string = "???????????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      `fsm_enumDefinition_defaultEncoding_fsm_BOOT : fsm_stateNext_string = "fsm_BOOT   ";
      `fsm_enumDefinition_defaultEncoding_fsm_IO : fsm_stateNext_string = "fsm_IO     ";
      `fsm_enumDefinition_defaultEncoding_fsm_CYCLE : fsm_stateNext_string = "fsm_CYCLE  ";
      `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE : fsm_stateNext_string = "fsm_PERMUTE";
      `fsm_enumDefinition_defaultEncoding_fsm_UPDATE : fsm_stateNext_string = "fsm_UPDATE ";
      default : fsm_stateNext_string = "???????????";
    endcase
  end
  `endif

  always @ (*) begin
    _zz_1 = 1'b0;
    case(fsm_stateReg)
      `fsm_enumDefinition_defaultEncoding_fsm_IO : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_CYCLE : begin
        _zz_1 = 1'b1;
      end
      `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_UPDATE : begin
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    _zz_2 = 1'b0;
    case(fsm_stateReg)
      `fsm_enumDefinition_defaultEncoding_fsm_IO : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_CYCLE : begin
        if(accel_io_ready)begin
          if(_zz_12)begin
            _zz_2 = 1'b1;
          end
        end
      end
      `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_UPDATE : begin
      end
      default : begin
      end
    endcase
  end

  assign uart_txd = uart_io_uart_txd;
  assign _zz_3 = 3'b111;
  assign _zz_4 = `UartStopType_defaultEncoding_ONE;
  assign _zz_5 = `UartParityType_defaultEncoding_NONE;
  assign _zz_6 = 1'b0;
  always @ (*) begin
    _zz_9 = 1'b0;
    case(fsm_stateReg)
      `fsm_enumDefinition_defaultEncoding_fsm_IO : begin
        if(_zz_13)begin
          _zz_9 = 1'b1;
        end
      end
      `fsm_enumDefinition_defaultEncoding_fsm_CYCLE : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_UPDATE : begin
      end
      default : begin
      end
    endcase
  end

  assign _zz_10 = outreg[7 : 0];
  always @ (*) begin
    _zz_7 = 1'b0;
    case(fsm_stateReg)
      `fsm_enumDefinition_defaultEncoding_fsm_IO : begin
        _zz_7 = 1'b1;
      end
      `fsm_enumDefinition_defaultEncoding_fsm_CYCLE : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_UPDATE : begin
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @ (*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      `fsm_enumDefinition_defaultEncoding_fsm_IO : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_CYCLE : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_UPDATE : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  always @ (*) begin
    fsm_counter_willIncrement = 1'b0;
    case(fsm_stateReg)
      `fsm_enumDefinition_defaultEncoding_fsm_IO : begin
        if(_zz_13)begin
          fsm_counter_willIncrement = 1'b1;
        end
      end
      `fsm_enumDefinition_defaultEncoding_fsm_CYCLE : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE : begin
      end
      `fsm_enumDefinition_defaultEncoding_fsm_UPDATE : begin
      end
      default : begin
      end
    endcase
  end

  assign fsm_counter_willClear = 1'b0;
  assign fsm_counter_willOverflowIfInc = (fsm_counter_value == 6'h3f);
  assign fsm_counter_willOverflow = (fsm_counter_willOverflowIfInc && fsm_counter_willIncrement);
  always @ (*) begin
    fsm_counter_valueNext = (fsm_counter_value + _zz_15);
    if(fsm_counter_willClear)begin
      fsm_counter_valueNext = 6'h0;
    end
  end

  always @ (*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      `fsm_enumDefinition_defaultEncoding_fsm_IO : begin
        if(_zz_13)begin
          if((fsm_counter_value[1 : 0] == 2'b11))begin
            fsm_stateNext = `fsm_enumDefinition_defaultEncoding_fsm_CYCLE;
          end
        end
      end
      `fsm_enumDefinition_defaultEncoding_fsm_CYCLE : begin
        if(accel_io_ready)begin
          if(_zz_12)begin
            fsm_stateNext = `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE;
          end else begin
            fsm_stateNext = `fsm_enumDefinition_defaultEncoding_fsm_UPDATE;
          end
        end
      end
      `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE : begin
        if(accel_io_ready)begin
          fsm_stateNext = `fsm_enumDefinition_defaultEncoding_fsm_UPDATE;
        end
      end
      `fsm_enumDefinition_defaultEncoding_fsm_UPDATE : begin
        fsm_stateNext = `fsm_enumDefinition_defaultEncoding_fsm_IO;
      end
      default : begin
      end
    endcase
    if(fsm_wantStart)begin
      fsm_stateNext = `fsm_enumDefinition_defaultEncoding_fsm_IO;
    end
  end

  assign _zz_8 = 1'b0;
  assign _zz_11 = 1'b0;
  always @ (posedge clk) begin
    if(reset) begin
      inreg <= 32'h0;
      outreg <= 32'h0;
      div_payload_regNextWhen <= 20'h00015;
      fsm_counter_value <= 6'h0;
      fsm_stateReg <= `fsm_enumDefinition_defaultEncoding_fsm_BOOT;
    end else begin
      if(div_valid)begin
        div_payload_regNextWhen <= div_payload;
      end
      fsm_counter_value <= fsm_counter_valueNext;
      fsm_stateReg <= fsm_stateNext;
      case(fsm_stateReg)
        `fsm_enumDefinition_defaultEncoding_fsm_IO : begin
          if(_zz_13)begin
            inreg <= {io_read_fifo_io_pop_payload,inreg[31 : 8]};
            outreg <= {8'd0, _zz_16};
          end
        end
        `fsm_enumDefinition_defaultEncoding_fsm_CYCLE : begin
        end
        `fsm_enumDefinition_defaultEncoding_fsm_PERMUTE : begin
        end
        `fsm_enumDefinition_defaultEncoding_fsm_UPDATE : begin
          outreg <= accel_io_state_out;
        end
        default : begin
        end
      endcase
    end
  end


  initial begin
    $dumpfile("chacha_uart_accel.fst");
    $dumpvars(0, chacha_uart_accel);
  end

endmodule

//StreamFifo replaced by StreamFifo

module StreamFifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [7:0]    io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [7:0]    io_pop_payload,
  input               io_flush,
  output     [2:0]    io_occupancy,
  output     [2:0]    io_availability,
  input               clk,
  input               reset
);
  reg        [7:0]    _zz_3;
  wire       [0:0]    _zz_4;
  wire       [1:0]    _zz_5;
  wire       [0:0]    _zz_6;
  wire       [1:0]    _zz_7;
  wire       [1:0]    _zz_8;
  wire                _zz_9;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [1:0]    logic_pushPtr_valueNext;
  reg        [1:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [1:0]    logic_popPtr_valueNext;
  reg        [1:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_2;
  wire       [1:0]    logic_ptrDif;
  reg [7:0] logic_ram [0:3];

  assign _zz_4 = logic_pushPtr_willIncrement;
  assign _zz_5 = {1'd0, _zz_4};
  assign _zz_6 = logic_popPtr_willIncrement;
  assign _zz_7 = {1'd0, _zz_6};
  assign _zz_8 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_9 = 1'b1;
  always @ (posedge clk) begin
    if(_zz_9) begin
      _zz_3 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= io_push_payload;
    end
  end

  always @ (*) begin
    _zz_1 = 1'b0;
    if(logic_pushing)begin
      _zz_1 = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing)begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 2'b11);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @ (*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_5);
    if(logic_pushPtr_willClear)begin
      logic_pushPtr_valueNext = 2'b00;
    end
  end

  always @ (*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping)begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush)begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 2'b11);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @ (*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_7);
    if(logic_popPtr_willClear)begin
      logic_popPtr_valueNext = 2'b00;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_2 && (! logic_full))));
  assign io_pop_payload = _zz_3;
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_8};
  always @ (posedge clk) begin
    if(reset) begin
      logic_pushPtr_value <= 2'b00;
      logic_popPtr_value <= 2'b00;
      logic_risingOccupancy <= 1'b0;
      _zz_2 <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_2 <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if((logic_pushing != logic_popping))begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush)begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module UartCtrl (
  input      [2:0]    io_config_frame_dataLength,
  input      `UartStopType_defaultEncoding_type io_config_frame_stop,
  input      `UartParityType_defaultEncoding_type io_config_frame_parity,
  input      [19:0]   io_config_clockDivider,
  input               io_write_valid,
  output reg          io_write_ready,
  input      [7:0]    io_write_payload,
  output              io_read_valid,
  input               io_read_ready,
  output     [7:0]    io_read_payload,
  output              io_uart_txd,
  input               io_uart_rxd,
  output              io_readError,
  input               io_writeBreak,
  output              io_readBreak,
  input               clk,
  input               reset
);
  wire                _zz_1;
  wire                tx_io_write_ready;
  wire                tx_io_txd;
  wire                rx_io_read_valid;
  wire       [7:0]    rx_io_read_payload;
  wire                rx_io_rts;
  wire                rx_io_error;
  wire                rx_io_break;
  reg        [19:0]   clockDivider_counter;
  wire                clockDivider_tick;
  reg                 io_write_thrown_valid;
  wire                io_write_thrown_ready;
  wire       [7:0]    io_write_thrown_payload;
  `ifndef SYNTHESIS
  reg [23:0] io_config_frame_stop_string;
  reg [31:0] io_config_frame_parity_string;
  `endif


  UartCtrlTx tx (
    .io_configFrame_dataLength    (io_config_frame_dataLength[2:0]  ), //i
    .io_configFrame_stop          (io_config_frame_stop             ), //i
    .io_configFrame_parity        (io_config_frame_parity[1:0]      ), //i
    .io_samplingTick              (clockDivider_tick                ), //i
    .io_write_valid               (io_write_thrown_valid            ), //i
    .io_write_ready               (tx_io_write_ready                ), //o
    .io_write_payload             (io_write_thrown_payload[7:0]     ), //i
    .io_cts                       (_zz_1                            ), //i
    .io_txd                       (tx_io_txd                        ), //o
    .io_break                     (io_writeBreak                    ), //i
    .clk                          (clk                              ), //i
    .reset                        (reset                            )  //i
  );
  UartCtrlRx rx (
    .io_configFrame_dataLength    (io_config_frame_dataLength[2:0]  ), //i
    .io_configFrame_stop          (io_config_frame_stop             ), //i
    .io_configFrame_parity        (io_config_frame_parity[1:0]      ), //i
    .io_samplingTick              (clockDivider_tick                ), //i
    .io_read_valid                (rx_io_read_valid                 ), //o
    .io_read_ready                (io_read_ready                    ), //i
    .io_read_payload              (rx_io_read_payload[7:0]          ), //o
    .io_rxd                       (io_uart_rxd                      ), //i
    .io_rts                       (rx_io_rts                        ), //o
    .io_error                     (rx_io_error                      ), //o
    .io_break                     (rx_io_break                      ), //o
    .clk                          (clk                              ), //i
    .reset                        (reset                            )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_config_frame_stop)
      `UartStopType_defaultEncoding_ONE : io_config_frame_stop_string = "ONE";
      `UartStopType_defaultEncoding_TWO : io_config_frame_stop_string = "TWO";
      default : io_config_frame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_config_frame_parity)
      `UartParityType_defaultEncoding_NONE : io_config_frame_parity_string = "NONE";
      `UartParityType_defaultEncoding_EVEN : io_config_frame_parity_string = "EVEN";
      `UartParityType_defaultEncoding_ODD : io_config_frame_parity_string = "ODD ";
      default : io_config_frame_parity_string = "????";
    endcase
  end
  `endif

  assign clockDivider_tick = (clockDivider_counter == 20'h0);
  always @ (*) begin
    io_write_thrown_valid = io_write_valid;
    if(rx_io_break)begin
      io_write_thrown_valid = 1'b0;
    end
  end

  always @ (*) begin
    io_write_ready = io_write_thrown_ready;
    if(rx_io_break)begin
      io_write_ready = 1'b1;
    end
  end

  assign io_write_thrown_payload = io_write_payload;
  assign io_write_thrown_ready = tx_io_write_ready;
  assign io_read_valid = rx_io_read_valid;
  assign io_read_payload = rx_io_read_payload;
  assign io_uart_txd = tx_io_txd;
  assign io_readError = rx_io_error;
  assign _zz_1 = 1'b0;
  assign io_readBreak = rx_io_break;
  always @ (posedge clk) begin
    if(reset) begin
      clockDivider_counter <= 20'h0;
    end else begin
      clockDivider_counter <= (clockDivider_counter - 20'h00001);
      if(clockDivider_tick)begin
        clockDivider_counter <= io_config_clockDivider;
      end
    end
  end


endmodule

module ChaChaRegBased (
  input      [31:0]   io_state_in,
  output     [31:0]   io_state_out,
  input               io_cycle,
  input               io_start,
  output reg          io_ready,
  input               clk,
  input               reset
);
  wire       [0:0]    _zz_3;
  wire       [8:0]    _zz_4;
  reg        [31:0]   state_0;
  reg        [31:0]   state_1;
  reg        [31:0]   state_2;
  reg        [31:0]   state_3;
  reg        [31:0]   state_4;
  reg        [31:0]   state_5;
  reg        [31:0]   state_6;
  reg        [31:0]   state_7;
  reg        [31:0]   state_8;
  reg        [31:0]   state_9;
  reg        [31:0]   state_10;
  reg        [31:0]   state_11;
  reg        [31:0]   state_12;
  reg        [31:0]   state_13;
  reg        [31:0]   state_14;
  reg        [31:0]   state_15;
  reg        [31:0]   nextState_0;
  reg        [31:0]   nextState_1;
  reg        [31:0]   nextState_2;
  reg        [31:0]   nextState_3;
  reg        [31:0]   nextState_4;
  reg        [31:0]   nextState_5;
  reg        [31:0]   nextState_6;
  reg        [31:0]   nextState_7;
  reg        [31:0]   nextState_8;
  reg        [31:0]   nextState_9;
  reg        [31:0]   nextState_10;
  reg        [31:0]   nextState_11;
  reg        [31:0]   nextState_12;
  reg        [31:0]   nextState_13;
  reg        [31:0]   nextState_14;
  reg        [31:0]   nextState_15;
  reg                 counter_willIncrement;
  wire                counter_willClear;
  reg        [8:0]    counter_valueNext;
  reg        [8:0]    counter_value;
  wire                counter_willOverflowIfInc;
  wire                counter_willOverflow;
  wire       [31:0]   permutation_a;
  wire       [31:0]   permutation_b;
  wire       [31:0]   permutation_c;
  wire       [31:0]   permutation_d;
  wire       [1:0]    permutation_rot;
  wire       [31:0]   permutation_na;
  wire       [31:0]   permutation_nb;
  wire       [31:0]   permutation_nc;
  wire       [31:0]   permutation_nd;
  wire       [31:0]   _zz_1;
  reg        [31:0]   _zz_2;
  wire       [1:0]    qRound;
  wire       [4:0]    round;
  wire                odd;
  wire       [3:0]    permuteCnt;
  wire       [3:0]    lastPermute;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  reg        `fsm_enumDefinition_1_defaultEncoding_type fsm_stateReg;
  reg        `fsm_enumDefinition_1_defaultEncoding_type fsm_stateNext;
  `ifndef SYNTHESIS
  reg [87:0] fsm_stateReg_string;
  reg [87:0] fsm_stateNext_string;
  `endif


  assign _zz_3 = counter_willIncrement;
  assign _zz_4 = {8'd0, _zz_3};
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_BOOT : fsm_stateReg_string = "fsm_BOOT   ";
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : fsm_stateReg_string = "fsm_CYCLE  ";
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : fsm_stateReg_string = "fsm_PERMUTE";
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : fsm_stateReg_string = "fsm_TOODD  ";
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : fsm_stateReg_string = "fsm_TOEVEN ";
      default : fsm_stateReg_string = "???????????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      `fsm_enumDefinition_1_defaultEncoding_fsm_BOOT : fsm_stateNext_string = "fsm_BOOT   ";
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : fsm_stateNext_string = "fsm_CYCLE  ";
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : fsm_stateNext_string = "fsm_PERMUTE";
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : fsm_stateNext_string = "fsm_TOODD  ";
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : fsm_stateNext_string = "fsm_TOEVEN ";
      default : fsm_stateNext_string = "???????????";
    endcase
  end
  `endif

  always @ (*) begin
    nextState_0 = state_0;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_0 = state_1;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_0 = state_1;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_1 = state_1;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_1 = state_2;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_1 = state_2;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_2 = state_2;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_2 = state_3;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_2 = state_3;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_3 = state_3;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_3 = state_4;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_3 = permutation_na;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_4 = state_4;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_4 = state_5;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_4 = state_5;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_4 = state_5;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_4 = state_7;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_5 = state_5;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_5 = state_6;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_5 = state_6;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_5 = state_6;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_5 = state_4;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_6 = state_6;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_6 = state_7;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_6 = state_7;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_6 = state_7;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_6 = state_5;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_7 = state_7;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_7 = state_8;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_7 = permutation_nb;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_7 = state_4;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_7 = state_6;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_8 = state_8;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_8 = state_9;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_8 = state_9;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_8 = state_10;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_8 = state_10;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_9 = state_9;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_9 = state_10;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_9 = state_10;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_9 = state_11;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_9 = state_11;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_10 = state_10;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_10 = state_11;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_10 = state_11;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_10 = state_8;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_10 = state_8;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_11 = state_11;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_11 = state_12;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_11 = permutation_nc;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_11 = state_9;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_11 = state_9;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_12 = state_12;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_12 = state_13;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_12 = state_13;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_12 = state_15;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_12 = state_13;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_13 = state_13;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_13 = state_14;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_13 = state_14;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_13 = state_12;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_13 = state_14;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_14 = state_14;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_14 = state_15;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_14 = state_15;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_14 = state_13;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_14 = state_15;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    nextState_15 = state_15;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_cycle)begin
          nextState_15 = io_state_in;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        nextState_15 = permutation_nd;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        nextState_15 = state_14;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        nextState_15 = state_12;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    counter_willIncrement = 1'b0;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        counter_willIncrement = 1'b1;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
      end
      default : begin
      end
    endcase
  end

  assign counter_willClear = 1'b0;
  assign counter_willOverflowIfInc = (counter_value == 9'h13f);
  assign counter_willOverflow = (counter_willOverflowIfInc && counter_willIncrement);
  always @ (*) begin
    if(counter_willOverflow)begin
      counter_valueNext = 9'h0;
    end else begin
      counter_valueNext = (counter_value + _zz_4);
    end
    if(counter_willClear)begin
      counter_valueNext = 9'h0;
    end
  end

  assign permutation_nc = (permutation_a + permutation_b);
  assign permutation_nd = permutation_b;
  assign permutation_na = permutation_c;
  assign _zz_1 = (permutation_nc ^ permutation_d);
  always @ (*) begin
    case(permutation_rot)
      2'b00 : begin
        _zz_2 = {_zz_1[15 : 0],_zz_1[31 : 16]};
      end
      2'b01 : begin
        _zz_2 = {_zz_1[19 : 0],_zz_1[31 : 20]};
      end
      2'b10 : begin
        _zz_2 = {_zz_1[23 : 0],_zz_1[31 : 24]};
      end
      default : begin
        _zz_2 = {_zz_1[24 : 0],_zz_1[31 : 25]};
      end
    endcase
  end

  assign permutation_nb = _zz_2;
  assign permutation_a = state_0;
  assign permutation_b = state_4;
  assign permutation_c = state_8;
  assign permutation_d = state_12;
  assign permutation_rot = counter_value[3 : 2];
  assign qRound = counter_value[1 : 0];
  assign round = counter_value[8 : 4];
  assign odd = round[0];
  assign permuteCnt = counter_value[3 : 0];
  assign lastPermute = 4'b1111;
  assign io_state_out = state_0;
  always @ (*) begin
    io_ready = 1'b0;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        io_ready = 1'b1;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @ (*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  always @ (*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE : begin
        if(io_start)begin
          fsm_stateNext = `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE;
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE : begin
        if((permuteCnt == lastPermute))begin
          if(odd)begin
            fsm_stateNext = `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN;
          end else begin
            fsm_stateNext = `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD;
          end
        end
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOODD : begin
        fsm_stateNext = `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE;
      end
      `fsm_enumDefinition_1_defaultEncoding_fsm_TOEVEN : begin
        if((counter_value == 9'h0))begin
          fsm_stateNext = `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE;
        end else begin
          fsm_stateNext = `fsm_enumDefinition_1_defaultEncoding_fsm_PERMUTE;
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart)begin
      fsm_stateNext = `fsm_enumDefinition_1_defaultEncoding_fsm_CYCLE;
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      state_0 <= 32'h0;
      state_1 <= 32'h0;
      state_2 <= 32'h0;
      state_3 <= 32'h0;
      state_4 <= 32'h0;
      state_5 <= 32'h0;
      state_6 <= 32'h0;
      state_7 <= 32'h0;
      state_8 <= 32'h0;
      state_9 <= 32'h0;
      state_10 <= 32'h0;
      state_11 <= 32'h0;
      state_12 <= 32'h0;
      state_13 <= 32'h0;
      state_14 <= 32'h0;
      state_15 <= 32'h0;
      counter_value <= 9'h0;
      fsm_stateReg <= `fsm_enumDefinition_1_defaultEncoding_fsm_BOOT;
    end else begin
      state_0 <= nextState_0;
      state_1 <= nextState_1;
      state_2 <= nextState_2;
      state_3 <= nextState_3;
      state_4 <= nextState_4;
      state_5 <= nextState_5;
      state_6 <= nextState_6;
      state_7 <= nextState_7;
      state_8 <= nextState_8;
      state_9 <= nextState_9;
      state_10 <= nextState_10;
      state_11 <= nextState_11;
      state_12 <= nextState_12;
      state_13 <= nextState_13;
      state_14 <= nextState_14;
      state_15 <= nextState_15;
      counter_value <= counter_valueNext;
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module UartCtrlRx (
  input      [2:0]    io_configFrame_dataLength,
  input      `UartStopType_defaultEncoding_type io_configFrame_stop,
  input      `UartParityType_defaultEncoding_type io_configFrame_parity,
  input               io_samplingTick,
  output              io_read_valid,
  input               io_read_ready,
  output     [7:0]    io_read_payload,
  input               io_rxd,
  output              io_rts,
  output reg          io_error,
  output              io_break,
  input               clk,
  input               reset
);
  wire                io_rxd_buffercc_io_dataOut;
  wire                _zz_2;
  wire                _zz_3;
  wire                _zz_4;
  wire                _zz_5;
  wire       [0:0]    _zz_6;
  wire       [2:0]    _zz_7;
  wire                _zz_8;
  wire                _zz_9;
  wire                _zz_10;
  wire                _zz_11;
  wire                _zz_12;
  wire                _zz_13;
  wire                _zz_14;
  reg                 _zz_1;
  wire                sampler_synchroniser;
  wire                sampler_samples_0;
  reg                 sampler_samples_1;
  reg                 sampler_samples_2;
  reg                 sampler_samples_3;
  reg                 sampler_samples_4;
  reg                 sampler_value;
  reg                 sampler_tick;
  reg        [2:0]    bitTimer_counter;
  reg                 bitTimer_tick;
  reg        [2:0]    bitCounter_value;
  reg        [6:0]    break_counter;
  wire                break_valid;
  reg        `UartCtrlRxState_defaultEncoding_type stateMachine_state;
  reg                 stateMachine_parity;
  reg        [7:0]    stateMachine_shifter;
  reg                 stateMachine_validReg;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  `endif


  assign _zz_2 = (stateMachine_parity == sampler_value);
  assign _zz_3 = (! sampler_value);
  assign _zz_4 = ((sampler_tick && (! sampler_value)) && (! break_valid));
  assign _zz_5 = (bitCounter_value == io_configFrame_dataLength);
  assign _zz_6 = ((io_configFrame_stop == `UartStopType_defaultEncoding_ONE) ? 1'b0 : 1'b1);
  assign _zz_7 = {2'd0, _zz_6};
  assign _zz_8 = ((((1'b0 || ((_zz_13 && sampler_samples_1) && sampler_samples_2)) || (((_zz_14 && sampler_samples_0) && sampler_samples_1) && sampler_samples_3)) || (((1'b1 && sampler_samples_0) && sampler_samples_2) && sampler_samples_3)) || (((1'b1 && sampler_samples_1) && sampler_samples_2) && sampler_samples_3));
  assign _zz_9 = (((1'b1 && sampler_samples_0) && sampler_samples_1) && sampler_samples_4);
  assign _zz_10 = ((1'b1 && sampler_samples_0) && sampler_samples_2);
  assign _zz_11 = (1'b1 && sampler_samples_1);
  assign _zz_12 = 1'b1;
  assign _zz_13 = (1'b1 && sampler_samples_0);
  assign _zz_14 = 1'b1;
  BufferCC io_rxd_buffercc (
    .io_dataIn     (io_rxd                      ), //i
    .io_dataOut    (io_rxd_buffercc_io_dataOut  ), //o
    .clk           (clk                         ), //i
    .reset         (reset                       )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_configFrame_stop)
      `UartStopType_defaultEncoding_ONE : io_configFrame_stop_string = "ONE";
      `UartStopType_defaultEncoding_TWO : io_configFrame_stop_string = "TWO";
      default : io_configFrame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_configFrame_parity)
      `UartParityType_defaultEncoding_NONE : io_configFrame_parity_string = "NONE";
      `UartParityType_defaultEncoding_EVEN : io_configFrame_parity_string = "EVEN";
      `UartParityType_defaultEncoding_ODD : io_configFrame_parity_string = "ODD ";
      default : io_configFrame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(stateMachine_state)
      `UartCtrlRxState_defaultEncoding_IDLE : stateMachine_state_string = "IDLE  ";
      `UartCtrlRxState_defaultEncoding_START : stateMachine_state_string = "START ";
      `UartCtrlRxState_defaultEncoding_DATA : stateMachine_state_string = "DATA  ";
      `UartCtrlRxState_defaultEncoding_PARITY : stateMachine_state_string = "PARITY";
      `UartCtrlRxState_defaultEncoding_STOP : stateMachine_state_string = "STOP  ";
      default : stateMachine_state_string = "??????";
    endcase
  end
  `endif

  always @ (*) begin
    io_error = 1'b0;
    case(stateMachine_state)
      `UartCtrlRxState_defaultEncoding_IDLE : begin
      end
      `UartCtrlRxState_defaultEncoding_START : begin
      end
      `UartCtrlRxState_defaultEncoding_DATA : begin
      end
      `UartCtrlRxState_defaultEncoding_PARITY : begin
        if(bitTimer_tick)begin
          if(! _zz_2) begin
            io_error = 1'b1;
          end
        end
      end
      default : begin
        if(bitTimer_tick)begin
          if(_zz_3)begin
            io_error = 1'b1;
          end
        end
      end
    endcase
  end

  assign io_rts = _zz_1;
  assign sampler_synchroniser = io_rxd_buffercc_io_dataOut;
  assign sampler_samples_0 = sampler_synchroniser;
  always @ (*) begin
    bitTimer_tick = 1'b0;
    if(sampler_tick)begin
      if((bitTimer_counter == 3'b000))begin
        bitTimer_tick = 1'b1;
      end
    end
  end

  assign break_valid = (break_counter == 7'h68);
  assign io_break = break_valid;
  assign io_read_valid = stateMachine_validReg;
  assign io_read_payload = stateMachine_shifter;
  always @ (posedge clk) begin
    if(reset) begin
      _zz_1 <= 1'b0;
      sampler_samples_1 <= 1'b1;
      sampler_samples_2 <= 1'b1;
      sampler_samples_3 <= 1'b1;
      sampler_samples_4 <= 1'b1;
      sampler_value <= 1'b1;
      sampler_tick <= 1'b0;
      break_counter <= 7'h0;
      stateMachine_state <= `UartCtrlRxState_defaultEncoding_IDLE;
      stateMachine_validReg <= 1'b0;
    end else begin
      _zz_1 <= (! io_read_ready);
      if(io_samplingTick)begin
        sampler_samples_1 <= sampler_samples_0;
      end
      if(io_samplingTick)begin
        sampler_samples_2 <= sampler_samples_1;
      end
      if(io_samplingTick)begin
        sampler_samples_3 <= sampler_samples_2;
      end
      if(io_samplingTick)begin
        sampler_samples_4 <= sampler_samples_3;
      end
      sampler_value <= ((((((_zz_8 || _zz_9) || (_zz_10 && sampler_samples_4)) || ((_zz_11 && sampler_samples_2) && sampler_samples_4)) || (((_zz_12 && sampler_samples_0) && sampler_samples_3) && sampler_samples_4)) || (((1'b1 && sampler_samples_1) && sampler_samples_3) && sampler_samples_4)) || (((1'b1 && sampler_samples_2) && sampler_samples_3) && sampler_samples_4));
      sampler_tick <= io_samplingTick;
      if(sampler_value)begin
        break_counter <= 7'h0;
      end else begin
        if((io_samplingTick && (! break_valid)))begin
          break_counter <= (break_counter + 7'h01);
        end
      end
      stateMachine_validReg <= 1'b0;
      case(stateMachine_state)
        `UartCtrlRxState_defaultEncoding_IDLE : begin
          if(_zz_4)begin
            stateMachine_state <= `UartCtrlRxState_defaultEncoding_START;
          end
        end
        `UartCtrlRxState_defaultEncoding_START : begin
          if(bitTimer_tick)begin
            stateMachine_state <= `UartCtrlRxState_defaultEncoding_DATA;
            if((sampler_value == 1'b1))begin
              stateMachine_state <= `UartCtrlRxState_defaultEncoding_IDLE;
            end
          end
        end
        `UartCtrlRxState_defaultEncoding_DATA : begin
          if(bitTimer_tick)begin
            if(_zz_5)begin
              if((io_configFrame_parity == `UartParityType_defaultEncoding_NONE))begin
                stateMachine_state <= `UartCtrlRxState_defaultEncoding_STOP;
                stateMachine_validReg <= 1'b1;
              end else begin
                stateMachine_state <= `UartCtrlRxState_defaultEncoding_PARITY;
              end
            end
          end
        end
        `UartCtrlRxState_defaultEncoding_PARITY : begin
          if(bitTimer_tick)begin
            if(_zz_2)begin
              stateMachine_state <= `UartCtrlRxState_defaultEncoding_STOP;
              stateMachine_validReg <= 1'b1;
            end else begin
              stateMachine_state <= `UartCtrlRxState_defaultEncoding_IDLE;
            end
          end
        end
        default : begin
          if(bitTimer_tick)begin
            if(_zz_3)begin
              stateMachine_state <= `UartCtrlRxState_defaultEncoding_IDLE;
            end else begin
              if((bitCounter_value == _zz_7))begin
                stateMachine_state <= `UartCtrlRxState_defaultEncoding_IDLE;
              end
            end
          end
        end
      endcase
    end
  end

  always @ (posedge clk) begin
    if(sampler_tick)begin
      bitTimer_counter <= (bitTimer_counter - 3'b001);
    end
    if(bitTimer_tick)begin
      bitCounter_value <= (bitCounter_value + 3'b001);
    end
    if(bitTimer_tick)begin
      stateMachine_parity <= (stateMachine_parity ^ sampler_value);
    end
    case(stateMachine_state)
      `UartCtrlRxState_defaultEncoding_IDLE : begin
        if(_zz_4)begin
          bitTimer_counter <= 3'b010;
        end
      end
      `UartCtrlRxState_defaultEncoding_START : begin
        if(bitTimer_tick)begin
          bitCounter_value <= 3'b000;
          stateMachine_parity <= (io_configFrame_parity == `UartParityType_defaultEncoding_ODD);
        end
      end
      `UartCtrlRxState_defaultEncoding_DATA : begin
        if(bitTimer_tick)begin
          stateMachine_shifter[bitCounter_value] <= sampler_value;
          if(_zz_5)begin
            bitCounter_value <= 3'b000;
          end
        end
      end
      `UartCtrlRxState_defaultEncoding_PARITY : begin
        if(bitTimer_tick)begin
          bitCounter_value <= 3'b000;
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module UartCtrlTx (
  input      [2:0]    io_configFrame_dataLength,
  input      `UartStopType_defaultEncoding_type io_configFrame_stop,
  input      `UartParityType_defaultEncoding_type io_configFrame_parity,
  input               io_samplingTick,
  input               io_write_valid,
  output reg          io_write_ready,
  input      [7:0]    io_write_payload,
  input               io_cts,
  output              io_txd,
  input               io_break,
  input               clk,
  input               reset
);
  wire                _zz_2;
  wire       [0:0]    _zz_3;
  wire       [2:0]    _zz_4;
  wire       [0:0]    _zz_5;
  wire       [2:0]    _zz_6;
  reg                 clockDivider_counter_willIncrement;
  wire                clockDivider_counter_willClear;
  reg        [2:0]    clockDivider_counter_valueNext;
  reg        [2:0]    clockDivider_counter_value;
  wire                clockDivider_counter_willOverflowIfInc;
  wire                clockDivider_counter_willOverflow;
  reg        [2:0]    tickCounter_value;
  reg        `UartCtrlTxState_defaultEncoding_type stateMachine_state;
  reg                 stateMachine_parity;
  reg                 stateMachine_txd;
  reg                 _zz_1;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  `endif


  assign _zz_2 = (tickCounter_value == io_configFrame_dataLength);
  assign _zz_3 = clockDivider_counter_willIncrement;
  assign _zz_4 = {2'd0, _zz_3};
  assign _zz_5 = ((io_configFrame_stop == `UartStopType_defaultEncoding_ONE) ? 1'b0 : 1'b1);
  assign _zz_6 = {2'd0, _zz_5};
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_configFrame_stop)
      `UartStopType_defaultEncoding_ONE : io_configFrame_stop_string = "ONE";
      `UartStopType_defaultEncoding_TWO : io_configFrame_stop_string = "TWO";
      default : io_configFrame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_configFrame_parity)
      `UartParityType_defaultEncoding_NONE : io_configFrame_parity_string = "NONE";
      `UartParityType_defaultEncoding_EVEN : io_configFrame_parity_string = "EVEN";
      `UartParityType_defaultEncoding_ODD : io_configFrame_parity_string = "ODD ";
      default : io_configFrame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(stateMachine_state)
      `UartCtrlTxState_defaultEncoding_IDLE : stateMachine_state_string = "IDLE  ";
      `UartCtrlTxState_defaultEncoding_START : stateMachine_state_string = "START ";
      `UartCtrlTxState_defaultEncoding_DATA : stateMachine_state_string = "DATA  ";
      `UartCtrlTxState_defaultEncoding_PARITY : stateMachine_state_string = "PARITY";
      `UartCtrlTxState_defaultEncoding_STOP : stateMachine_state_string = "STOP  ";
      default : stateMachine_state_string = "??????";
    endcase
  end
  `endif

  always @ (*) begin
    clockDivider_counter_willIncrement = 1'b0;
    if(io_samplingTick)begin
      clockDivider_counter_willIncrement = 1'b1;
    end
  end

  assign clockDivider_counter_willClear = 1'b0;
  assign clockDivider_counter_willOverflowIfInc = (clockDivider_counter_value == 3'b111);
  assign clockDivider_counter_willOverflow = (clockDivider_counter_willOverflowIfInc && clockDivider_counter_willIncrement);
  always @ (*) begin
    clockDivider_counter_valueNext = (clockDivider_counter_value + _zz_4);
    if(clockDivider_counter_willClear)begin
      clockDivider_counter_valueNext = 3'b000;
    end
  end

  always @ (*) begin
    stateMachine_txd = 1'b1;
    case(stateMachine_state)
      `UartCtrlTxState_defaultEncoding_IDLE : begin
      end
      `UartCtrlTxState_defaultEncoding_START : begin
        stateMachine_txd = 1'b0;
      end
      `UartCtrlTxState_defaultEncoding_DATA : begin
        stateMachine_txd = io_write_payload[tickCounter_value];
      end
      `UartCtrlTxState_defaultEncoding_PARITY : begin
        stateMachine_txd = stateMachine_parity;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    io_write_ready = io_break;
    case(stateMachine_state)
      `UartCtrlTxState_defaultEncoding_IDLE : begin
      end
      `UartCtrlTxState_defaultEncoding_START : begin
      end
      `UartCtrlTxState_defaultEncoding_DATA : begin
        if(clockDivider_counter_willOverflow)begin
          if(_zz_2)begin
            io_write_ready = 1'b1;
          end
        end
      end
      `UartCtrlTxState_defaultEncoding_PARITY : begin
      end
      default : begin
      end
    endcase
  end

  assign io_txd = _zz_1;
  always @ (posedge clk) begin
    if(reset) begin
      clockDivider_counter_value <= 3'b000;
      stateMachine_state <= `UartCtrlTxState_defaultEncoding_IDLE;
      _zz_1 <= 1'b1;
    end else begin
      clockDivider_counter_value <= clockDivider_counter_valueNext;
      case(stateMachine_state)
        `UartCtrlTxState_defaultEncoding_IDLE : begin
          if(((io_write_valid && (! io_cts)) && clockDivider_counter_willOverflow))begin
            stateMachine_state <= `UartCtrlTxState_defaultEncoding_START;
          end
        end
        `UartCtrlTxState_defaultEncoding_START : begin
          if(clockDivider_counter_willOverflow)begin
            stateMachine_state <= `UartCtrlTxState_defaultEncoding_DATA;
          end
        end
        `UartCtrlTxState_defaultEncoding_DATA : begin
          if(clockDivider_counter_willOverflow)begin
            if(_zz_2)begin
              if((io_configFrame_parity == `UartParityType_defaultEncoding_NONE))begin
                stateMachine_state <= `UartCtrlTxState_defaultEncoding_STOP;
              end else begin
                stateMachine_state <= `UartCtrlTxState_defaultEncoding_PARITY;
              end
            end
          end
        end
        `UartCtrlTxState_defaultEncoding_PARITY : begin
          if(clockDivider_counter_willOverflow)begin
            stateMachine_state <= `UartCtrlTxState_defaultEncoding_STOP;
          end
        end
        default : begin
          if(clockDivider_counter_willOverflow)begin
            if((tickCounter_value == _zz_6))begin
              stateMachine_state <= (io_write_valid ? `UartCtrlTxState_defaultEncoding_START : `UartCtrlTxState_defaultEncoding_IDLE);
            end
          end
        end
      endcase
      _zz_1 <= (stateMachine_txd && (! io_break));
    end
  end

  always @ (posedge clk) begin
    if(clockDivider_counter_willOverflow)begin
      tickCounter_value <= (tickCounter_value + 3'b001);
    end
    if(clockDivider_counter_willOverflow)begin
      stateMachine_parity <= (stateMachine_parity ^ stateMachine_txd);
    end
    case(stateMachine_state)
      `UartCtrlTxState_defaultEncoding_IDLE : begin
      end
      `UartCtrlTxState_defaultEncoding_START : begin
        if(clockDivider_counter_willOverflow)begin
          stateMachine_parity <= (io_configFrame_parity == `UartParityType_defaultEncoding_ODD);
          tickCounter_value <= 3'b000;
        end
      end
      `UartCtrlTxState_defaultEncoding_DATA : begin
        if(clockDivider_counter_willOverflow)begin
          if(_zz_2)begin
            tickCounter_value <= 3'b000;
          end
        end
      end
      `UartCtrlTxState_defaultEncoding_PARITY : begin
        if(clockDivider_counter_willOverflow)begin
          tickCounter_value <= 3'b000;
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module BufferCC (
  input               io_dataIn,
  output              io_dataOut,
  input               clk,
  input               reset
);
  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @ (posedge clk) begin
    if(reset) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule
