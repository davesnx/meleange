let () =
  Eio_main.run @@ fun env ->
    let cwd = Eio.Stdenv.fs env in
    (* read app.importmap *)
    let open Eio.Path in
    let importmap = Sys.argv.(1) in
    let index = Sys.argv.(2) in
    let final_html_file = Sys.argv.(3) in
    let importmap_file = (cwd / importmap) in
    Eio.traceln " Visiting %a\n" Eio.Path.pp importmap_file;
    let import_map_content = Eio.Path.load importmap_file in
    let index_template_file = (cwd / index) in
    Eio.traceln " Visiting %a\n" Eio.Path.pp index_template_file;
    let index_lines = Eio.Path.load index_template_file in
    Out_channel.with_open_text final_html_file (fun oc ->
      let lines = String.split_on_char '\n' index_lines in
      List.iter (fun (line: string) ->
        (if String.ends_with ~suffix:"<script type=\"importmap\" src=\"app.importmap\"></script>" line then
          let content = "<script type=\"importmap\">\n" ^ import_map_content ^ "\n</script>" in
          Out_channel.output_string oc content;
        else
          Out_channel.output_string oc line;
      )
      ) lines;
    );
