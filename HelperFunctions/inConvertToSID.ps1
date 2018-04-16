function inConvertToSID
{
    [CmdletBinding()]
    Param(
        # User or Computer object's objectSID property in the byte array form.
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $ByteArray
    )

    begin
    {
        $Stream = @()
    }

    process
    {
        foreach ($Byte in $ByteArray)
        {
            $Stream += $Byte
        }
    }
    
    end
    {
        # Revision and IdentifierAuthority
        $Result = "S-{0}-{1}" -f $Stream[0], $Stream[7]

        # SubAuthority
        for ($i = 0; $i -lt $Stream[1]; $i++)
        {
            $off = $i * 4
            $Result = "$Result-{0}" -f $([uint32]$Stream[8 + $off] -bor ([uint32]$Stream[9 + $off] -shl 8) -bor ([uint32]$Stream[10 + $off] -shl 16) -bor ([uint32]$Stream[11 + $off] -shl 24))
        }
        return $Result
    }
}
