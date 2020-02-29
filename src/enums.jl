
@enum OraResult::Int32 begin
    ORA_SUCCESS = 0
    ORA_FAILURE = -1
end

"""
This enumeration identifies the mode to use when authorizing connections to the database.
"""
@enum OraAuthMode::UInt32 begin
    ORA_MODE_AUTH_DEFAULT = 0
    ORA_MODE_AUTH_SYSDBA  = 2
    ORA_MODE_AUTH_SYSOPER = 4
    ORA_MODE_AUTH_PRELIM  = 8
    ORA_MODE_AUTH_SYSASM  = 32768
    ORA_MODE_AUTH_SYSBKP  = 131072
    ORA_MODE_AUTH_SYSDGD  = 262144
    ORA_MODE_AUTH_SYSKMT  = 524288
    ORA_MODE_AUTH_SYSRAC  = 1048576
end

@enum OraConnCloseMode::UInt32 begin
    ORA_MODE_CONN_CLOSE_DEFAULT = 0
    ORA_MODE_CONN_CLOSE_DROP    = 1
    ORA_MODE_CONN_CLOSE_RETAG   = 2
end

"""
This enumeration identifies the mode to use when creating connections to the database. Note that the OCI objects mode is always enabled.
"""
@enum OraCreateMode::UInt32 begin
    ORA_MODE_CREATE_DEFAULT  = 0
    ORA_MODE_CREATE_THREADED = 1
    ORA_MODE_CREATE_EVENTS   = 4
end

"""
This enumeration identifies the mode to use when getting sessions from a session pool.
"""
@enum OraPoolGetMode::UInt8 begin
    ORA_MODE_POOL_GET_WAIT      = 0
    ORA_MODE_POOL_GET_NOWAIT    = 1
    ORA_MODE_POOL_GET_FORCEGET  = 2
    ORA_MODE_POOL_GET_TIMEDWAIT = 3
end

"""
This enumeration identifies the purity of the sessions that are acquired when using connection classes during connection creation.
"""
@enum OraPurity::UInt32 begin
    ORA_PURITY_DEFAULT = 0
    ORA_PURITY_NEW     = 1
    ORA_PURITY_SELF    = 2
end

@enum OraShutdownMode::UInt32 begin
    ORA_MODE_SHUTDOWN_DEFAULT             = 0
    ORA_MODE_SHUTDOWN_TRANSACTIONAL       = 1
    ORA_MODE_SHUTDOWN_TRANSACTIONAL_LOCAL = 2
    ORA_MODE_SHUTDOWN_IMMEDIATE           = 3
    ORA_MODE_SHUTDOWN_ABORT               = 4
    ORA_MODE_SHUTDOWN_FINAL               = 5
end

@enum OraStartupMode::UInt32 begin
    ORA_MODE_STARTUP_DEFAULT  = 0
    ORA_MODE_STARTUP_FORCE    = 1
    ORA_MODE_STARTUP_RESTRICT = 2
end

@enum OraExecMode::UInt32 begin
    ORA_MODE_EXEC_DEFAULT             = 0
    ORA_MODE_EXEC_DESCRIBE_ONLY       = 16
    ORA_MODE_EXEC_COMMIT_ON_SUCCESS   = 32
    ORA_MODE_EXEC_BATCH_ERRORS        = 128
    ORA_MODE_EXEC_PARSE_ONLY          = 256
    ORA_MODE_EXEC_ARRAY_DML_ROWCOUNTS = 1048576
end

@enum OraOracleTypeNum::UInt32 begin
    ORA_ORACLE_TYPE_NONE          = 2000
    ORA_ORACLE_TYPE_VARCHAR       = 2001
    ORA_ORACLE_TYPE_NVARCHAR      = 2002
    ORA_ORACLE_TYPE_CHAR          = 2003
    ORA_ORACLE_TYPE_NCHAR         = 2004
    ORA_ORACLE_TYPE_ROWID         = 2005
    ORA_ORACLE_TYPE_RAW           = 2006
    ORA_ORACLE_TYPE_NATIVE_FLOAT  = 2007
    ORA_ORACLE_TYPE_NATIVE_DOUBLE = 2008
    ORA_ORACLE_TYPE_NATIVE_INT    = 2009
    ORA_ORACLE_TYPE_NUMBER        = 2010
    ORA_ORACLE_TYPE_DATE          = 2011
    ORA_ORACLE_TYPE_TIMESTAMP     = 2012
    ORA_ORACLE_TYPE_TIMESTAMP_TZ  = 2013
    ORA_ORACLE_TYPE_TIMESTAMP_LTZ = 2014
    ORA_ORACLE_TYPE_INTERVAL_DS   = 2015
    ORA_ORACLE_TYPE_INTERVAL_YM   = 2016
    ORA_ORACLE_TYPE_CLOB          = 2017
    ORA_ORACLE_TYPE_NCLOB         = 2018
    ORA_ORACLE_TYPE_BLOB          = 2019
    ORA_ORACLE_TYPE_BFILE         = 2020
    ORA_ORACLE_TYPE_STMT          = 2021
    ORA_ORACLE_TYPE_BOOLEAN       = 2022
    ORA_ORACLE_TYPE_OBJECT        = 2023
    ORA_ORACLE_TYPE_LONG_VARCHAR  = 2024
    ORA_ORACLE_TYPE_LONG_RAW      = 2025
    ORA_ORACLE_TYPE_NATIVE_UINT   = 2026
    ORA_ORACLE_TYPE_MAX           = 2027
end

@enum OraNativeTypeNum::UInt32 begin
    ORA_NATIVE_TYPE_INT64       = 3000
    ORA_NATIVE_TYPE_UINT64      = 3001
    ORA_NATIVE_TYPE_FLOAT       = 3002
    ORA_NATIVE_TYPE_DOUBLE      = 3003
    ORA_NATIVE_TYPE_BYTES       = 3004
    ORA_NATIVE_TYPE_TIMESTAMP   = 3005
    ORA_NATIVE_TYPE_INTERVAL_DS = 3006
    ORA_NATIVE_TYPE_INTERVAL_YM = 3007
    ORA_NATIVE_TYPE_LOB         = 3008
    ORA_NATIVE_TYPE_OBJECT      = 3009
    ORA_NATIVE_TYPE_STMT        = 3010
    ORA_NATIVE_TYPE_BOOLEAN     = 3011
    ORA_NATIVE_TYPE_ROWID       = 3012
    ORA_NATIVE_TYPE_NUMBER      = 3013
end

@enum OraStatementType::UInt16 begin
    ORA_STMT_TYPE_UNKNOWN      = 0
    ORA_STMT_TYPE_SELECT       = 1
    ORA_STMT_TYPE_UPDATE       = 2
    ORA_STMT_TYPE_DELETE       = 3
    ORA_STMT_TYPE_INSERT       = 4
    ORA_STMT_TYPE_CREATE       = 5
    ORA_STMT_TYPE_DROP         = 6
    ORA_STMT_TYPE_ALTER        = 7
    ORA_STMT_TYPE_BEGIN        = 8
    ORA_STMT_TYPE_DECLARE      = 9
    ORA_STMT_TYPE_CALL         = 10
    ORA_STMT_TYPE_EXPLAIN_PLAN = 15
    ORA_STMT_TYPE_MERGE        = 16
    ORA_STMT_TYPE_ROLLBACK     = 17
    ORA_STMT_TYPE_COMMIT       = 21
end

@enum OraPoolCloseMode::UInt32 begin
    ORA_MODE_POOL_CLOSE_DEFAULT = 0x0000
    ORA_MODE_POOL_CLOSE_FORCE   = 0x0001
end


#
# Enable bit arithmetic for enums that can be "ored" together.
#

Base.:|(a::OraExecMode, b::OraExecMode) = UInt32(a) | UInt32(b)
