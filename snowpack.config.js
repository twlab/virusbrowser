/** @type {import("snowpack").SnowpackUserConfig } */
// const resolve = require('@rollup/plugin-node-resolve').default
// const commonjs = require('@rollup/plugin-commonjs')
module.exports = {
  mount: {
    public: {url: '/', static: true},
    src: {url: '/dist'},
  },
  plugins: ["@snowpack/plugin-svelte"],
  install: [
    /* ... */
  ],
  installOptions: {
    rollup: {
      plugins: [
        require("rollup-plugin-svelte")({
          include: ["./node_modules"],
        }),
        require("rollup-plugin-postcss")({
          use: [
            [
              "sass",
              {
                includePaths: ["./src/theme", "./node_modules"],
              },
            ],
          ],
        }),
      //   commonjs(),
      // resolve(),
      ],
    },
  },
  devOptions: {
    /* ... */
  },
  buildOptions: {
    /* ... */
  },
  proxy: {
    /* ... */
  },
  alias: {
    /* ... */
  },
};
