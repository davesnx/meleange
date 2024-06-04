let () =
  Eio_main.run @@ fun base ->
  let cwd = Eio.Stdenv.fs base in
  let importmap = Sys.argv.(1) in
  let template_html_path = Sys.argv.(2) in
  let final_html_file = Sys.argv.(3) in
  let importmap_file = Eio.Path.(cwd / importmap) in
  let import_map_content = Eio.Path.load importmap_file in
  let index_template_file = Eio.Path.(cwd / template_html_path) in
  let index_content = Eio.Path.load index_template_file |> Soup.parse in
  Out_channel.with_open_text final_html_file (fun channel ->
      match Soup.select_one "script[type='importmap']" index_content with
      | Some external_inline_import_map ->
          let inline_import_map =
            Soup.create_element
              ~attributes:[ ("type", "importmap") ]
              ~inner_text:import_map_content "script"
          in
          Soup.replace external_inline_import_map inline_import_map;
          Out_channel.output_string channel (Soup.to_string index_content)
      | None -> Out_channel.output_string channel (Soup.to_string index_content))
