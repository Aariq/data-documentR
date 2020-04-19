# data-documentR

<!-- badges: start -->
  [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
  <!-- badges: end -->
  
An idea for an R package to help your write metadata for .csv files and data.frames

The core of the package is a function that prompts the user for metadata about data sets including a general description and column level details that depend on the data type (numeric, factor, date, etc.).  

This package needs a better name and a convention for function names!

This metadata can then be written as markdown or text alongside a .csv file(s).  Here's where I see this project going right now:

## Features/roadmap:

- Nags you every time you read or write a file to document the data (via wrappers to `read.csv`, `read_csv`, `write.csv`, `write_csv`, etc.?)
- Allows documentation of R data.frames as you save them (i.e. a `write_and_document_csv()` type thing that prompts user for metadata and writes .csv AND matching .md)
- Allows documentation of .csv's or folders of .csv's (i.e. a `document_csv()` that reads in csv's and prompts the user for metadata then writes matching .md's)
  - Ideally one single METADATA.md per folder, with all .csv's documented.  Need ability to append this document rather than overwriting.
- Memoisation?  Don't prompt the user unless the data object or .csv has changed since it was last documented? This might be beyond my abilities and may not be necessary.
- RStudio plugin that writes a data dictionary for a data.frame in .Rmd (similar to `remedy` pacakge)
- A funciton that checks the project code for any files read in or out and makes sure you've documented everything?

## Example output markdown

### File: dataset1.csv
#### Description: 

Plant growth data that was collected between june 2011 and july 2012 at the boston area climate experiment in Waltham, MA.

#### Columns:

- `species <fct>`: The plant species used.  
    Levels:
     - `AM`: Achillea milfolium
     - `PL`: Plantago lanceolata
- `height <dbl>`: Plant height from ground to longest leaf
  - Units: cm
- `flnum <int>`: Number of inflorescences
- `date <Date>`: Date of measurment
  - Format: ISO (yyy-mm-dd)
  - Timezone: EDT
- `plot <chr>`: A plot ID to be used as a blocking factor

### File: dataset2.csv
...
     
