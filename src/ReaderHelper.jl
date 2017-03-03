# Reader Helper
# =============
#
# Utilities to generate file readers in Bio.jl.
#
# This file is a part of BioJulia.
# License is MIT: https://github.com/BioJulia/Bio.jl/blob/master/LICENSE.md

module ReaderHelper

import Automa
import BufferedStreams

@inline function anchor!(stream::BufferedStreams.BufferedInputStream, p)
    stream.anchor = p
    stream.immobilized = true
    return stream
end

@inline function upanchor!(stream::BufferedStreams.BufferedInputStream)
    @assert stream.anchor != 0 "upanchor! called with no anchor set"
    anchor = stream.anchor
    stream.anchor = 0
    stream.immobilized = false
    return anchor
end

function ensure_margin!(stream::BufferedStreams.BufferedInputStream)
    if stream.position * 20 > length(stream.buffer) * 19
        BufferedStreams.shiftdata!(stream)
    end
    return nothing
end

function resize_and_copy!(dst::Vector{UInt8}, src::Vector{UInt8}, r::UnitRange{Int})
    rlen = length(r)
    if length(dst) != rlen
        resize!(dst, rlen)
    end
    copy!(dst, 1, src, first(r), rlen)
    return dst
end

function generate_read_functions(format_name, reader_type, machine, actions)
    quote
        function Base.read!(reader::$(reader_type), record::eltype($(reader_type)))::eltype($(reader_type))
            return _read!(reader, reader.state, record)
        end

        function _read!(reader::$(reader_type), state::Bio.Ragel.State, record::eltype($(reader_type)))
            stream = state.stream
            Bio.ReaderHelper.ensure_margin!(stream)
            initialize!(record)
            cs = state.cs
            linenum = state.linenum
            data = stream.buffer
            p = stream.position
            p_end = stream.available
            p_eof = -1
            offset = mark = 0
            found_record = false

            while true
                $(Automa.generate_exec_code(machine, actions=actions, code=:goto, check=false))

                state.cs = cs
                state.finished = cs == 0
                state.linenum = linenum
                stream.position = p

                if cs < 0
                    error("$(format) file format error on line ", linenum)
                elseif found_record
                    Bio.ReaderHelper.resize_and_copy!(record.data, data, Bio.ReaderHelper.upanchor!(stream):p-2)
                    record.filled = true
                    break
                elseif cs == 0
                    throw(EOFError())
                elseif p > p_eof ≥ 0
                    error("incomplete $(format_name) input on line ", linenum)
                else
                    hits_eof = BufferedStreams.fillbuffer!(stream) == 0
                    p = stream.position
                    p_end = stream.available
                    if hits_eof
                        p_eof = p_end
                    end
                end
            end

            return record
        end
    end
end

end