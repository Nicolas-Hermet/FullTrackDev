import Rails from "@rails/ujs";

document.addEventListener('DOMContentLoaded', () => {
  const chips = document.querySelectorAll("#category-chips .chip");
  const adminChips = document.querySelectorAll("#category-chips .chip-admin");

  chips.forEach((chip) => {
    chip.addEventListener("click", () => {
      const category = chip.dataset.category.toLowerCase();
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

  adminChips.forEach((chip) => {
    chip.addEventListener("click", () => {
      const status = chip.dataset.status.toLowerCase();
      console.log('category', status, `status-${status}`);
      chip.classList.toggle("selected");
      chip.classList.toggle(`status-${status}`);
      const selectedStatus = Array.from(adminChips)
        .filter((chip) => chip.classList.contains("selected"))
        .map((chip) => chip.dataset.status.toLowerCase())
        .join(",");

      const url = `/articles/filter_by_category?status=${selectedStatus}`;
      Rails.ajax({
        url,
        type: 'GET',
        dataType: 'script',
      });
      })
  });
});
