
"OraVariable is a 0-indexed array of OpiData."
function OraVariable(
        connection::Connection,
        oracle_type::OraOracleTypeNum,
        native_type::OraNativeTypeNum,
        ;
        buffer_capacity::Integer=ORA_DEFAULT_FETCH_ARRAY_SIZE,
        max_byte_string_size::Integer=4000, # maximum size allowed for VARCHAR2 fields
        is_PLSQL_array::Bool=false,
        object_type_handle::Ptr{Cvoid}=C_NULL)

    var_handle_ref = Ref{Ptr{Cvoid}}()
    buffer_handle_ref = Ref{Ptr{OraData}}()

    size_is_bytes = Int32(1) # always pass max_byte_string_size in bytes

    result = dpiConn_newVar(
        connection.handle,
        oracle_type,
        native_type,
        UInt32(buffer_capacity),
        UInt32(max_byte_string_size),
        size_is_bytes,
        Int32(is_PLSQL_array),
        object_type_handle,
        var_handle_ref,
        buffer_handle_ref)

    error_check(context(connection), result)

    return OraVariable(
        connection,
        var_handle_ref[],
        oracle_type,
        native_type,
        UInt32(max_byte_string_size),
        Int32(is_PLSQL_array),
        object_type_handle,
        buffer_handle_ref[],
        UInt32(buffer_capacity))
end

"""
    define(stmt::QueryStmt, column_position::Integer, variable::OraVariable)

Defines the variable that will be used to fetch rows from the statement.
`stmt` must be an executed statement.

A OraVariable `v` bound to a statement `stmt` must satisfy:

`v.buffer_capacity >= fetch_array_size(stmt)`
"""
function define(stmt::QueryStmt, column_position::Integer, variable::OraVariable)
    @assert variable.buffer_capacity >= fetch_array_size(stmt) "Variable buffer capacity ($(variable.buffer_capacity)) must be greater than statement fetch array size ($(fetch_array_size(stmt)))."
    result = dpiStmt_define(stmt.handle, UInt32(column_position), variable.handle)
    error_check(context(stmt), result)
    nothing
end

function Base.setindex!(variable::OraVariable, value, pos::Integer)
    check_bounds(variable, pos)
    native_value = NativeValue(variable.native_type, variable.buffer_handle)
    native_value[pos] = value
    nothing
end

function Base.setindex!(variable::OraVariable, value::String, pos::Integer)
    check_bounds(variable, pos)
    result = dpiVar_setFromBytes(variable.handle, UInt32(pos), value)
    error_check(context(variable), result)
    nothing
end

function Base.getindex(variable::OraVariable, pos::Integer)
    check_bounds(variable, pos)
    native_value = NativeValue(variable.native_type, variable.buffer_handle)
    return native_value[pos]
end

@inline function check_bounds(variable::OraVariable, pos::Integer)
    # pos is 0-indexed
    @assert pos >= 0 "Cannot bind variable at a negative position ($pos)."
    @assert pos < variable.buffer_capacity "Position $pos is greater than variable's buffer capacity $(variable.buffer_capacity)."
end

function find_max_byte_string_size(v::Vector{T}) where {T<:Union{AbstractString, Missing}}
    if isempty(v)
        return 0
    end

    len = length(v)
    max_size = sizeof(v[1])

    if len == 1
        return max_size
    else
        for i in 2:len
            max_size = max(max_size, sizeof(v[i]))
        end

        return max_size
    end
end

@generated function build_variable(conn::Connection, column::Vector{T}; is_PLSQL_array::Bool=false) where T

    if T <: Union{Missing, Float64}
        oracle_type = :ORA_ORACLE_TYPE_NATIVE_DOUBLE
        native_type = :ORA_NATIVE_TYPE_DOUBLE
        max_byte_string_size = 0

    elseif T <: Union{Missing, Bool}
        oracle_type = :ORA_ORACLE_TYPE_BOOLEAN
        native_type = :ORA_NATIVE_TYPE_BOOLEAN
        max_byte_string_size = 0

    elseif T <: Union{Missing, Int64}
        oracle_type = :ORA_ORACLE_TYPE_NATIVE_INT
        native_type = :ORA_NATIVE_TYPE_INT64
        max_byte_string_size = 0

    elseif T <: Union{Missing, UInt64}
        oracle_type = :ORA_ORACLE_TYPE_NATIVE_UINT
        native_type = :ORA_NATIVE_TYPE_UINT64
        max_byte_string_size = 0

    elseif T <: Union{Missing, Float32}
        oracle_type = :ORA_ORACLE_TYPE_NATIVE_FLOAT
        native_type = :ORA_NATIVE_TYPE_FLOAT
        max_byte_string_size = 0

    elseif T <: Union{Missing, String}
        # TODO: choose appropriate oracle_type based on string length
        oracle_type = :ORA_ORACLE_TYPE_NVARCHAR
        native_type = :ORA_NATIVE_TYPE_BYTES
        max_byte_string_size = :(find_max_byte_string_size(column))

    else
        error("Julia type $T not supported for OraVariables.")
    end

    return quote
        capacity = length(column)

        variable = OraVariable(conn, $oracle_type, $native_type;
            buffer_capacity=capacity,
            max_byte_string_size=$max_byte_string_size,
            is_PLSQL_array=is_PLSQL_array,
            object_type_handle=C_NULL)

        for i in 1:capacity
            variable[i-1] = column[i] # variables are 0-indexed
        end

        return variable
    end
end
