import App from './AppStart.svelte';

localStorage.setItem('reference', JSON.stringify(''));
localStorage.setItem('tracks', JSON.stringify([]));

let app = new App({
  target: document.body,
});

window.app = app;

export default app;

// Hot Module Replacement (HMR) - Remove this snippet to remove HMR.
// Learn more: https://www.snowpack.dev/concepts/hot-module-replacement
// if (import.meta.hot) {
//   import.meta.hot.accept();
//   import.meta.hot.dispose(() => {
//     app.$destroy();
//   });
// }
