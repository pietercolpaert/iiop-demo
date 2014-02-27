# IIOP demo

The identifier interoperability (IIOP) of 2 datasets is the ratio of the real-world concepts identified with the same identifier across the 2 datasets over the total of real-world objects identified within the two datasets that overlap. The relevance of the interoperability is the number of facts where real-world objects are mentioned.

In this projects we will demonstrate a workflow to calculate the IIOP and the relevance on a couple of datasets hosted at http://iiop.demo.thedatatank.com/test/.

## Step 0: what do you think?

In order to evaluate the score, we will ask you to first take a look at the datasets at http://iiop.demo.thedatatank.com/test/ and compare them to http://iiop.demo.thedatatank.com/test/reference. Give your own score to it for both the interoperability itself, as a relevance number for the interoperability.

You can use this questionnaire: https://docs.google.com/forms/d/1xb-Fz6KsCX92WYkcB_CRHI5RlewEHVvEJnkuiTaxzzQ/viewform#start=openform

The results of the questionnaire can be found here: TBA

## Step 1: Transforming the data towards triples

Tools such as open refine can be used to transform the datasets into triples. Each time, every id is concatenated with the URI of the dataset (e.g., http://iiop.demo.thedatatank.com/test/ghent1/kml1 for the identifier of the first row or http://iiop.demo.thedatatank.com/test/ghent1/long as the identifier of the concept of longitude).

Tools like [Open Refine](http://openrefine.org), [RML](http://semweb.mmlab.be/ns/rml) or [DataLift](http://datalift.org) can be used. These tools map data towards triples.

_Caveat lector: even when we would have a dataset in RDF, we would still concatenate each URI with the dataset URI: we need a unique identifier for each identifier used in each dataset._

In this demo we have used Open Refine. The result of the mapping are put in the respective dataset folders in this repository:
 * reference/reference.ttl
 * ghent1/ghent1.ttl
 * newyork/newyork.ttl
 * ghent2/ghent2.ttl
 * antwerp/antwerp.ttl

Using a command-line tool which can be installed on debian/ubuntu systems using `apt-get install raptor2-utils`, we have converted the datasets into n-triples.

For each dataset we did:
```bash
rapper -i turtle -o ntriples antwerp.ttl > antwerp.nt
```

This generated this amount of triples:

Dataset | number of triples
:------:|-------------------:
reference| 21
ghent1 | 48
newyork | 16
antwerp | 45
ghent2 | 24

## Step 2: Generating the list of identifiers

For each dataset, we generated a file containing all the IDs defined in a dataset. Using the n-triples file, we can generate this quickly using this bash command for each dataset:

```bash
cut -d" " newyork.nt -f1,2,3 --output-delimiter="
" | grep "^<" | sort | uniq > ids.txt
```

Dataset | number of IDs
:------:|-------------------:
reference| 12
ghent1 | 27
newyork | 9
antwerp | 18
ghent2 | 11
__Total__ | __77__

## Step 3: Getting the real world input

There are various ways to get to the real-world input: you can crowd-source it, you can reason over already existing data or you can fill it out yourself. The result of this step should be an n-triples file which contains for each identifier whether it does or does not mean the same in the real world. The predicates that we are going to use for this are defined at http://semweb.mmlab.be/ns/iiop ; `iiop:sameAs` and `iiop:notSameAs`. For this dataset this means we need 5852 (77*76) statements. As these statements are unknown at this moment, we can generate a list of 5852 questions.

During the process of solving these questions yourself, you can use a reasoner to assist you. Each time a statement is added, the reasoner will then check whether more questions can be derived.
In this case, we will use the reasoner by Ruben Verborgh which uses the EYE software.
Using the command line, this can be done as follows:
```bash
#TODOOO
```

### Step 3a: Generating the list of questions

An iiop question is a triple with 1 unknown predicate. The predicate kan be `iiop:sameAs` or `iiop:notSameAs`:
```turtle
<id1> ?unknown <id2> .
```

In order to generate this list, we first generate a list of all identifiers in our system. This is easy, as we already have made a list of all identifiers in each dataset.

```bash
cat reference/ids.txt ghent1/ids.txt newyork/ids.txt antwerp/ids.txt ghent2/ids.txt > ids.txt
```

Now, this list will be used to generate a list `questions.nt`. This is solved using 2 while loops:

```bash
while read id1 ; do {
  while read id2 ; do {
    [[ $id1 != $id2 ]] && echo "$id1 ?unknown $id2 . " ; 
  } done < ids.txt ;
} done < ids.txt > questions.nt
```

### Step 3b: Answering the questions

Answering the question can be done in various ways. Each kind of set of data might be able to use its own methods: if we're talking about geospatial data, the identifiers can be compared on a map, if we're talking about tabular data, a mapping GUI could be made. We are going to use a more rudimental approach: we're going to copy the `questions.nt` towards `iiopstatements.nt` and we're going to use a text editor to find-replace-all `?unknown` with `<http://semweb.mmlab.be/ns/iiop#notSameAs>`. Each time we find an identifier which is not the same, we're going to hit "`yes`, replace". If it is the same in the real world, we're going to hit "`no`, don't replace". Afterwards, all remaining `?unknown` will be replace by `<http://semweb.mmlab.be/ns/iiop#notSameAs>`.

After uploading the files on our server, we can use the EYE Reasoner to help us a bit in the process (note that this can actually be implemented by the GUI):
```bash
curl "http://eye.restdesc.org/?data=http://iiop.demo.thedatatank.com/iiopstatements.nt&query=http://iiop.demo.thedatatank.com/query.n3" >temp.ttl
rapper -i turtle -o ntriples temp.ttl > temp.nt
curl http://iiop.demo.thedatatank.com/iiopstatements.nt> temp2.nt
cat temp.nt temp2.nt questions.nt | sort -t " " -k 1,1b -k 3,3b | sed 's/[ ]*$//' | uniq > answers.nt
rm temp.nt temp.ttl temp2.nt 
```
You can then reopen answers.nt in your editor, remove the duplicates, and carry on with your work.

Remove duplicates using Emacs regex (C-M %)
```
\(<.*?>\) \(<http://semweb.mmlab.be/ns/iiop#n?o?t?[sS]ameAs>\) \(<.*?>\) .
\1 \?unknown \3 . 
```
with
```
\1 \2 \3 .

```

And you can cary on.

## Step 4: Making the calculations

We're going to create a dataset of ids that match in the real-world:
 
_This is kind of hack-ish. We could have loaded it in a triple store and used SPARQL to query over it._

```bash
grep -e "^<http://iiop.demo.thedatatank.com/test/antwerp/" iiopstatements.nt | grep sameAs | cut -d" " -f3 | sort > antwerp/realworldmatches.txt
grep -e "^<http://iiop.demo.thedatatank.com/test/antwerp/" iiopstatements.nt | grep -E "antwerp/(.*?)> <http://semweb.mmlab.be/ns/iiop#notSameAs> <http://.*?$1>" | cut -d" " -f3 | sort > antwerp/conflicts.txt
```

### IIOP

```bash
grep newyork reference/realworldmatches.txt | while read a ; do { cat reference/reference.nt | grep ${a#<http://iiop.demo.thedatatank.com/test/newyork/} -o  ; } done | uniq | wc -l
grep newyork reference/realworldmatches.txt  | wc -l
```

Divide these 2 numbers, and you have the IIOP

Reference and ... | IIOP
:------:|-------------------:
ghent1 | 8/14 = 57%
newyork | 0/1 = 0%
antwerp | 5/5 = 100%
ghent2 | 3/4 = 75%

### Relevance

count the number of triples the real-world matches are mentioned in.

For instance for Ghent1 do this:
```bash
p=0 ;
while read id ; do {
    p=$(( p + `grep $id ghent1/ghent1.nt | wc -l ;`));
} done < reference/realworldmatches.txt
echo $p
```

### Conflicts

Count the number of conflicts: string matches in the IDs, but there is a `iiop:notSameAs` statement. This is exactly the opposite of the first number we calculated for the IIOP.

```bash
grep -E 'newyork/(.*?)> <http://semweb.mmlab.be/ns/iiop#notSameAs> <http://.*?/\1>' iiopstatements.nt | wc -l
```

The end results is this matrix:

Reference and ... | IIOP | relevance p | conflicts | questionnaire rank
:------:|---:|-----: | ---: |---:
ghent1 | 57% | 71 | 0 | 1st _best_
newyork |0% | 5 | 0 | 4th _worst_
antwerp | 100% | 25 | 0 | 2d _second best_
ghent2 | 75% | 12 | 0 | 3d _second worst_

When we however take newyork as the reference dataset, we get 1 conflict:

```turtle
<http://iiop.demo.thedatatank.com/test/newyork/location> <http://semweb.mmlab.be/ns/iiop#notSameAs> <http://iiop.demo.thedatatank.com/test/ghent1/location> .
```
