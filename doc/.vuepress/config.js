module.exports = {
    head: [["script", { src: "https://code.jquery.com/jquery-3.4.1.min.js" }]],

    title: "ecam",
    description: "The easiest screen recording tool",

    themeConfig: {
        sidebar: "auto",
        nav: [
            { text: "Home", link: "/" },
            { text: "About", link: "/about/" },
        ],
    },
    markdown: {
        lineNumbers: true,
    },
};
