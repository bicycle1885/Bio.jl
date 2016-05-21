# Precompile
# ==========

# Parser
# ------

if VERSION < v"0.5-"
    precompile(Base.open, (ASCIIString, Type{Seq.FASTA},))
    precompile(Base.open, (ASCIIString, Type{Seq.FASTQ},))
    precompile(Base.open, (ASCIIString, Type{Intervals.BED},))
else
    # temporarily disable these precompiles to avoid a segfault (Bio.jl#191)
    #precompile(Base.open, (String, Type{Seq.FASTA},))
    #precompile(Base.open, (String, Type{Seq.FASTQ},))
    #precompile(Base.open, (String, Type{Intervals.BED},))
end
precompile(Base.read, (Seq.FASTAParser{Seq.BioSequence},))
precompile(Base.read, (Seq.FASTAParser{Seq.DNASequence},))
precompile(Base.read, (Seq.FASTAParser{Seq.RNASequence},))
precompile(Base.read, (Seq.FASTAParser{Seq.AminoAcidSequence},))
precompile(Base.read, (Seq.FASTQParser{Seq.DNASequence},))
precompile(Base.read, (Intervals.BEDParser,))
