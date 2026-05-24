///////////////////////////////////
//
//------------------HEADER--------------------- 
//FILE NAME: sv_sequence_item.sv 
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: sv_sequence_item
//DESCRIPTION: this is the base class used to create a new class transaction by extending it in the transaction class
//Version: 1
//Date: 14-05-2026
//Time: 9:30 pm
//
/////////////////////////////////////


`ifndef SV_SEQUENCE_ITEM
`define SV_SEQUENCE_ITEM

  //This enforces how the objects are copied
  //              how the objects are duplicated
  //              how the ojects are printed
virtual class sv_sequence_item;

  // It copies contents from one object to another object
  virtual function void copy(sv_sequence_item rhs); //This enforces how the objects are copied
  endfunction

  // create a new object and copy data inside it
  pure virtual function sv_sequence_item clone(); //This enforces how the objects are duplicated
  

  // print contents 
  pure virtual function void print(string id = ""); //This enforces how the objects are printed
 

endclass

`endif

