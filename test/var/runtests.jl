module TestVar

using Base.Test

using Bio.Seq
using Bio.Var
import Bio
import YAML
import BufferedStreams: BufferedInputStream

@testset "Counting mutations" begin

    # Create a 20bp test DNA sequence pair containing every possible transition (4),
    # every possible transversion (8), and 2 gapped sites and 2 ambiguous sites.
    # This leaves 4 sites non-mutated/conserved.
    dnas = [dna"ATTG-ACCTGGNTTTCCGAA", dna"A-ACAGAGTATACRGTCGTC"]
    m1 = seqmatrix(dnas, :seq)

    rnas = [rna"AUUG-ACCUGGNUUUCCGAA", rna"A-ACAGAGUAUACRGUCGUC"]
    m2 = seqmatrix(rnas, :seq)

    @test count_mutations(AnyMutation, dnas) == count_mutations(AnyMutation, rnas) == ([12], [16])
    @test count_mutations(AnyMutation, m1) == count_mutations(AnyMutation, m2) == ([12], [16])
    @test count_mutations(TransitionMutation, dnas) == count_mutations(TransitionMutation, rnas) == ([4], [16])
    @test count_mutations(TransitionMutation, m1) == count_mutations(TransitionMutation, m2) == ([4], [16])
    @test count_mutations(TransversionMutation, dnas) == count_mutations(TransversionMutation, rnas) == ([8], [16])
    @test count_mutations(TransversionMutation, m1) == count_mutations(TransversionMutation, m2) == ([8], [16])
    @test count_mutations(TransitionMutation, TransversionMutation, dnas) == count_mutations(TransitionMutation, TransversionMutation, rnas) == ([4], [8], [16])
    @test count_mutations(TransitionMutation, TransversionMutation, m1) == count_mutations(TransitionMutation, TransversionMutation, m2) == ([4], [8], [16])
    @test count_mutations(TransversionMutation, TransitionMutation, dnas) == count_mutations(TransversionMutation, TransitionMutation, rnas) == ([4], [8], [16])
    @test count_mutations(TransversionMutation, TransitionMutation, m1) == count_mutations(TransversionMutation, TransitionMutation, m2) == ([4], [8], [16])

    ans = Bool[false, false, true, true, false, true, true, true, false, true, true, false, true, false, true, true, false, false, true, true]
    @test flagmutations(AnyMutation, m1)[1][:,1] == ans
    @test flagmutations(AnyMutation, m2)[1][:,1] == ans


end

@testset "Distance Computation" begin

    dnas1 = [dna"ATTG-ACCTGGNTTTCCGAA", dna"A-ACAGAGTATACRGTCGTC"]
    m1 = seqmatrix(dnas1, :seq)

    dnas2 = [dna"attgaacctggntttccgaa",
             dna"atacagagtatacrgtcgtc"]
    dnas3 = [dna"attgaacctgtntttccgaa",
             dna"atagaacgtatatrgccgtc"]
    m2 = seqmatrix(dnas2, :seq)

    @test distance(Count{AnyMutation}, dnas1) == ([12], [16])
    @test distance(Count{TransitionMutation}, dnas1) == ([4], [16])
    @test distance(Count{TransversionMutation}, dnas1) == ([8], [16])
    @test distance(Count{Kimura80}, dnas1) == ([4], [8], [16])
    @test distance(Count{AnyMutation}, m1) == ([12], [16])
    @test distance(Count{TransitionMutation}, m1) == ([4], [16])
    @test distance(Count{TransversionMutation}, m1) == ([8], [16])
    @test distance(Count{Kimura80}, m1) == ([4], [8], [16])

    @test distance(Count{AnyMutation}, dnas2, 5, 5)[1][:] == [2, 4, 3, 3]
    @test distance(Count{AnyMutation}, dnas2, 5, 5)[2][:] == [5, 5, 3, 5]
    @test distance(Count{TransitionMutation}, dnas2, 5, 5)[1][:] == [0, 2, 1, 1]
    @test distance(Count{TransitionMutation}, dnas2, 5, 5)[2][:] == [5, 5, 3, 5]
    @test distance(Count{TransversionMutation}, dnas2, 5, 5)[1][:] == [2, 2, 2, 2]
    @test distance(Count{TransversionMutation}, dnas2, 5, 5)[2][:] == [5, 5, 3, 5]
    @test distance(Count{Kimura80}, dnas1) == ([4], [8], [16])

    @test distance(Count{AnyMutation}, dnas2) == ([12], [18])
    @test distance(Count{TransitionMutation}, dnas2) == ([4], [18])
    @test distance(Count{TransversionMutation}, dnas2) == ([8], [18])
    @test distance(Count{Kimura80}, dnas2) == ([4], [8], [18])
    @test distance(Count{AnyMutation}, m2) == ([12], [18])
    @test distance(Count{TransitionMutation}, m2) == ([4], [18])
    @test distance(Count{TransversionMutation}, m2) == ([8], [18])
    @test distance(Count{Kimura80}, m2) == ([4], [8], [18])

    d = distance(Proportion{AnyMutation}, dnas2, 5, 5)
    a = [0.4, 0.8, 1.0, 0.6]
    for i in 1:length(d[1])
        @test_approx_eq_eps d[1][i] a[i] 1e-4
    end
    @test d[2][:] == [5, 5, 3, 5]
    d = distance(Proportion{TransitionMutation}, dnas2, 5, 5)
    a = [0.0, 0.4, 0.333333, 0.2]
    for i in 1:length(d[1])
        @test_approx_eq_eps d[1][i] a[i] 1e-4
    end
    @test d[2][:] == [5, 5, 3, 5]
    d = distance(Proportion{TransversionMutation}, dnas2, 5, 5)
    a = [0.4, 0.4, 0.666667, 0.4]
    for i in 1:length(d[1])
        @test_approx_eq_eps d[1][i] a[i] 1e-4
    end
    @test d[2][:] == [5, 5, 3, 5]

    @test distance(Proportion{AnyMutation}, dnas1) == ([(12 / 16)], [16])
    @test distance(Proportion{TransitionMutation}, dnas1) == ([(4 / 16)], [16])
    @test distance(Proportion{TransversionMutation}, dnas1) == ([(8 / 16)], [16])
    @test distance(Proportion{AnyMutation}, m1) == ([(12 / 16)], [16])
    @test distance(Proportion{TransitionMutation}, m1) == ([(4 / 16)], [16])
    @test distance(Proportion{TransversionMutation}, m1) == ([(8 / 16)], [16])

    @test distance(Proportion{AnyMutation}, dnas2) == ([(12 / 18)], [18])
    @test distance(Proportion{TransitionMutation}, dnas2) == ([(4 / 18)], [18])
    @test distance(Proportion{TransversionMutation}, dnas2) == ([(8 / 18)], [18])
    @test distance(Proportion{AnyMutation}, m2) == ([(12 / 18)], [18])
    @test distance(Proportion{TransitionMutation}, m2) == ([(4 / 18)], [18])
    @test distance(Proportion{TransversionMutation}, m2) == ([(8 / 18)], [18])

    @test distance(JukesCantor69, dnas1) == ([Inf], [Inf]) # Returns infinity as 12/16 is 0.75 - mutation saturation.
    @test distance(JukesCantor69, m1) == ([Inf], [Inf])

    @test round(distance(JukesCantor69, dnas2)[1][1], 3) == 1.648
    @test round(distance(JukesCantor69, dnas2)[2][1], 3) == 1
    @test round(distance(JukesCantor69, m2)[1][1], 3) == 1.648
    @test round(distance(JukesCantor69, m2)[2][1], 3) == 1
    @test_throws DomainError distance(JukesCantor69, dnas2, 5, 5)
    d = distance(JukesCantor69, dnas3, 5, 5)
    a = [0.232616, 0.571605, 0.44084, 0.571605]
    v = [0.0595041, 0.220408, 0.24, 0.220408]
    for i in 1:length(d[1])
        @test_approx_eq_eps d[1][i] a[i] 1e-5
        @test_approx_eq_eps d[2][i] v[i] 1e-5
    end

    @test round(distance(Kimura80, dnas2)[1][1], 3) == 1.648
    @test round(distance(Kimura80, dnas2)[2][1], 3) == 1
    @test round(distance(Kimura80, m2)[1][1], 3) == 1.648
    @test round(distance(Kimura80, m2)[2][1], 3) == 1

end

@testset "VCF" begin
    metainfo = VCFMetaInfo()
    @test !isfilled(metainfo)
    @test ismatch(r"^Bio.Var.VCFMetaInfo: <not filled>", repr(metainfo))
    @test_throws ArgumentError metainfokey(metainfo)

    metainfo = VCFMetaInfo(b"##source=foobar1234")
    @test isfilled(metainfo)
    @test metainfokey(metainfo) == "source"
    @test metainfoval(metainfo) == "foobar1234"

    metainfo = VCFMetaInfo(metainfo)
    @test isa(metainfo, VCFMetaInfo)
    metainfo = VCFMetaInfo(metainfo, key="date")
    @test metainfokey(metainfo) == "date"
    metainfo = VCFMetaInfo(metainfo, value="2017-01-30")
    @test metainfoval(metainfo) == "2017-01-30"
    metainfo = VCFMetaInfo(metainfo, key="INFO", value=["ID"=>"DP", "Number"=>"1", "Type"=>"Integer", "Description"=>"Total Depth"])
    @test metainfo["ID"] == "DP"
    @test metainfo["Number"] == "1"
    @test metainfo["Type"] == "Integer"
    @test metainfo["Description"] == "Total Depth"
    @test metainfokey(metainfo) == "INFO"
    @test metainfoval(metainfo) == """<ID=DP,Number=1,Type=Integer,Description="Total Depth">"""

    record = VCFRecord()
    @test !isfilled(record)
    @test ismatch(r"^Bio.Var.VCFRecord: <not filled>", repr(record))
    @test_throws ArgumentError chromosome(record)

    record = VCFRecord(b".\t.\t.\t.\t.\t.\t.\t.\t")
    @test isfilled(record)
    @test chromosome(record) == "."
    @test isnull(leftposition(record))

    record = VCFRecord(record)
    @test isa(record, VCFRecord)
    record = VCFRecord(record, chromosome="chr1")
    @test chromosome(record) == "chr1"
    record = VCFRecord(record, position=1234)
    @test get(leftposition(record)) == 1234
    record = VCFRecord(record, identifier="rs1111")
    @test identifier(record) == ["rs1111"]
    record = VCFRecord(record, reference="A")
    @test reference(record) == "A"
    record = VCFRecord(record, alternate=["AT"])
    @test alternate(record) == ["AT"]
    record = VCFRecord(record, quality=11.2)
    @test get(quality(record)) == 11.2
    record = VCFRecord(record, filter="PASS")
    @test Bio.Var.filter(record) == ["PASS"]
    record = VCFRecord(record, information=Dict("DP" => 20, "AA" => "AT", "DB"=>nothing))
    @test information(record, "DP") == "20"
    @test information(record, "AA") == "AT"
    @test information(record, "DB") == ""
    record = VCFRecord(record, genotype=[Dict("GT" => "0/0", "DP" => [10,20])])
    @test format(record) == ["DP", "GT"]
    @test genotype(record) == [["10,20", "0/0"]]

    # minimum header
    data = b"""
    ##fileformat=VCFv4.3
    #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
    """
    reader = VCFReader(BufferedInputStream(data))
    @test isa(header(reader), VCFHeader)
    let header = header(reader)
        @test length(header.metainfo) == 1
        @test metainfokey(header.metainfo[1]) == "fileformat"
        @test metainfoval(header.metainfo[1]) == "VCFv4.3"
        @test isempty(header.sampleID)
    end

    # realistic header
    data = b"""
    ##fileformat=VCFv4.2
    ##fileDate=20090805
    ##source=myImputationProgramV3.1
    ##reference=file:///seq/references/1000GenomesPilot-NCBI36.fasta
    ##contig=<ID=20,length=62435964,assembly=B36,md5=f126cdf8a6e0c7f379d618ff66beb2da,species="Homo sapiens",taxonomy=x>
    ##phasing=partial
    ##INFO=<ID=NS,Number=1,Type=Integer,Description="Number of Samples With Data">
    ##INFO=<ID=DP,Number=1,Type=Integer,Description="Total Depth">
    ##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency">
    ##INFO=<ID=AA,Number=1,Type=String,Description="Ancestral Allele">
    #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	NA00001	NA00002	NA00003
    """
    reader = VCFReader(BufferedInputStream(data))
    @test isa(header(reader), VCFHeader)

    let header = header(reader)
        @test length(header.metainfo) == 10

        let metainfo = header.metainfo[1]
            @test metainfokey(metainfo) == "fileformat"
            @test metainfoval(metainfo) == "VCFv4.2"
            @test_throws ArgumentError keys(metainfo)
            @test_throws ArgumentError values(metainfo)
        end

        let metainfo = header.metainfo[2]
            @test metainfokey(metainfo) == "fileDate"
            @test metainfoval(metainfo) == "20090805"
            @test_throws ArgumentError keys(metainfo)
            @test_throws ArgumentError values(metainfo)
        end

        let metainfo = header.metainfo[5]
            @test metainfokey(metainfo) == "contig"
            @test metainfoval(metainfo) == """<ID=20,length=62435964,assembly=B36,md5=f126cdf8a6e0c7f379d618ff66beb2da,species="Homo sapiens",taxonomy=x>"""
            @test keys(metainfo) == ["ID", "length", "assembly", "md5", "species", "taxonomy"]
            @test values(metainfo) == ["20", "62435964", "B36", "f126cdf8a6e0c7f379d618ff66beb2da", "Homo sapiens", "x"]
            @test metainfo["ID"] == "20"
            @test metainfo["md5"] == "f126cdf8a6e0c7f379d618ff66beb2da"
            @test metainfo["taxonomy"] == "x"
        end

        let metainfo = header.metainfo[7]
            @test metainfokey(metainfo) == "INFO"
            @test metainfoval(metainfo) == """<ID=NS,Number=1,Type=Integer,Description="Number of Samples With Data">"""
            @test keys(metainfo) == ["ID", "Number", "Type", "Description"]
            @test values(metainfo) == ["NS", "1", "Integer", "Number of Samples With Data"]
            @test metainfo["ID"] == "NS"
            @test metainfo["Type"] == "Integer"
        end

        @test header.sampleID == ["NA00001", "NA00002", "NA00003"]
    end

    data = b"""
    ##fileformat=VCFv4.3
    ##contig=<ID=chr1>
    ##contig=<ID=chr2>
    ##INFO=<ID=DP,Number=1,Type=Integer,Description="Total Depth">
    ##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency">
    ##FORMAT=<ID=GT,Number=1,Description="Genotype">
    #CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tNA00001\tNA00002
    chr1\t1234\trs001234\tA\tC\t30\tPASS\tDP=10;AF=0.3\tGT\t0|0\t0/1
    chr2\t4\t.\tA\tAA,AAT\t.\t.\tDP=5\tGT:DP\t0|1:42\t0/1
    """
    reader = VCFReader(BufferedInputStream(data))
    record = VCFRecord()

    @test read!(reader, record) === record
    @test chromosome(record) == "chr1"
    @test !isnull(leftposition(record))
    @test get(leftposition(record)) === 1234
    @test identifier(record) == ["rs001234"]
    @test reference(record) == "A"
    @test alternate(record) == ["C"]
    @test !isnull(quality(record))
    @test get(quality(record)) === 30.0
    @test Bio.Var.filter(record) == ["PASS"]
    @test information(record) == ["DP" => "10", "AF" => "0.3"]
    @test information(record, "DP") == "10"
    @test information(record, "AF") == "0.3"
    @test format(record) == ["GT"]
    @test genotype(record) == [["0|0"], ["0/1"]]
    @test genotype(record, 1) == genotype(record)[1]
    @test genotype(record, 2) == genotype(record)[2]
    @test genotype(record, 1, "GT") == "0|0"
    @test genotype(record, 2, "GT") == "0/1"
    @test genotype(record, 1:2, "GT") == ["0|0", "0/1"]
    @test genotype(record, :, "GT") == genotype(record, 1:2, "GT")
    @test ismatch(r"^Bio.Var.VCFRecord:\n.*", repr(record))

    @test read!(reader, record) === record
    @test chromosome(record) == "chr2"
    @test !isnull(leftposition(record))
    @test get(leftposition(record)) == 4
    @test isempty(identifier(record))
    @test reference(record) == "A"
    @test alternate(record) == ["AA", "AAT"]
    @test isnull(quality(record))
    @test isempty(Bio.Var.filter(record))
    @test information(record) == ["DP" => "5"]
    @test information(record, "DP") == "5"
    @test_throws KeyError information(record, "AF")
    @test format(record) == ["GT", "DP"]
    @test genotype(record) == [["0|1", "42"], ["0/1", "."]]
    @test genotype(record, 1) == genotype(record)[1]
    @test genotype(record, 2) == genotype(record)[2]
    @test genotype(record, 1, "GT") == "0|1"
    @test genotype(record, 1, "DP") == "42"
    @test genotype(record, 2, "GT") == "0/1"
    @test genotype(record, 2, "DP") == "."
    @test genotype(record, 1:2, "GT") == ["0|1", "0/1"]
    @test genotype(record, 1:2, "DP") == ["42", "."]
    @test genotype(record, :, "DP") == genotype(record, 1:2, "DP")
    @test_throws KeyError genotype(record, :, "BAD")

    @test_throws EOFError read!(reader, record)

    vcfdir = Pkg.dir("Bio", "test", "BioFmtSpecimens", "VCF")

    for specimen in YAML.load_file(joinpath(vcfdir, "index.yml"))
        filepath = joinpath(vcfdir, specimen["filename"])
        records = VCFRecord[]
        reader = open(VCFReader, filepath)
        output = IOBuffer()
        writer = VCFWriter(output, header(reader))
        for record in reader
            write(writer, record)
            push!(records, record)
        end
        close(reader)
        flush(writer)

        records2 = VCFRecord[]
        for record in VCFReader(IOBuffer(takebuf_array(output)))
            push!(records2, record)
        end
        @test records == records2
    end
end

function parsehex(str)
    return map(x -> parse(UInt8, x, 16), split(str, ' '))
end

@testset "BCF" begin
    record = BCFRecord()
    @test !isfilled(record)
    @test ismatch(r"^Bio.Var.BCFRecord: <not filled>", repr(record))
    @test_throws ArgumentError chromosome(record)

    record = BCFRecord()
    record.filled = true  # fool it
    record.sharedlen = 0x1c
    record.indivlen = 0x00
    # generated from bcftools 1.3.1 (htslib 1.3.1)
    record.data = parsehex("00 00 00 00 ff ff ff ff 01 00 00 00 01 00 80 7f 00 00 01 00 00 00 00 00 07 17 2e 00")
    @test chromosome(record) == 1
    record = BCFRecord(record)
    @test isa(record, BCFRecord)
    record = BCFRecord(record, chromosome=4)
    @test chromosome(record) == 4
    record = BCFRecord(record, position=1234)
    @test leftposition(record) == 1234
    record = BCFRecord(record, quality=12.3)
    @test quality(record) == 12.3f0
    record = BCFRecord(record, identifier="rs1234")
    @test identifier(record) == "rs1234"
    record = BCFRecord(record, reference="AT")
    @test reference(record) == "AT"
    record = BCFRecord(record, alternate=["ATT", "ACT"])
    @test alternate(record) == ["ATT", "ACT"]
    record = BCFRecord(record, filter=[2, 3])
    @test Bio.Var.filter(record) == [2, 3]
    record = BCFRecord(record, information=Dict(1 => Int8[42]))
    @test information(record) == [(1, 42)]
    @test information(record, simplify=false) == [(1, [42])]
    @test information(record, 1) == 42
    @test information(record, 1, simplify=false) == [42]

    reader = BCFReader(open("example.bcf"))
    record = BCFRecord()
    @test read!(reader, record) === record
    @test chromosome(record) == 1
    @test leftposition(record) == 14370
    @test identifier(record) == "rs6054257"
    @test reference(record) == "G"
    @test alternate(record) == ["A"]
    @test quality(record) == 29.0
    @test Bio.Var.filter(record) == [1]
    @test information(record) == [(1,3),(2,14),(3,0.5),(5,nothing),(6,nothing)]
    @test information(record, simplify=false) == [(1,[3]),(2,[14]),(3,[0.5]),(5,[]),(6,[])]
    @test genotype(record) == [(9,[[2,3],[4,3],[4,4]]),(10,[[48],[48],[43]]),(2,[[1],[8],[5]]),(11,[[51,51],[51,51],[-128,-128]])]
    @test genotype(record, 1) == [(9, [2,3]), (10, [48]), (2, [1]), (11, [51,51])]
    @test genotype(record, 1, 9) == [2,3]
    @test genotype(record, 1, 10) == [48]
    @test genotype(record, 2, 9) == [4,3]
    @test genotype(record, :, 9) == [[2,3],[4,3],[4,4]]
    @test ismatch(r"^Bio.Var.BCFRecord:\n.*", repr(record))
end

end # module TestVar
