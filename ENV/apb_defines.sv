///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME  : apb_defines.sv
//AUTHOR NAME: Rohan Diwan
//MODULE NAME: definitions
//DESCRIPTION: All the definitons are placed over here
//Version: 1
//Date: 14-05-2026
//Time: 9:00 am
//
/////////////////////////////////////
`ifndef APB_DEFINES_SV
`define APB_DEFINES_SV

// ADDRESS WIDTH
`define ADDR_WIDTH 16

// DERIVED PARAMETERS
`define DATA_WIDTH 32

`define DEPTH (1 << `ADDR_WIDTH)

//DEFAULT VALUE OF PREADY AT RESET
`define DEFAULT_PREADY 1'b0

`define ADDR_MAX {`ADDR_WIDTH{1'b1}}

`define DATA_MAX {`DATA_WIDTH{1'b1}}

// TEST CONTROL
`define NUM_TRANSACTIONS 1000

//IMPLEMENT WAIT STATES AT TRANSACTION COUNT
//`define WAIT_AFTER_TRANS 1

//Wait count
`define WAIT_CNT 2

`define INJECT_WAIT_AT 0

`define SV_DO_WITH(OBJ, CNSTR) \
begin \
OBJ = new();\
trans = OBJ;\
if (!OBJ.randomize() with CNSTR) \
  $error("Randomization Failed!"); \
send_item(); \
end

`define SV_DO(OBJ) \
OBJ = new();\
trans = OBJ;\
if (!OBJ.randomize()) \
  $error("Randomization Failed!"); \
send_item();

`define SV_DO_ON(TEST_NAME, TEST_OBJ_NAME) \
if ($test$plusargs(`"TEST_NAME`")) begin\
  TEST_OBJ_NAME = new();\
  void'(``TEST_OBJ_NAME``.randomize()); \
  env.gen = ``TEST_OBJ_NAME``; \
end

`define SV_DO_ON_WITH(TEST_NAME, TEST_OBJ_NAME, CNSTR) \
if ($test$plusargs(`"TEST_NAME`")) begin \
  TEST_OBJ_NAME = new(); \
  void'(``TEST_OBJ_NAME``.randomize() with ``CNSTR``);  \
   env.gen = ``TEST_OBJ_NAME``; \
end

`endif
