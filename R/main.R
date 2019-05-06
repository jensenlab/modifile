
setNA <- function(x, naval) {
  x[is.na(x)] <- naval
  x
}

#' Split filenames into path, name, and extension.
#'
#' @param filename Character vector of filenames.
#'
#' @return A list with fields for the \code{path}, \code{name}, and \code{ext} (extension).
#'
#' @export
split_filename <- function(filename) {
  ext <- stringr::str_match(filename, "\\.([^/]+)$")
  filename <- stringr::str_remove(filename, "\\.([^/]+)$")

  name <- stringr::str_match(filename, "[^/]+$")
  filename <- stringr::str_remove(filename, "[^/]+$")

  list(
    path=filename,
    name=setNA(name[, 1], ""),
    ext=setNA(ext[ ,2], "")
  )
}

# adds `ending` to any non-empty string
assert_pathsep <- function(s) {
  stringr::str_replace(s, "(.*[^/])$", "\\1/")
}

assert_extsep <- function(s) {
  s <- stringr::str_remove(s, paste0("^\\."))
  paste0(ifelse(nchar(s) == 0, "", "."), s)
}

#' @export
join_filename <- function(path, name, ext) {
  paste0(assert_pathsep(path), name, assert_extsep(ext))
}

#' @export
modify_filename <- function(filename,
                            new_path=NULL,
                            new_name=NULL,
                            new_ext=NULL,
                            before_path="", after_path="",
                            before_name="", after_name="",
                            before_ext="", after_ext="") {
  parts <- split_filename(filename)

  path <- paste0(
    before_path,
    if (is.null(new_path)) parts$path else new_path,
    after_path
  )

  name <- paste0(
    before_name,
    if (is.null(new_name)) parts$name else new_name,
    after_name
  )

  ext <- paste0(
    before_ext,
    if (is.null(new_ext)) parts$ext else new_ext,
    after_ext
  )

  join_filename(path, name, ext)
}

#' @export
concat_filenames <- function(filename1, filename2,
                             path=1, name=1+2, ext=1,
                             sep="_") {
  parts1 <- split_filename(filename1)
  parts2 <- split_filename(filename2)
  join_aux <- function(part1, part2, choice) {
    switch(choice+1,
      "",
      part1,
      part2,
      paste(part1, part2, sep=sep)
    )
  }
  join_filename(
    path = join_aux(parts1$path, parts2$path, path),
    name = join_aux(parts1$name, parts2$name, name),
    ext = join_aux(parts1$ext, parts2$ext, ext)
  )
}

testfiles <- c("file", "/file", "file.fasta", "/path/to/file/file.fasta.gz", "~/file.fq", "./file.bam")
