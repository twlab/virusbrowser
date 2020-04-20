// import App from './AppMain.svelte';
import App from './AppStart.svelte';

localStorage.setItem('reference', JSON.stringify(''));
localStorage.setItem('tracks', JSON.stringify([]));


const app = new App({
	target: document.body,
	props: {
		name: 'world'
	}
});

window.app = app;

export default app;