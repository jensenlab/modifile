<!-- README.md is generated from README.Rmd. Please edit that file -->
modifile
========

Manipulate filenames in R.

### Installation

``` r
devtools::install_github("jensenlab/modifile")
```

### Splitting filenames into paths, names, and extensions

The `split_filename` function splits a filename into a path (directory location), the name of the file, and the file's extension.

``` r
split_filename("/path/to/file/myfile.fastq")
#> $path
#> [1] "/path/to/file/"
#> 
#> $name
#> [1] "myfile"
#> 
#> $ext
#> [1] "fastq"
```

The `join_filename` function does the opposite.

``` r
join_filename("/path/to/file", "myfile", "fastq")
#> [1] "/path/to/file/myfile.fastq"
```

All functions in `modifile` are vectorized over their inputs.

``` r
split_filename(c("/path/to/file/myfile1.fastq", "/path/to/file/myfile2.fastq"))
#> $path
#> [1] "/path/to/file/" "/path/to/file/"
#> 
#> $name
#> [1] "myfile1" "myfile2"
#> 
#> $ext
#> [1] "fastq" "fastq"
join_filename("/path/to/file", c("myfile1","myfile2"), "fastq")
#> [1] "/path/to/file/myfile1.fastq" "/path/to/file/myfile2.fastq"
```

A file's extensions includes all suffixes to allow for compressed files.

``` r
split_filename("file.fasta.gz")
#> $path
#> [1] ""
#> 
#> $name
#> [1] "file"
#> 
#> $ext
#> [1] "fasta.gz"
```

### Modifying filenames

The `modify_filename` function can change the path, name, or extension of filenames.

``` r
test_filenames <- c("./file.fastq", "file.fq", "/path/to/file/file.fastq.gz")
modify_filename(test_filenames, new_path="newdir")
#> [1] "newdir/file.fastq"    "newdir/file.fq"       "newdir/file.fastq.gz"
modify_filename(test_filenames, new_name="newfile")
#> [1] "./newfile.fastq"                "newfile.fq"                    
#> [3] "/path/to/file/newfile.fastq.gz"
modify_filename(test_filenames, new_ext="bam")
#> [1] "./file.bam"             "file.bam"              
#> [3] "/path/to/file/file.bam"
```

Remove the path, name, or extension by setting the new value to an empty string.

``` r
modify_filename(test_filenames, new_ext="")
#> [1] "./file"             "file"               "/path/to/file/file"
```

You can also add test before or after each part of the filename.

``` r
modify_filename("/path/file.ext", 
                before_path="<BEFORE_PATH>", after_path="<AFTER_PATH>",
                before_name="<BEFORE_NAME>", after_name="<AFTER_NAME>",
                before_ext="<BEFORE_EXT>", after_ext="<AFTER_EXT>")
#> [1] "<BEFORE_PATH>/path/<AFTER_PATH>/<BEFORE_NAME>file<AFTER_NAME>.<BEFORE_EXT>ext<AFTER_EXT>"
```

The `after_path` test is treated as a subdirectory, and `before_ext` is inserted after the `.` but before the rest of the extension.

### Concatenating filenames

The `concat_filenames` function joins two sets of filenames. By default, only the names of the files are joined.

``` r
concat_filenames("path1/name1.fastq", "path2/name2.fa.gz")
#> [1] "path1/name1_name2.fastq"
```

You can choose to join the path, name, extension or any combination. Setting the `path`, `name`, and `ext` arguments to:

-   `0` drops the part of the filename
-   `1` uses the part from `filename1`
-   `2` uses the part from `filename2`
-   `1+2` combines the part from `filename1` and `filename2` using the separator in `sep`

``` r
concat_filenames("path1/name1.fastq", "path2/name2.fa.gz",
                 path=2, name=1+2, ext=1, sep="@")
#> [1] "path2/name1@name2.fastq"
```
