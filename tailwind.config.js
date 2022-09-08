const defaultTheme = require("tailwindcss/defaultTheme");
const colors = require("tailwindcss/colors");

module.exports = {
  content: [
    "./src/css/**/*.css",
    "./src/pages/**/*.cr",
    "./src/components/**/*.cr",
    "./src/js/controllers/*.ts",
  ],
  theme: {
    extend: {
      colors: {
        primary: colors.emerald,
      },
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/aspect-ratio"),
  ],
};
