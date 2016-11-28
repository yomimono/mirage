open Result
let say pp = Format.fprintf pp

let pp_console_error pp = function
  | `Invalid_console str -> say pp "invalid console %s" str

let unspecified pp m = say pp "unspecified error - %s" m

let pp_network_error pp = function
  | `Msg message   -> unspecified pp message
  | `Unimplemented -> say pp "operation not yet implemented"
  | `Disconnected  -> say pp "device is disconnected"

let pp_ethif_error = pp_network_error

let pp_ip_error = pp_ethif_error

let pp_icmp_error pp = function
  | `Msg message   -> unspecified pp message
  | `Routing message -> say pp "routing error: %s" message

let pp_udp_error pp (`Msg message) = unspecified pp message

let pp_tcp_error pp = function
  | `Msg message   -> unspecified pp message
  | `Timeout       -> say pp "connection attempt timed out"
  | `Refused       -> say pp "connection attempt was refused"

let pp_flow_error pp = function
  | `Msg message   -> unspecified pp message

let pp_flow_write_error pp = function
  | `Msg message   -> unspecified pp message
  | `Closed        -> say pp "attempted to write to a closed flow"

let pp_block_error pp = function
  | `Msg message   -> unspecified pp message
  | `Unimplemented -> say pp "operation not yet implemented"
  | `Disconnected  -> say pp "a required device was disconnected"

let pp_block_write_error pp = function
  | `Msg message   -> unspecified pp message
  | `Unimplemented -> say pp "operation not yet implemented"
  | `Disconnected  -> say pp "a required device was disconnected"
  | `Is_read_only  -> say pp "attempted to write to a read-only disk"

let pp_fs_error pp = function
    | `Msg message         -> unspecified pp message
    | `Is_a_directory      -> say pp "is a directory"
    | `Not_a_directory     -> say pp "is not a directory"
    | `No_directory_entry  -> say pp "a directory in the path does not exist"
    | `Format_unknown      -> say pp "the device is not formatted for this filesystem"

let pp_fs_write_error pp = function
  | `Msg message         -> unspecified pp message
  | `Is_a_directory      -> say pp "is a directory"
  | `Not_a_directory     -> say pp "is not a directory"
  | `Directory_not_empty -> say pp "directory is not empty"
  | `No_directory_entry  -> say pp "a directory in the path does not exist"
  | `File_already_exists -> say pp "file already exists"
  | `No_space            -> say pp "device has no more free space"

let pp_kv_ro_error pp = function
  | `Msg message   -> unspecified pp message
  | `Unknown_key   -> say pp "key not present in the store"

let reduce = function
  | Ok () -> Ok ()
  | Error (`Msg _) as e -> e
  | Error `Unimplemented -> Error (`Msg "unimplemented functionality discovered")
  | Error `Disconnected -> Error (`Msg "a required device was disconnected")
