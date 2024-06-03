module Importmap = struct
  let entry folder =
    let key = Printf.sprintf "%s/" folder in
    (* "./../node_modules/melange/" *)
    let value = Printf.sprintf "./../node_modules/%s/" folder in
    (key, `String value)

  let to_string paths: Yojson.t =
    let prefixed_folders = List.map (fun folder -> folder) paths in
    let folders = `Assoc (List.map (entry) prefixed_folders) in
    let json = `Assoc [("imports", folders)] in
    json
end

let read_folders_from_build ~target root =
  let open Eio.Path in
  let target_folder = root / target / "node_modules" in
  Eio.traceln " Visiting %a\n" Eio.Path.pp target_folder;
  match Eio.Path.kind ~follow:false target_folder with
  | `Directory ->
    Eio.Path.read_dir target_folder
  | `Not_found ->
    (* TODO: Fail hard *) []
  | _ -> (* TODO: Add unsupported message *) []

let generate_file ~filename importmap =
  (* TODO: validate filename *)
  Out_channel.with_open_text (filename) (fun oc ->
  let content = Yojson.pretty_to_string importmap in
  Out_channel.output_string oc content)

let read_params_or_help () =
  (* if Array.length Sys.argv < 3 then
    print_newline "Usage: dune-importmap <target> <output_path>";
    exit 0
  else ( *)
  let target = Sys.argv.(1) in
  let filename = Sys.argv.(2) in
  (target, filename)

let print_folders folders =
  Fmt.str "[%a]" (Fmt.list ~sep:(Fmt.any ", ") Fmt.string) folders

let () =
  Eio_main.run @@ fun env ->
    let cwd = Eio.Stdenv.fs env in
    Eio.traceln " Visiting %a\n" Eio.Path.pp cwd;
    let (target, filename) = read_params_or_help () in
    let folders = read_folders_from_build ~target cwd in
    Eio.traceln " JavaScript dependencies: %s\n" (print_folders folders);
    let importmap = Importmap.to_string folders in
    Eio.traceln " Generated importmap: %s\n" ( Yojson.to_string importmap);
    generate_file ~filename importmap
