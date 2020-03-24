#!/usr/bin/env perl
use strict;
use warnings;
#use Getopt::Std;
use File::Tee qw(tee);
use Pod::Usage;
use Getopt::Long;

my %options;

=over 30

=item B<[--help]>

Print the help message and exit

=back

=cut

$options{'help|h|?'} = \( my $opt_help );

=over 30

=item B<[--version]>

Show version number of BtToxin_scanner and exit

=back

=cut

$options{'version'} = \( my $opt_version );

=over 30

=item B<[--threads (INT)]>

Number of threads to be used ( Default 4 )

=back

=cut

$options{'threads=i'} = \( my $opt_threads = 4 );

=over 30

=item B<[--SeqPath (PATH)]>

I<[Required]> The path of input sequences ( Default "the current directory" )

=back

=cut

$options{'SeqPath=s'} = \( my $opt_SeqPath = "./" );

=over 30

=item B<[--SequenceType (STRING)]>

I<[Required]> Sequence type for inputs. "reads", "nucl", "orfs", and "prot" avaliable ( Default nucl )

=back

=cut

$options{'SequenceType=s'} = \( my $opt_SequenceType = "nucl" );

=over 30

=item B<[--platform (STRING)]>

I<[Required]> Sequencing Platform, "illumina", "pacbio", "oxford" and "hybrid" available ( Default illumina )

=back

=cut

$options{'platform=s'} = \(my $opt_platform = "illumina");

=over 30

=item B<[--assemble_only (STRING)]>

Only perform genome assembly without predicting toxins.

=back

=cut

$options{'assemble_only'} = \(my $opt_assemble_only);

=over 30

=item B<[--reads1 (STRING)]>

I<[Required by "reads"]> The suffix name of reads 1 ( for example: if the name of reads 1 is "YBT-1520_L1_I050.R1.clean.fastq.gz", "YBT-1520" is the strain same, so the suffix name should be ".R1.clean.fastq.gz" )

=back

=cut

$options{'reads1=s'} = \(my $opt_reads1);

=over 30

=item B<[--reads2 (STRING)]>

I<[Required by "reads"]> The suffix name of reads 2( not required by "oxford" and "pacbio". For example: if the name of reads 2 is "YBT-1520_2.fq", the suffix name should be _2.fq" )

=back

=cut

$options{'reads2=s'} = \(my $opt_reads2);

=over 30

=item B<[--suffix_len (INT)]>

I<[Required by "reads"]> B<(Strongly recommended)> The suffix length of the reads file, that is the length of the reads name minus the length of the strain name. For example the --suffix_len of "YBT-1520_L1_I050.R1.clean.fastq.gz" is 26 ( "YBT-1520" is the strain name ) ( Default 0 )

=back

=cut

$options{'suffix_len=i'} = \(my $opt_suffix_len = 0);

=over 30

=item B<[--short1 (STRING)]>

I<[Required]> FASTQ file of first short reads in each pair. Needed by hybrid assembly ( Default Unset )

=back

=cut

$options{'short1=s'} = \(my $opt_short1);

=over 30

=item B<[--short2 (STRING)]>

I<[Required]> FASTQ file of second short reads in each pair. Needed by hybrid assembly ( Default Unset )

=back

=cut

$options{'short2=s'} = \(my $opt_short2);

=over 30

=item B<[--long (STRING)]>

I<[Required]> FASTQ or FASTA file of long reads. Needed by hybrid assembly ( Default Unset )

=back

=cut

$options{'long=s'} = \(my $opt_long);

=over 30

=item B<[--hout (STRING)]>

I<[Required]> Output directory for hybrid assembly ( Default ../../Results/Assembles/Hybrid )

=back

=cut

$options{'hout=s'} = \(my $opt_hout = '../../Results/Assembles/Hybrid');

=over 30

=item B<[--genomeSize (STRING)]>

I<[Required]> An estimate of the size of the genome. Common suffixes are allowed, for example, 3.7m or 2.8g. Needed by PacBio data and Oxford data ( Default 6.07m )

=back

=cut

$options{'genomeSize=s'} = \(my $opt_genomeSize = "6.07m");

=over 30

=item B<[--Scaf_suffix (STRING)]>

The suffix of scaffolds or genomes ( Default ".filtered.fas" )

=back

=cut

$options{'Scaf_suffix=s'} = \( my $opt_Scaf_suffix = ".filtered.fas" );

=over 30

=item B<[--orfs_suffix (STRING)]>

The suffix of orfs files ( Default ".ffn" )

=back

=cut

$options{'orfs_suffix=s'} = \( my $opt_orfs_suffix = ".ffn" );

=over 30

=item B<[--prot_suffix (STRING)]>

The suffix of protein files ( Default ".faa" )

=back

=cut

$options{'prot_suffix=s'} = \( my $opt_prot_suffix = ".faa" );

tee STDOUT, ">>BtToxin_scanner.log";

GetOptions(%options) or pod2usage("Try '$0 --help' for more information.");

if($opt_version){
	print "version: 2.0.1\n";
	exit 0;
}

#pod2usage( -verbose => 1 ) if $opt_help;
if ($opt_help) {
	pod2usage(1);
	exit 0;
}

# toxin prediction
if ($opt_SequenceType eq "nucl") {
	my @scaf = glob("$opt_SeqPath/*$opt_Scaf_suffix");
	foreach  (@scaf) {
		$_=~/$opt_SeqPath\/(\S+)$opt_Scaf_suffix/;
		my $out = $1;
		system("coreprocess.pl $_ $out nucl");
	}
	chdir "Results/Toxins";
	system("get_all_info_nucl.pl");
	chdir "../../";
}elsif ($opt_SequenceType eq "orfs") {
	my @orfs = glob("$opt_SeqPath/*$opt_orfs_suffix");
	foreach  (@orfs) {
		$_=~/$opt_SeqPath\/(\S+)$opt_orfs_suffix/;
		my $out = $1;
		system("coreprocess.pl $_ $out orfs");
	}
	chdir "Results/Toxins";
	system("get_all_info_orfs.pl");
	chdir "../../";
}elsif ($opt_SequenceType eq "prot") {
	my @prot = glob("$opt_SeqPath/*$opt_prot_suffix");
	foreach  (@prot) {
		$_=~/$opt_SeqPath\/(\S+)$opt_prot_suffix/;
		my $out = $1;
		system(" coreprocess.pl $_ $out prot");
	}
	chdir "Results/Toxins";
	system("get_all_info_prot.pl");
	chdir "../../";
}elsif ($opt_SequenceType eq "reads") {
	if ($opt_platform eq "illumina") {
		system("pgcgap --Assemble --platform illumina --assembler auto --filter_length 200 --ReadsPath $opt_SeqPath --reads1 $opt_reads1 --reads2 $opt_reads2 --kmmer 81 --threads $opt_threads --suffix_len $opt_suffix_len");
		if (! $opt_assemble_only) {
			my @scaf = glob("Results/Assembles/Scaf/Illumina/*.filtered.fas");
			foreach  (@scaf) {
				$_=~/Results\/Assembles\/Scaf\/Illumina\/(\S+).filtered.fas/;
				my $out = $1;
				system("coreprocess.pl $_ $out nucl");
			}
			chdir "Results/Toxins";
			system("get_all_info_nucl.pl");
			chdir "../../";
		}
	}elsif ($opt_platform eq "oxford") {
		system("pgcgap --Assemble --platform oxford --filter_length 200 --ReadsPath $opt_SeqPath --reads1 $opt_reads1 --genomeSize 4.8m --threads $opt_threads --suffix_len $opt_suffix_len");
		if (! $opt_assemble_only) {
			my @scaf = glob("Results/Assembles/Scaf/Oxford/*.filtered.fas");
			foreach  (@scaf) {
				$_=~/Results\/Assembles\/Scaf\/Oxford\/(\S+).filtered.fas/;
				my $out = $1;
				system("coreprocess.pl $_ $out nucl");
			}
			chdir "Results/Toxins";
			system("get_all_info_nucl.pl");
			chdir "../../";
		}
	}elsif ($opt_platform eq "pacbio") {
		system("pgcgap --Assemble --platform pacbio --filter_length 200 --ReadsPath $opt_SeqPath --reads1 $opt_reads1 --genomeSize 4.8m --threads $opt_threads --suffix_len $opt_suffix_len");
			if (! $opt_assemble_only) {
			my @scaf = glob("Results/Assembles/Scaf/PacBio/*.filtered.fas");
			foreach  (@scaf) {
				$_=~/Results\/Assembles\/Scaf\/PacBio\/(\S+).filtered.fas/;
				my $out = $1;
				system("coreprocess.pl $_ $out nucl");
			}
			chdir "Results/Toxins";
			system("get_all_info_nucl.pl");
			chdir "../../";
		}
	}elsif ($opt_platform eq "hybrid") {
		system("pgcgap --Assemble --platform hybrid --ReadsPath $opt_SeqPath --short1 $opt_short1 --short2 $opt_short2 --long $opt_long --threads $opt_threads");
		if (! $opt_assemble_only) {
			my @scaf = glob("Results/Assembles/Hybrid/*.fasta");
			foreach  (@scaf) {
				$_=~/Results\/Assembles\/Hybrid\/(\S+).fasta/;
				my $out = $1;
				system("coreprocess.pl $_ $out nucl");
			}
			chdir "Results/Toxins";
			system("get_all_info_nucl.pl");
			chdir "../../";
		}
	}
}

# get toxin tables
if (! $opt_assemble_only) {
	chdir "Results/Toxins";
	system("get_genes_table.pl");
	chdir "../../";
}