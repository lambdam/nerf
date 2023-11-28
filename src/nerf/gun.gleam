//// Low level bindings to the gun API. You typically do not need to use this.
//// Prefer the other modules in this library.

import gleam/http.{type Header}
import gleam/erlang/charlist.{type Charlist}
import gleam/dynamic.{type Dynamic}
import gleam/string_builder.{type StringBuilder}
import gleam/bit_builder.{type BitBuilder}

pub type StreamReference

pub type ConnectionPid

pub fn open(host: String, port: Int) -> Result(ConnectionPid, Dynamic) {
  open_erl(charlist.from_string(host), port)
}

@external(erlang, "gun", "open")
pub fn open_erl(host: Charlist, port: Int) -> Result(ConnectionPid, Dynamic)

@external(erlang, "gun", "await_up")
pub fn await_up(pid: ConnectionPid) -> Result(Dynamic, Dynamic)

@external(erlang, "gun", "ws_upgrade")
pub fn ws_upgrade(
  pid: ConnectionPid,
  path: String,
  headers: List(Header),
) -> StreamReference

pub type Frame {
  Close
  Text(String)
  Binary(BitArray)
  TextBuilder(StringBuilder)
  BinaryBuilder(BitBuilder)
}

type OkAtom

@external(erlang, "nerf_ffi", "ws_send_erl")
fn ws_send_erl(pid: ConnectionPid, frame: Frame) -> OkAtom

pub fn ws_send(pid: ConnectionPid, frame: Frame) -> Nil {
  ws_send_erl(pid, frame)
  Nil
}
