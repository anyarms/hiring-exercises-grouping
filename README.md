Originally cloned from [jhubert/hiring-exercises](https://github.com/jhubert/hiring-exercises/tree/master/grouping).

I'm approaching this exercise with the idea that you'd like to see
- Code I've actually written
- Something I haven't take a ton of time to polish
- How I approach problems and take a stab at solving them

### Decisions Made
- The guidelines didn't say anything about grouping on nil values (i.e. many entries have no email address: are these all the same person?). I decided to consider these different people, since that made more business sense to me.
- The output file will overwrite any previous output file of the same name without warning. Output files name themselves after your input file name and your matching type (plus 'output'): `input1_email_output.csv`.

I'm currently working in Windows. If you have any trouble with compatibility, let me know. Windows isn't my typical jam.
Also, the line endings in `input1.csv` seem different than the others, which is to say, they didn't show up for me when I cloned the repository. I just added in line endings manually to that file, since that didn't seem within the scope of the stated problem.

### Dependencies
- Ruby (Written with v2.3.5)
- Minitest (used version 5.11.3), only if you want to run the tests.

## Running the solution
`ruby group_records.rb "{matching_type}" "{filename}"`

### Inputs

| Input | Type | Description |
|---|---|---|
| matching_type | string | Must be one of `email`, `phone`, `both`|
| filename | string | Must be of type `.csv`, must be located in the same directory as `group_records.rb`|

### Output

A file will be written (in the same directory as everything else) with the name `{filename}_{matching_type}_output.csv`. It will have the original input, prepended with a UserId column.

## Running the tests

I wrote a couple of tests to make the process easier, you can run them with `ruby test_grouping.rb`.

## Room for improvement
Some things I'd like to improve, given the time:
- Make the `matching_type` input friendlier (i.e. not rely on string matching)
- Allow for more flexible locations for `filename` (e.g. ability to specify full path)
- Be more suspicious about the safety of user input
