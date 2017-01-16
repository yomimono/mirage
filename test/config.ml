open Mirage

let true_v = Functoria_key.pure true
let false_v = Functoria_key.pure false

(* not tested: qubes and socket backends, which are dependent on the backend *)
(* qubes network should be tested when the user invokes `mirage configure -t qubes` via the generic_stackv4 call below *)
(* socket network can be tested with `mirage configure -t unix --stack_static_network-net=socket or mirage configure -t unix --stack_dhcp_network-net=socket *)
let bare_network = netif ~group:"bare_network" "0"
let stack_dhcp_network = netif ~group:"stack_dhcp_network" "1"
let stack_static_network = netif ~group:"stack_static_network" "2"
let stack_static = generic_stackv4 ~dhcp_key:false_v ~group:"stack_static_network" stack_static_network
let stack_dhcp = generic_stackv4 ~dhcp_key:true_v ~group:"stack_dhcp_network" stack_dhcp_network

let our_time = default_time
let our_pclock = default_posix_clock
let our_mclock = default_monotonic_clock

(* logs are automatically passed by `mirage` and referenced in unikernel.ml *)

let std_random = stdlib_random
let fortuna_random = nocrypto_random

let our_console = default_console
let our_block = block_of_file "oh_no.txt"
let our_crunch = crunch "for_crunch"
let block_archive = archive @@ block_of_file "block_for_archive"
let file_archive = archive_of_files ~dir:"files_for_archive" ()

let fat_of_block = fat our_block
let file_fat = fat_of_files ~dir:"files_for_fat" ()
let kv_of_fat = kv_ro_of_fs fat_of_block
let generic_kvro = generic_kv_ro "files_for_generic_kv_ro"

let stack_static_resolver = resolver_dns stack_static
(* ideally we'd also test the Unix resolver, but there's
 * not a nice way to do that portably at the moment *)

let syslog_config = {
  hostname = "localhost";
  server = Ipaddr.V4.of_string_exn "127.0.0.1";
  port = Some 514;
  truncate = Some 80;
}

let our_syslog_udp = syslog_udp syslog_config stack_static
let our_syslog_tcp = syslog_tcp syslog_config stack_static
let our_syslog_tls = syslog_tls syslog_config stack_static generic_kvro

let plaintext_conduit = conduit_direct ~tls:false stack_static
let tls_conduit = conduit_direct ~tls:true stack_static

let our_http = http_server plaintext_conduit

let main = foreign "Unikernel.Main"
  (
   time @->
   pclock @-> mclock @->
   network @->
   stackv4 @-> stackv4 @->
   random @-> random @->
   console @->
   block @->
   kv_ro @-> kv_ro @-> kv_ro @->
   fs @-> fs @->
   kv_ro @->
   kv_ro @->
   resolver @->
   syslog @-> syslog @-> syslog @->
   conduit @-> conduit @->
   http @->
   job
  )

let () =
  register "noop" [
    main $ our_time $ our_pclock $ our_mclock $
    bare_network $ stack_static $ stack_dhcp $
    stdlib_random $ fortuna_random $
    our_console $
    our_block $
    our_crunch $ block_archive $ file_archive $
    fat_of_block $
    file_fat $
    kv_of_fat $
    generic_kvro $
    stack_static_resolver $
    our_syslog_udp $ our_syslog_tcp $ our_syslog_tls $
    plaintext_conduit $ tls_conduit $
    our_http
  ]
