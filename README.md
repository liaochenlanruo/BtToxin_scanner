# BtToxin_scanner version 2

## Contents
- [Introduction](#introduction)

- [Installation](#installation)

- [Usage](#usage)

- [Examples](#examples)

- [License](#license)

- [Feedback](#feedback)

- [Citation](#citation)

- [FAQs](#faqs)

## Introduction

This is an upgraded version of [BtToxin_scanner](http://bcam.hzau.edu.cn/BtToxin_scanner/), which can be used for mining Bt toxins, such as Cry, Cyt and Vip toxins.


## Installation

- Required dependencies
 - [BioPerl](http://metacpan.org/pod/BioPerl)
 - [hammer]()
 - [libsvm]()
 - [NCBI-blast+](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=Download)
 - [Perl](http://www.perl.org/get.html)
 - [PGCGAP]()
- Bioconda - OSX/Linux/WSL

## Usage

Options:
    [--help]                      Print the help message and exit

    [--version]                   Show version number of BtToxin_scanner and
                                  exit

    [--threads (INT)]             Number of threads to be used ( Default 4 )

    [--SeqPath (PATH)]            [Required] The path of input sequences (
                                  Default "the current directory" )

    [--SequenceType (STRING)]     [Required] Sequence type for inputs.
                                  "reads", "nucl", "orfs", and "prot"
                                  avaliable ( Default nucl )

    [--platform (STRING)]         [Required] Sequencing Platform,
                                  "illumina", "pacbio", "oxford" and
                                  "hybrid" available ( Default illumina )

    [--assemble_only (STRING)]    Only perform genome assembly without
                                  predicting toxins.

    [--reads1 (STRING)]           [Required by "reads"] The suffix name of
                                  reads 1 ( for example: if the name of
                                  reads 1 is
                                  "YBT-1520_L1_I050.R1.clean.fastq.gz",
                                  "YBT-1520" is the strain same, so the
                                  suffix name should be ".R1.clean.fastq.gz"
                                  )

    [--reads2 (STRING)]           [Required by "reads"] The suffix name of
                                  reads 2( not required by "oxford" and
                                  "pacbio". For example: if the name of
                                  reads 2 is "YBT-1520_2.fq", the suffix
                                  name should be _2.fq" )

    [--suffix_len (INT)]          [Required by "reads"] (Strongly
                                  recommended) The suffix length of the
                                  reads file, that is the length of the
                                  reads name minus the length of the strain
                                  name. For example the --suffix_len of
                                  "YBT-1520_L1_I050.R1.clean.fastq.gz" is 26
                                  ( "YBT-1520" is the strain name ) (
                                  Default 0 )

    [--short1 (STRING)]           [Required] FASTQ file of first short reads
                                  in each pair. Needed by hybrid assembly (
                                  Default Unset )

    [--short2 (STRING)]           [Required] FASTQ file of second short
                                  reads in each pair. Needed by hybrid
                                  assembly ( Default Unset )

    [--long (STRING)]             [Required] FASTQ or FASTA file of long
                                  reads. Needed by hybrid assembly ( Default
                                  Unset )

    [--hout (STRING)]             [Required] Output directory for hybrid
                                  assembly ( Default
                                  ../../Results/Assembles/Hybrid )

    [--genomeSize (STRING)]       [Required] An estimate of the size of the
                                  genome. Common suffixes are allowed, for
                                  example, 3.7m or 2.8g. Needed by PacBio
                                  data and Oxford data ( Default 6.07m )

    [--Scaf_suffix (STRING)]      The suffix of scaffolds or genomes (
                                  Default ".filtered.fas" )

    [--orfs_suffix (STRING)]      The suffix of orfs files ( Default ".ffn"
                                  )

    [--prot_suffix (STRING)]      The suffix of protein files ( Default
                                  ".faa" )
## Examples

## License
BtToxin_scanner is free software, licensed under [GPLv3](https://github.com/liaochenlanruo/Bt_toxin_scanner/blob/master/LICENSE).

## Feedback/Issues
Please report any issues about usage of the software to the [issues page](https://github.com/liaochenlanruo/Bt_toxin_scanner/issues).

## Citation
If you use this software please cite:

## FAQs


