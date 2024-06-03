let print () =
  let total = Belt.List.reduce [1; 2; 3] 0 (+) in
  Js.Console.log ("Hola! " ^ Int.to_string total)
