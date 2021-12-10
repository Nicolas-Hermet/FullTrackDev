window.addEventListener("turbolinks:load", () => {
function updateList() {
	const titles = [...document.querySelectorAll('h1, h2')].sort((a, b) => {
		return Math.abs(a.getBoundingClientRect().top) - Math.abs(b.getBoundingClientRect().top);
	});
  console.table([titles[0].id, titles[1].id, titles[2].id, titles[3].id]);

	document.querySelectorAll(".selected-circle").forEach((c) => {
    console.log('TOP', c);
    c.classList.remove("selected-circle");
  });
	document.querySelectorAll(".nav-dot")[[...document.querySelectorAll('h1, h2')].indexOf(titles[0])].classList.add("selected-circle");
}

updateList();

window.addEventListener('scroll', () => {
  updateList();
})

  document.querySelector('#menu-button').addEventListener("click", e => {
    e.preventDefault();
    var menu = document.querySelector('#menu');
    menu.classList.toggle('show-menu');
    menu.classList.toggle('hidden');
    document.querySelector('#menu-button').classList.toggle('close');
  });
});