# Lotto Game Generator

This is an experiment to help me learn Elxir/OTP. I wanted something technically complex enough to be worthwhile, but not so complex that it would be impossible to implement as a complete Elixir noob. 

The question is simple: can I do something with Lotto numbers scraped from a web site?

The result is a pretty rudimentary answer to that question that does a couple of things. It can scrape a web site (in an extremely fragile manner) and pull back numbers and frequencies. It can read a CSV of [number,frequency] pairs and sort them into most or least frequently drawn, and it can generate combinations of a subset of the numbers in such a way that all n combinations of k numbers are captured. There's a bit of command line manipulation, a little algorithm to generate the combinations, plus dependencies on a couple of external Elixir libs. 

Before anyone decides to email me with a reference to "[The Gambler's Fallacy](https://www.investopedia.com/terms/g/gamblersfallacy.asp)", I am well aware the statistical and probabilistic lunacy of what this program is trying to do and am under no illiusion whatsoever that it will select "correct" or "winning" Lotto numbers in any form. This is purely for the technical exercise of reading and processing the data in a functional manner using Elxir. 

## Usage 

``` elixir
Lotto Number Generator (ver: 0.1.0)

synopsis:
  Generate Lotto numbers from frequency tables
usage:
  $ lotto {options} file
  $ lotto --scrape url
options:
  --least           Use least frequently selected numbers (defaults to true)
  --most            Use most frequently selected numbers (defaults to false)
  --select=S        Number of Lotto numbers to select (defaults to 6)
  --count=C         Number of frequency numbers to draw from (defaults to 8)
  --scrape          Scrape the URL provided and dump [numb,freq] in CSV format
where:
  file  Comma-separated CSV file of the form:

        # datafile.csv
        number, frequency
        1, 345
        2, 340
        ...

  url   URL containing list of lotto numbers with frequencies
```
