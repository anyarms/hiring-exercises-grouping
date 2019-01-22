Originally cloned from [jhubert/hiring-exercises](https://github.com/jhubert/hiring-exercises/tree/master/grouping).

I'm approaching this exercise with the idea that you'd like to see
- Code I've actually written
- Something I haven't take a ton of time to polish
- How I approach problems and take a stab at solving them

I'm currently working in Windows. If you have any trouble with compatibility, let me know. Windows isn't my typical jam.
Also, the line endings in `input1.csv` seem different than the others, which is to say, they didn't show up for me when I cloned the repository. I just added in line endings manually to that file, since that didn't seem within the scope of the stated problem.

### Dependencies
- Ruby (Written with v2.3.5)

## Running the solution
`ruby group_file.rb {matching_type} {filename}`

## Inputs

| Input | Type | Description |
|---|---|---|
| matching_type | string | Must be one of `email`, `phone`, `both`|
| filename | string | Must be of type `.csv`, must be located in the same directory as `group_file.rb`|

## Room for improvement
Some things I'd like to improve, given the time:
- Accommodate other line ending types (see my note about `input1.csv` above)
- Make the `matching_type` input friendlier (i.e. not rely on string matching)
- Allow for more flexible locations for `filename` (e.g. ability to specify full path)
- Be more suspicious about the safety of user input
