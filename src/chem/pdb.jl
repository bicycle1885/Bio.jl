export
    PDB,
    PDBRecord,
    ModelRecord,
    AtomRecord,
    TerRecord,
    EndModelRecord

import Bio.Seq: FileFormat

immutable PDB <: FileFormat end

#=
# minimal mutable string
type StringBuffer <: DirectIndexString
    data::Vector{Uint8}
    function StringBuffer(n::Int)
        new(zeros(Uint8, n))
    end
end

Base.getindex(s::StringBuffer, i::Int) = char(s.data[i])
Base.getindex(s::StringBuffer, r::UnitRange{Int}) = SubString(s, first(r), last(r))
Base.endof(s::StringBuffer) = length(s.data)
Base.start(s::StringBuffer) = 1
Base.done(s::StringBuffer, i::Int) = i > endof(s)
Base.next(s::StringBuffer, i::Int) = s[i], i + 1
Base.readbytes!(io::IO, s::StringBuffer) = readbytes!(io, s.data)
=#

type PDBRecordParser
    input::IO
    strict::Bool
    linen::Int
    line::ASCIIString
    function PDBRecordParser(input::IO, strict::Bool)
        new(input, strict, 0)
    end
end

function PDBRecordParser(filename::String, strict::Bool)
    input = open(filename)
    finalizer(input, input -> close(input))
    return PDBRecordParser(input, strict)
end

function Base.getindex(p::PDBRecordParser, r::Union(Int,UnitRange{Int}))
    return p.line[r]
end

function nextrecord!(p::PDBRecordParser)
    while !eof(p.input)
        p.line = readline(p.input)
        p.linen += 1
        if startswith(p.line, "MODEL ")
            return parse(ModelRecord, p)
        elseif startswith(p.line, "ATOM  ")
            return parse(AtomRecord, p)
        elseif startswith(p.line, "HETATM")
            return parse(AtomRecord, p)
        elseif startswith(p.line, "TER   ")
            return parse(TerRecord, p)
        elseif startswith(p.line, "ENDMDL")
            return parse(EndModelRecord, p)
        else
            # unknown record
            if p.strict
                error("unknown record at line $(p.linen): '$(p.line)'")
            end
        end
    end
    return nothing
end


abstract PDBRecord

immutable ModelRecord <: PDBRecord
    serial::Int
end

immutable AtomRecord <: PDBRecord
    hetero::Bool
    serial::Int
    name::ASCIIString
    altloc::Char
    resname::ASCIIString
    chainID::Char
    resseq::Int
    icode::Char
    x::Float32
    y::Float32
    z::Float32
    occupancy::Float32
    tempfactor::Float32
    element::Element
    charge::ASCIIString
end

immutable TerRecord <: PDBRecord
    serial::Int
    resname::ASCIIString
    chainID::Char
    resseq::Int
    icode::Char
end

immutable EndModelRecord <: PDBRecord
end

function parse(::Type{ModelRecord}, p)
    serial = parse(Int, p[11:14])
    return ModelRecord(serial)
end

function parse(::Type{AtomRecord}, p)
    hetero = p[1:6] == "HETATM"
    serial = parse(Int, p[7:11])
    name = strip(p[13:16])
    altloc = p[17]
    resname = strip(p[18:20])
    chainID = p[22]
    resseq = parse(Int, p[23:26])
    icode = p[27]
    x = parse(Float32, p[31:38])
    y = parse(Float32, p[39:46])
    z = parse(Float32, p[47:54])
    occupancy = parse(Float32, p[55:60])
    tempfactor = parse(Float32, p[61:66])
    element = parse(Element, p[77:78])
    charge = p[79:80]
    return AtomRecord(
        hetero, serial, name, altloc, resname, chainID, resseq, icode,
        x, y, z, occupancy, tempfactor, element, charge
    )
end

function parse(::Type{TerRecord}, p)
    serial = parse(Int, p[7:11])
    resname = strip(p[18:20])
    chainID = p[22]
    resseq = parse(Int, p[23:26])
    icode = p[27]
    return TerRecord(serial, resname, chainID, resseq, icode)
end

function parse(::Type{EndModelRecord}, p)
    return EndModelRecord()
end


type PDBRecordIterator
    parser::PDBRecordParser
    done::Bool
    nextrecord
    PDBRecordIterator(parser::PDBRecordParser) = new(parser, false)
end

function advance!(it::PDBRecordIterator)
    it.nextrecord = nextrecord!(it.parser)
    it.done = eof(it.parser.input)
    return nothing
end

function start(it::PDBRecordIterator)
    advance!(it)
    return nothing
end

function done(it::PDBRecordIterator, state)
    return it.done
end

function next(it::PDBRecordIterator, state)
    nextrecord = it.nextrecord
    advance!(it)
    return nextrecord, nothing
end

function read(filename::String, ::Type{PDB}; strict::Bool=false)
    return PDBRecordIterator(PDBRecordParser(filename, strict))
end

function read(input::IO, ::Type{PDB}; strict::Bool=true)
    return PDBRecordIterator(PDBRecordParser(input, strict))
end
