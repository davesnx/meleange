# meleange

When using a library like `Belt` or `Js` in an OCaml module, compiled by Melange

```ocaml
let print () =
  let total = Belt.List.reduce [1; 2; 3] 0 (+) in
  Js.Console.log ("Hola! " ^ Int.to_string total)
```

Gets generated as JavaScript, looking like:
```js
// Generated by Melange

import * as Belt__Belt_List from "melange.belt/belt_List.mjs";
import * as Stdlib__Int from "melange/int.mjs";

function print(param) {
  const total = Belt__Belt_List.reduce({
        hd: 1,
        tl: {
          hd: 2,
          tl: {
            hd: 3,
            tl: /* [] */0
          }
        }
      }, 0, (function (prim0, prim1) {
          return prim0 + prim1 | 0;
        }));
  console.log("Hola! " + Stdlib__Int.to_string(total));
}

export {
  print ,
}
/* No side effect */
```

If we load this module with `<script type="module" ...` into an html file (and serve it via a simple http server) we get the following error:

```
Uncaught TypeError: Failed to resolve module specifier "melange.belt/belt_List.mjs". Relative references must start with either "/", "./", or "../".
```

Import maps fixes this, by letting the browser know where to look for those modules. If we serve "node_modules" and use an importmap:

```js
<script type="importmap">
  {
    "imports": {
      "melange/": "./../node_modules/melange/",
      "melange.belt/": "./../node_modules/melange.belt/",
      "melange.js/": "./../node_modules/melange.js/"
    }
  }
</script>
```

The script loads perfectly.

### How

There's a bit of waterfall, since the browser need to parse the entrypoint (App.mjs), detect the linked modules (imports) and later fetch them.

If we have an entrypoint (App.mjs) which only imports Lib.mjs, the following request graph appears:

<div align="center">
  <img src="./docs/load-app-mjs.png" width="412px"/>
  <img src="./docs/load-lib-mjs.png" width="412px"/>
</div>

With `modulepreload` (`<link rel="modulepreload" href="./src/Lib.mjs" as="script" />`), you are able to tell the browser that this module is urgent

![](./docs/preload-lib-mjs.png)

#### Resources

https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script/type/importmap
https://github.com/WICG/import-maps
