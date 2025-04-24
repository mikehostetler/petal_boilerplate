const AutoResize = {
  mounted() {
    this.updateTextarea = () => {
      const count = this.el.value.length;
      const charCount = this.el.parentElement.querySelector(".js-char-count");
      if (charCount) {
        charCount.textContent = count > 0 ? `${count}/1000` : "";
      }

      // Reset height to auto to properly calculate new height
      this.el.style.height = "auto";
      // Set new height based on scrollHeight
      this.el.style.height = `${Math.min(this.el.scrollHeight, 400)}px`;
    };

    this.el.addEventListener("input", this.updateTextarea);
    this.el.addEventListener("change", this.updateTextarea);
  },

  destroyed() {
    this.el.removeEventListener("input", this.updateTextarea);
    this.el.removeEventListener("change", this.updateTextarea);
  },
};

export default AutoResize;
