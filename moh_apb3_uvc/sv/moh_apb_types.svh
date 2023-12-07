`ifndef __MOH_APB_TYPES__SVH
`define __MOH_APB_TYPES__SVH

typedef bit[31:0] t_moh_apb_haddr;
typedef bit[31:0] t_moh_apb_hdata;

typedef enum bit [1:0] {REQUESTER, COMPLETER, MULTI, PASSIVE}  t_uvc_mode;
typedef enum bit       {READ, WRITE}                           t_dir;// The direction of the transaction
typedef enum bit       {GOOD_RESP, BAD_RESP}                   t_resp; // Type of response from the completer
typedef enum bit [1:0] {IDLE, SETUP, ACCESS}                   t_phase; // which phase of the APB are we in right now

`endif // __MOH_APB_TYPES_TYPES__SVH
