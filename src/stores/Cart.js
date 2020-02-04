import { writable } from 'svelte/store';

function createStore() {
  const {subscribe, set, update} = writable({
    data: []
  });

  return {
    subscribe,
    addDataItems: (newVal) => update(n => {
      n.data = newVal;
      return n;
    })
  }
}
export const Cart = createStore();