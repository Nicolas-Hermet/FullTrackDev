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

window.addEventListener("load", () => {
  updateList();
})
window.addEventListener('scroll', () => {
  updateList();
})