# A list of available rules and their signatures can be found here: https://buck2.build/docs/api/rules/
load("@prelude-nri//:elm.bzl", "elm_docs", "elm_format_diffs", "elm_test")
load("@prelude-nri//:node.bzl", "node_modules", "npm_bin", "npm_script_test", "prettier_diffs")

elm_docs(
    name = "docs.json",
    elm_json = "elm.json",
    src = "src",
    tests = [
        ":elm_test",
    ],
)

elm_test(
    name = "elm_test",
    test_srcs = glob(["test/**/*.elm"]),
)

filegroup(
    name = "src",
    srcs = glob(["src/**/*.elm"]),
    visibility = ["//component-catalog:app"],
)

node_modules(
    name = "node_modules",
    package = "package.json",
    package_lock = "package-lock.json",
    extra_files = {
        "lib": "//lib:src"
    },
    extra_args = ["--include=dev"],
)

npm_bin(
    name = "browserify",
    node_modules = ":node_modules",
    visibility = ["//lib:bundle.js"],
)

npm_bin(
    name = "prettier",
    node_modules = ":node_modules",
    visibility = [
        "//lib:prettier_diffs",
        "//component-catalog:prettier_diffs",
    ],
)

export_file(
    name = "elm.json",
    visibility = ["//component-catalog:public"],
)

npm_script_test(
    name = "puppeteer",
    node_modules = ":node_modules",
    args = ["default", "$(location //component-catalog:public)"],
    extra_files = {
        "script/puppeteer-tests.sh": "script/puppeteer-tests.sh",
        "script/puppeteer-tests.js": "script/puppeteer-tests.js",
    },
)

elm_format_diffs(
    name = "elm_format_diffs",
    srcs = glob(["src/**/*.elm"]),
)

genrule(
    name = "diff_to_comment",
    out = "diff_to_comment.py",
    srcs = ["script/diff_to_comment.py"],
    cmd = "cp $SRCS $OUT",
    executable = True,
)

prettier_diffs(
    name = "prettier_diffs",
    srcs = glob(["**/*.md"]),
    prettier = "//:prettier",
)
