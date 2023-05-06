import Rails from "@rails/ujs";

document.addEventListener('DOMContentLoaded', () => {
  const chips = document.querySelectorAll("#category-chips .chip");

  chips.forEach((chip) => {
    chip.addEventListener("click", () => {
      const category = chip.dataset.category.toLowerCase();
      console.log('category', category, `category-${category}`);
      chip.classList.toggle("selected");
      chip.classList.toggle(`category-${category}`);
      const selectedCategories = Array.from(chips)
      .filter((chip) => chip.classList.contains("selected"))
      .map((chip) => chip.dataset.category.toLowerCase())
      .join(",");

      const url = `/articles/filter_by_category?categories=${selectedCategories}`;
      Rails.ajax({
        url,
        type: 'GET',
        dataType: 'script',
      });
      })
  });
});
