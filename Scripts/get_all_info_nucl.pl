#!/usr/bin/env perl
use strict;
use warnings;

local $/ = "//";

open OUT, ">All_Toxins.txt" || die;
print OUT "Strain\tProtein_id\tProtein_len\tStrand\tGene location on scaffold\tSVM\tBLAST\tHMM\tHit_id\tHit_length\tAln_length\tQuery start-end\tHit stard-end\tIdentity\tEvalue of blast\tHmm hit\tHmm hit length\tEvalue of Hmm\tGene sequence\tProtein sequence\tScaffold sequence\n";

my @gbk = glob("*.gbk");
foreach my $gbk (@gbk) {
	$gbk=~/(.+).gbk/;
	my $str = $1;
	open IN, "$gbk" || die;
	while (<IN>) {
		chomp;
		if (/LOCUS/) {
			my $protein_id;
			my $protein_len;
			my $svm_prediction = "NO";
			my $blast_prediction = "NO";
			my $hmm_prediction = "NO";
			my $strand = "NA";
			my $dna_coor = "NA";
			my $aa_coor = "NA";
			my $Hit_id = "NA";
			my $Hit_length = "NA";
			my $Hit_coor = "NA";
			my $Aln_length = "NA";
			my $identity = "NA";
			my $Evalue_blast = "NA";
			my $translation;
			my @scaf;
			my $scaffold;
			my $Hmm_name = "NA";
			my $Hmm_len = "NA";
			my $Evalue_Hmm = "NA";

			if (/protein_id=\"(.+?)\"/) {
				$protein_id = $1;
			}
			if (/protein_len=\"(\d+)\"/) {
				$protein_len = $1;
			}
			if (/svm_prediction=\"(\S+?)\"/) {
				$svm_prediction = $1;
			}
			if (/blast_prediction=\"(\S+?)\"/) {
				$blast_prediction = $1;
				if ($blast_prediction eq "YES") {
					if (/blast_detail=\"Query_desc:(\S+)\s+(\S+)/) {
						$strand = $1;
						$dna_coor = $2;
					}
					if (/Query_Start-End:(\S+)\s+Hit_id:(\S+)/) {
						$aa_coor = $1;
						$Hit_id = $2;
					}
					if (/Hit_length:(\d+)\s+Hit_Start-End:(\S+)/) {
						$Hit_length = $1;
						$Hit_coor = $2;
					}
					if (/Aln_length:(\d+)\s+Percent_identity:(\S+)\s+E-value:(\S+)\"/) {
						$Aln_length = $1;
						$identity = $2;
						$Evalue_blast = $3;
					}
				}
			}
			if (/translation=\"([\d\D]+?)\"/) {
				my @seqs = split /\s+/, $1;
				$translation = join("", @seqs);
			}
			if (/ORIGIN([\d\D]+)/) {
				my @seq = split /\s+/, $1;
				my @scafs;
				foreach  (@seq) {
					if (!/\d+/) {
						push @scafs, $_;
					}
				}
				$scaffold = uc(join("", @scafs));
			}
			if (/hmm_prediction=\"(\S+?)\"/) {
				$hmm_prediction = $1;
				if ($hmm_prediction eq "YES") {
					if (/hmm_detail="Hit_desc:(\S+)\s+(\S+)/) {
						$strand = $1;
						$dna_coor = $2;
					}
					if (/Hmm_name:(\S+)\s+Hmm_len:(\d+)\s+E-value:(\S+)\"/) {
						$Hmm_name = $1;
						$Hmm_len = $2;
						$Evalue_Hmm = $3;
					}
				}
			}
			my $cds;
			$dna_coor=~/(\d+)-(\d+)/;
			my $start = $1;
			my $end = $2;
			if ($start > $end) {
				($start,$end) = ($end,$start);
				my $start1 = $start - 1;
				my $part = substr($scaffold,$start1, $end-$start1);
				$cds= &reverse_complement($part);
			}else{
				my $start1 = $start - 1;
				my $part = substr($scaffold,$start1, $end-$start1);
				$cds= $part;
			}
			print OUT "$str\t$protein_id\t$protein_len\t$strand\t$dna_coor\t$svm_prediction\t$blast_prediction\t$hmm_prediction\t$Hit_id\t$Hit_length\t$Aln_length\t$aa_coor\t$Hit_coor\t$identity\t$Evalue_blast\t$Hmm_name\t$Hmm_len\t$Evalue_Hmm\t$cds\t$translation\t$scaffold\n";
		}
	}
	close IN;
}
close OUT;

sub reverse_complement {
	my $dna = shift;
	my $revcomp = reverse($dna);# reverse the DNA sequence
	$revcomp =~ tr/ACGTacgt/TGCAtgca/;# complement the reversed DNA sequence
	return $revcomp;
}
