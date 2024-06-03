type line = { start : point; end_ : point; thickness : int option }
and point = { x : int; y : int }

let line_to_string line =
  Printf.sprintf "Line from (%d, %d) to (%d, %d)"
  line.start.x line.start.y line.end_.x line.end_.y

module Decode = struct
  let point json =
    let open Json.Decode in
    { x = json |> field "x" int; y = json |> field "y" int }

  let line json =
    let open Json.Decode in
    {
      start = json |> field "start" point;
      end_ = json |> field "end" point;
      thickness = json |> optional (field "thickness" int);
    }
end

let () =
  let data = {| { "start": { "x": 1, "y": -4 }, "end": { "x": 5, "y": 8 } } |} in
  let line = data |> Json.parseOrRaise |> Decode.line in
  let total = Belt.List.reduce [1; 2; 3] 0 (+) in
  let message = Lib.print total in
  Js.Console.log message;
  Js.Console.log (line_to_string line);
