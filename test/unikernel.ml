module Main
  (Time : Mirage_time_lwt.S)
  (Pclock : Mirage_clock_lwt.PCLOCK)
  (Mclock : Mirage_clock_lwt.MCLOCK)
  (Network : Mirage_net_lwt.S)
  (Stack : Mirage_stack_lwt.V4)
  (Stack : Mirage_stack_lwt.V4)
  (StdlibRandom : Mirage_random.S)
  (FortunaRandom : Mirage_random.S)
  (Console : Mirage_console_lwt.S)
  (Block : Mirage_block_lwt.S)
  (Crunch : Mirage_kv_lwt.RO)
  (Ar1 : Mirage_kv_lwt.RO)
  (Ar2 : Mirage_kv_lwt.RO)
  (Fs1 : Mirage_fs_lwt.S)
  (Fs2 : Mirage_fs_lwt.S)
  (Kv_ro_of_fs : Mirage_kv_lwt.RO)
  (Generic_kv_ro : Mirage_kv_lwt.RO)
  (Resolver : Resolver_lwt.S)
  (* module type of Logs_syslog_mirage doesn't work here, and there doesn't seem to be
   * a Logs_syslog.S to target either *)
  (* we don't actually use the module so we can just specify no specification *)
  (Udp_syslog : sig end)
  (Tcp_syslog : sig end)
  (Tls_syslog : sig end)
  (Plaintext_conduit : Conduit_mirage.S)
  (Tls_conduit : Conduit_mirage.S)
  (Http : Cohttp_lwt.Server)
  = struct

  let start _time _pclock _mclock
            _network _stack _stack
            _stdlib _fortuna
            _console
            _block
            _crunch _ar1 _ar2
            _fs1 _fs2
            _kv_ro_of_fs
            _generic_kv_ro
            _resolver
            _syslog_udp _syslog_tcp _syslog_tls
            _plaintext_conduit _tls_conduit
            _http
            =
    let log = Logs.Src.create "test" in
    let module Log = (val Logs.src_log log : Logs.LOG) in
    Log.info (fun f -> f "I exist.");
    Lwt.return_unit 
end
